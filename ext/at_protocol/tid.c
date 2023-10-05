#include <ruby.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>

static VALUE atproto_module;
static VALUE tid_class;
const char b32_chars[32] = "234567abcdefghijklmnopqrstuvwxyz";

typedef struct {
  uint64_t timestamp;
  uint64_t clock_identifier;
} TID;

static VALUE tid_alloc(VALUE klass) {
  TID *tid = ALLOC(TID);
  return Data_Wrap_Struct(klass, 0, xfree, tid);
}

static VALUE tid_initialize(int argc, VALUE *argv, VALUE self) {
  VALUE time_arg = Qnil;
  VALUE clock_identifier_arg = Qnil;
  rb_scan_args(argc, argv, "02", &time_arg, &clock_identifier_arg);

  TID *tid;
  Data_Get_Struct(self, TID, tid);

  if (NIL_P(time_arg)) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    tid->timestamp = (uint64_t)tv.tv_sec * 1000000 + (uint64_t)tv.tv_usec;
  } else {
    if (!rb_obj_is_kind_of(time_arg, rb_cTime)) {
      rb_raise(rb_eTypeError, "Argument must be a Time object or nil");
      return Qnil;
    }

    struct timeval tv;
    tv.tv_sec = NUM2LONG(rb_funcall(time_arg, rb_intern("tv_sec"), 0));
    tv.tv_usec = NUM2LONG(rb_funcall(time_arg, rb_intern("tv_usec"), 0));
    tid->timestamp = (uint64_t)tv.tv_sec * 1000000 + (uint64_t)tv.tv_usec;
  }

  if (NIL_P(clock_identifier_arg)) {
    tid->clock_identifier = rand() & 0x3FF;
  } else {
    if (FIXNUM_P(clock_identifier_arg)) {
      tid->clock_identifier = NUM2LL(clock_identifier_arg) & 0x3FF;
    } else {
      rb_raise(rb_eTypeError, "Clock identifier must be a Fixnum or nil");
      return Qnil;
    }
  }

  return self;
}

static VALUE tid_to_time(VALUE self) {
  TID *tid;
  Data_Get_Struct(self, TID, tid);

  VALUE sec = LL2NUM(tid->timestamp / 1000000);
  VALUE usec = LL2NUM(tid->timestamp % 1000000);

  return rb_funcall(rb_cTime, rb_intern("at"), 2, sec, usec);
}

static VALUE tid_to_s(VALUE self) {
  TID *tid;
  Data_Get_Struct(self, TID, tid);

  char tid_str[14];
  for (int i = 0; i < 11; i++) {
    int index = (int)((tid->timestamp >> (50 - i * 5)) & 0x1F);
    tid_str[i] = b32_chars[index];
  }
  tid_str[11] = b32_chars[(int)(tid->clock_identifier >> 5) & 0x1F]; // Update encoding
  tid_str[12] = b32_chars[(int)tid->clock_identifier & 0x1F];
  tid_str[13] = '\0';

  return rb_str_new_cstr(tid_str);
}

static VALUE tid_get_clock_identifier(VALUE self) {
  TID *tid;
  Data_Get_Struct(self, TID, tid);

  return LL2NUM(tid->clock_identifier);
}

static VALUE tid_from_string(VALUE klass, VALUE str) {
  Check_Type(str, T_STRING);

  TID *tid;
  VALUE tid_obj = Data_Make_Struct(klass, TID, NULL, xfree, tid);

  if (RSTRING_LEN(str) != 13) {
    rb_raise(rb_eArgError, "TID string must be 13 characters long");
    return Qnil;
  }

  char tid_str[14];
  strncpy(tid_str, StringValueCStr(str), sizeof(tid_str));
  tid_str[13] = '\0';

  // Extract timestamp and clock identifier
  uint64_t timestamp = 0;
  uint64_t clock_identifier = 0;
  for (int i = 0; i < 11; i++) {
    char c = tid_str[i];
    const char *pos = strchr(b32_chars, c);
    if (pos == NULL) {
      rb_raise(rb_eArgError, "Invalid character in TID string");
      return Qnil;
    }
    int index = (int)(pos - b32_chars);
    timestamp = (timestamp << 5) | (index & 0x1F);
  }

  for (int i = 11; i < 13; i++) {
    char c = tid_str[i];
    const char *pos = strchr(b32_chars, c);
    if (pos == NULL) {
      rb_raise(rb_eArgError, "Invalid character in TID string");
      return Qnil;
    }
    int index = (int)(pos - b32_chars);
    clock_identifier = (clock_identifier << 5) | (index & 0x1F);
  }

  tid->timestamp = timestamp;
  tid->clock_identifier = clock_identifier;

  return tid_obj;
}
void Init_tid(void) {
  atproto_module = rb_define_module("ATProto");

  tid_class = rb_define_class_under(atproto_module, "TID", rb_cObject);
  rb_define_alloc_func(tid_class, tid_alloc);
  rb_define_method(tid_class, "initialize", tid_initialize, -1);
  rb_define_method(tid_class, "to_time", tid_to_time, 0);
  rb_define_method(tid_class, "to_s", tid_to_s, 0);
  rb_define_method(tid_class, "clock_id", tid_get_clock_identifier, 0);
  rb_define_singleton_method(tid_class, "from_string", tid_from_string, 1);
}
