// Part of FoundationKit http://foundationk.it
//
// See http://stackoverflow.com/questions/2632300/looping-through-macro-varargs-values
// Derived from https://github.com/VTPG/CommonCode/blob/master/VTPG_Common.m by Vincent Gable
// Derived from http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/

extern const NSString *kFKLogInternalDontOutputMe;

/**
 Macro to output debug-information to the console.

 Example:
 FKLog(aString) results in [Filename.m:Linenumber] aString = value of string
 */
#define FKLog(...) NSLog(@"%@", FKLogToString(__VA_ARGS__));

/**
 Macro to save debug-information into a NSString.
 
 Example:
 FKLogString(aString, aInt) results in [Filename.m:Linenumber] aString = value of string aInt = 13
 */
#define FKLogToString(...) _FKLogToString_(__VA_ARGS__,_FKLogToString_RightSequence())



#define _FKLogToString_(...) _FKLogToString__(__VA_ARGS__)
#define _FKLogToString__(_1, _2, _3, _4, _5, _6, _7, _8, _9,_10,...) ^{\
  __typeof__(_1) _T1 = (_1); \
  __typeof__(_2) _T2 = (_2); \
  __typeof__(_3) _T3 = (_3); \
  __typeof__(_4) _T4 = (_4); \
  __typeof__(_5) _T5 = (_5); \
  __typeof__(_6) _T6 = (_6); \
  __typeof__(_7) _T7 = (_7); \
  __typeof__(_8) _T8 = (_8); \
  __typeof__(_9) _T9 = (_9); \
  __typeof__(_10) _T10 = (_10); \
  return _FKLogToString(\
      [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,\
      @encode(__typeof__(_1)), "" # _1, &_T1, \
      @encode(__typeof__(_2)), "" # _2, &_T2, \
      @encode(__typeof__(_3)), "" # _3, &_T3, \
      @encode(__typeof__(_4)), "" # _4, &_T4, \
      @encode(__typeof__(_5)), "" # _5, &_T5, \
      @encode(__typeof__(_6)), "" # _6, &_T6, \
      @encode(__typeof__(_7)), "" # _7, &_T7, \
      @encode(__typeof__(_8)), "" # _8, &_T8, \
      @encode(__typeof__(_9)), "" # _9, &_T9, \
      @encode(__typeof__(_10)), "" # _10, &_T10); \
}()


#define _FKLogToString_RightSequence() kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe, kFKLogInternalDontOutputMe

NSString *_FKLogToString (NSString *file, unsigned int line, ...);