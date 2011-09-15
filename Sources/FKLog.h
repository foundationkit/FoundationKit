// Part of FoundationKit http://foundationk.it

// See http://stackoverflow.com/questions/2632300/looping-through-macro-varargs-values
// Derived from https://github.com/VTPG/CommonCode/blob/master/VTPG_Common.m by Vincent Gable
// Derived from http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/

extern const NSString *kNRInternalDontOutputMe;

#define FKLog(...) FKLog_(__VA_ARGS__,FKLog_RightSequence())
#define FKLog_(...) FKLog__(__VA_ARGS__)
#define FKLog__(_1, _2, _3, _4, _5, _6, _7, _8, _9,_10,...) FKLog___(\
    [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,\
    @encode(__typeof__(_1)), @"" # _1, _1, \
    @encode(__typeof__(_2)), @"" # _2, _2, \
    @encode(__typeof__(_3)), @"" # _3, _3, \
    @encode(__typeof__(_4)), @"" # _4, _4, \
    @encode(__typeof__(_5)), @"" # _5, _5, \
    @encode(__typeof__(_6)), @"" # _6, _6, \
    @encode(__typeof__(_7)), @"" # _7, _7, \
    @encode(__typeof__(_8)), @"" # _8, _8, \
    @encode(__typeof__(_9)), @"" # _9, _9, \
    @encode(__typeof__(_10)), @"" # _10, _10)

#define FKLog_RightSequence() kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe

void FKLog___ (NSString *file, unsigned int line, ...);
