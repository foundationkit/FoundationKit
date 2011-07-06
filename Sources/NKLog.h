// Part of FoundationKit http://foundationk.it

// See http://stackoverflow.com/questions/2632300/looping-through-macro-varargs-values
// Derived from https://github.com/VTPG/CommonCode/blob/master/VTPG_Common.m by Vincent Gable

#import <Cocoa/Cocoa.h>
#include <stdarg.h>


extern const NSString *kNRInternalDontOutputMe = @"don't output me"

#define PP_NARG(...) PP_NARG_(__VA_ARGS__,PP_RSEQ_N())
#define PP_NARG_(...) PP_ARG_N(__VA_ARGS__)
#define PP_ARG_N(_1, _2, _3, _4, _5, _6, _7, _8, _9,_10,...)\
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

#define PP_RSEQ_N() kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe, kNRInternalDontOutputMe


PP_NARG(0, 1,2,3,4,5,6,7,8)


#define Log(_X_) do{\
__typeof__(_X_) _Y_ = (_X_);\
const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
if(_STR_)\
DDLogInfo(@"%s = %@", #_X_, _STR_);\
else\
DDLogInfo(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}while(0)

NSString * VTPG_DDToStringFromTypeAndValue(const char * typeCode, void * value);


# define NKLog(...) _NKLog([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, , @"" # __VA_ARGS__, __VA_ARGS__)

static void _NKLog (NSString *file, unsigned int line, unsigned int n_args, NSString *commaSeparatedParameterNames, ...) {
    va_list ap;
    va_start(ap, commaSeparatedParameterNames);
    NSArray *parameterNames = [commaSeparatedParameterNames componentsSeparatedByString:@", "];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\n" options:0 error:nil];

    NSString *msg = [NSString stringWithFormat:@"[%@:%u] ", file, line];
    BOOL alreadySplit = NO;
    for (unsigned int i = 0; i < n_args; i++) {
        id obj = va_arg(ap, id);
        NSString *desc = [[parameterNames objectAtIndex:i] stringByAppendingString: @" = "];
        if([desc characterAtIndex:0] == '@')
            desc = @"";
        obj = [obj description];
        if ([obj hasPrefix:@" "] || [obj hasSuffix:@" "])
            obj = [[@"@\"" stringByAppendingString:obj] stringByAppendingString:@"\""];
        obj = [regex stringByReplacingMatchesInString:obj
                                              options:0
                                                range:NSMakeRange(0, [obj length])
                                         withTemplate:@"\n  "];
        desc = [desc stringByAppendingString:obj];
        if([msg length] + [desc length] > 60 || alreadySplit) {
            desc = [@"\n  " stringByAppendingString:desc];
            alreadySplit = YES;
        }
        if(i == n_args - 1)
            msg = [msg stringByAppendingFormat:@"%@", desc];
        else
            msg = [msg stringByAppendingFormat:@"%@, ", desc];
    }
    NSLog(@"%@", msg);

    va_end(ap);
}

