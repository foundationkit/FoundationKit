#import "FKLog.h"

const NSString *kNRInternalDontOutputMe = @"don't output me";

// Copyright (c) 2008-2010, Vincent Gable.
// http://vincentgable.com
//
//based off http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
//
static BOOL TypeCodeIsCharArray(const char *typeCode){
	int lastCharOffset = strlen(typeCode) - 1;
	int secondToLastCharOffset = lastCharOffset - 1 ;
  
	BOOL isCharArray = typeCode[0] == '[' &&
  typeCode[secondToLastCharOffset] == 'c' && typeCode[lastCharOffset] == ']';
	for(int i = 1; i < secondToLastCharOffset; i++)
		isCharArray = isCharArray && isdigit(typeCode[i]);
	return isCharArray;
}

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


# define FKLogINTASDWIP(...) _FKLog([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, , @"" # __VA_ARGS__, __VA_ARGS__)

void FKLog___ (NSString *file, unsigned int line, ...) {
  unsigned int n_args;
  NSString *commaSeparatedParameterNames;
  va_list ap;
  va_start(ap, line);
  NSArray *parameterNames = [commaSeparatedParameterNames componentsSeparatedByString:@", "];
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\n" options:0 error:nil];
  
  NSString *msg = [NSString stringWithFormat:@"[%@:%u] ", file, line];
  BOOL alreadySplit = NO;
  for (unsigned int i = 0; i < n_args; i++) {
    id obj = (__bridge id)va_arg(ap, void *);
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



//since BOOL is #defined as a signed char, we treat the value as
//a BOOL if it is exactly YES or NO, and a char otherwise.
static NSString* VTPGStringFromBoolOrCharValue(BOOL boolOrCharvalue) {
	if(boolOrCharvalue == YES)
		return @"YES";
	if(boolOrCharvalue == NO)
		return @"NO";
	return [NSString stringWithFormat:@"'%c'", boolOrCharvalue];
}

static NSString *VTPGStringFromFourCharCodeOrUnsignedInt32(FourCharCode fourcc) {
	return [NSString stringWithFormat:@"%u ('%c%c%c%c')",
          fourcc,
          (fourcc >> 24) & 0xFF,
          (fourcc >> 16) & 0xFF,
          (fourcc >> 8) & 0xFF,
          fourcc & 0xFF];
}

static NSString *StringFromNSDecimalWithCurrentLocal(NSDecimal dcm) {
	return NSDecimalString(&dcm, [NSLocale currentLocale]);
}

NSString * VTPG_DDToStringFromTypeAndValue(const char * typeCode, void * value) {
#define IF_TYPE_MATCHES_INTERPRET_WITH(typeToMatch,func) \
if (strcmp(typeCode, @encode(typeToMatch)) == 0) \
return (func)(*(typeToMatch*)value)
  
#if	TARGET_OS_IPHONE
	IF_TYPE_MATCHES_INTERPRET_WITH(CGPoint,NSStringFromCGPoint);
	IF_TYPE_MATCHES_INTERPRET_WITH(CGSize,NSStringFromCGSize);
	IF_TYPE_MATCHES_INTERPRET_WITH(CGRect,NSStringFromCGRect);
#else
	IF_TYPE_MATCHES_INTERPRET_WITH(NSPoint,NSStringFromPoint);
	IF_TYPE_MATCHES_INTERPRET_WITH(NSSize,NSStringFromSize);
	IF_TYPE_MATCHES_INTERPRET_WITH(NSRect,NSStringFromRect);
#endif
	IF_TYPE_MATCHES_INTERPRET_WITH(NSRange,NSStringFromRange);
	IF_TYPE_MATCHES_INTERPRET_WITH(Class,NSStringFromClass);
	IF_TYPE_MATCHES_INTERPRET_WITH(SEL,NSStringFromSelector);
	IF_TYPE_MATCHES_INTERPRET_WITH(BOOL,VTPGStringFromBoolOrCharValue);
	IF_TYPE_MATCHES_INTERPRET_WITH(NSDecimal,StringFromNSDecimalWithCurrentLocal);
  
#define IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(typeToMatch,formatString) \
if (strcmp(typeCode, @encode(typeToMatch)) == 0) \
return [NSString stringWithFormat:(formatString), (*(typeToMatch*)value)]
  
  
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(CFStringRef,@"%@"); //CFStringRef is toll-free bridged to NSString*
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(CFArrayRef,@"%@"); //CFArrayRef is toll-free bridged to NSArray*
	IF_TYPE_MATCHES_INTERPRET_WITH(FourCharCode, VTPGStringFromFourCharCodeOrUnsignedInt32);
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long long,@"%lld");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned long long,@"%llu");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(float,@"%f");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(double,@"%f");
  if (strcmp(typeCode, @encode(id)) == 0)
    return [NSString stringWithFormat:(@"%@"), ((__bridge id)value)];
  
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(short,@"%hi");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned short,@"%hu");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(int,@"%i");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned, @"%u");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long,@"%i");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long double,@"%Lf"); //WARNING on older versions of OS X, @encode(long double) == @encode(double)
  
	//C-strings
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(char*, @"%s");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(const char*, @"%s");
	if(TypeCodeIsCharArray(typeCode))
		return [NSString stringWithFormat:@"%s", (char*)value];
  
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(void*,@"(void*)%p");
  
	//This is a hack to print out CLLocationCoordinate2D, without needing to #import <CoreLocation/CoreLocation.h>
	//A CLLocationCoordinate2D is a struct made up of 2 doubles.
	//We detect it by hard-coding the result of @encode(CLLocationCoordinate2D).
	//We get at the fields by treating it like an array of doubles, which it is identical to in memory.
	if(strcmp(typeCode, "{?=dd}")==0)//@encode(CLLocationCoordinate2D)
		return [NSString stringWithFormat:@"{latitude=%g,longitude=%g}",((double*)value)[0],((double*)value)[1]];
  
	//we don't know how to convert this typecode into an NSString
	return nil;
}
