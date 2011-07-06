// Part of FoundationKit http://foundationk.it

// See http://stackoverflow.com/questions/2632300/looping-through-macro-varargs-values
// Derived from https://github.com/VTPG/CommonCode/blob/master/VTPG_Common.m by Vincent Gable

#import <Cocoa/Cocoa.h>
#include <stdarg.h>



#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)

/* C99-style: anonymous argument referenced by __VA_ARGS__, empty arg not OK */

# define N_ARGS(...) N_ARGS_HELPER1(__VA_ARGS__, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
# define N_ARGS_HELPER1(...) N_ARGS_HELPER2(__VA_ARGS__)
# define N_ARGS_HELPER2(x1, x2, x3, x4, x5, x6, x7, x8, x9, n, ...) n

# define NKLog(...) _NKLog([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, (1 * N_ARGS(__VA_ARGS__)), @"" # __VA_ARGS__, __VA_ARGS__)

#else

#error variadic macros for your compiler here

#endif

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

