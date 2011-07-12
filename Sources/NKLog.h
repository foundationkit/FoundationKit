// Part of FoundationKit http://foundationk.it

// Derived from https://github.com/VTPG/CommonCode/blob/master/VTPG_Common.m by Vincent Gable
// Derived from http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/

extern const void *kNRInternalEndVarArgs;

#define NKLog(...) fprintf(stderr, "%s", [NKLogToStr(__VA_ARGS__) UTF8String])

#define NKLogToStr(...) NKLogToStr_(__VA_ARGS__,NKLogToStr_RightSequence())
#define NKLogToStr_(...) NKLogToStr__(__VA_ARGS__)
#define NKLogToStr__(_1, _2, _3, _4, _5, _6, _7, _8, _9,_10,...) (NSString *) ^{\
  NKLogToStr_VarHelper(_1, x1);NKLogToStr_VarHelper(_2, x2);\
  NKLogToStr_VarHelper(_3, x3);NKLogToStr_VarHelper(_4, x4);\
  NKLogToStr_VarHelper(_5, x5);NKLogToStr_VarHelper(_6, x6);\
  NKLogToStr_VarHelper(_7, x7);NKLogToStr_VarHelper(_8, x8);\
  NKLogToStr_VarHelper(_9, x9);NKLogToStr_VarHelper(_10, x10);\
  return NKLogToStr___(\
  [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,\
  @encode(__typeof__(_1)), @"" # _1, &x1, \
  @encode(__typeof__(_2)), @"" # _2, &x2, \
  @encode(__typeof__(_3)), @"" # _3, &x3, \
  @encode(__typeof__(_4)), @"" # _4, &x4, \
  @encode(__typeof__(_5)), @"" # _5, &x5, \
  @encode(__typeof__(_6)), @"" # _6, &x6, \
  @encode(__typeof__(_7)), @"" # _7, &x7, \
  @encode(__typeof__(_8)), @"" # _8, &x8, \
  @encode(__typeof__(_9)), @"" # _9, &x9, \
  @encode(__typeof__(_10)), @"" # _10, &x10, kNRInternalEndVarArgs); }()

#define NKLogToStr_VarHelper(var, name) __typeof__(var) name = (var)
#define NKLogToStr_ArgHelper(var) @encode(__typeof__(var)), @"" # var, var,

#define NKLogToStr_RightSequence() kNRInternalEndVarArgs, kNRInternalEndVarArgs, kNRInternalEndVarArgs, kNRInternalEndVarArgs, kNRInternalEndVarArgs, kNRInternalEndVarArgs, kNRInternalEndVarArgs, kNRInternalEndVarArgs, kNRInternalEndVarArgs, kNRInternalEndVarArgs

NSString* NKLogToStr___ (NSString *file, unsigned int line, ...);
