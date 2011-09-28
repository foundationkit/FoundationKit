#import "FKLog.h"

#if	TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#endif

const NSString *kNRInternalDontOutputMe = @"don't output me";

static BOOL FKTypeCodeIsCharArray(const char *typeCode);
static NSString* FKStringFromBoolOrCharValue(BOOL boolOrCharvalue);
static NSString *FKStringFromFourCharCodeOrUnsignedInt32(FourCharCode fourcc);
static NSString *FKStringFromNSDecimalWithCurrentLocal(NSDecimal dcm);
static NSString * FKStringFromTypeAndValue(const char * typeCode, void * value);

NSString *_FKLogToString(NSString *file, unsigned int line, ...) {
  va_list ap;
  va_start(ap, line);

  NSString *msg = [NSString stringWithFormat:@"[%@:%u]", file, line];
  
  while (true) {
    char *argumentTypeEncoding = va_arg(ap, char *);
    NSString *argumentName = va_arg(ap, NSString *);
    void *argument = va_arg(ap, void *);
    
    if (argument == (__bridge void *)kNRInternalDontOutputMe) {
      break;
    }
    
    NSString *stringRepresentation = FKStringFromTypeAndValue(argumentTypeEncoding, argument);
    msg = [msg stringByAppendingFormat:@" %@=%@", argumentName, stringRepresentation];
  }
  va_end(ap);
  
  return msg;
}


static BOOL FKTypeCodeIsCharArray(const char *typeCode){
	int lastCharOffset = strlen(typeCode) - 1;
	int secondToLastCharOffset = lastCharOffset - 1 ;
  
	BOOL isCharArray = typeCode[0] == '[' &&
  typeCode[secondToLastCharOffset] == 'c' && typeCode[lastCharOffset] == ']';
	for(int i = 1; i < secondToLastCharOffset; i++)
		isCharArray = isCharArray && isdigit(typeCode[i]);
	return isCharArray;
}

//since BOOL is #defined as a signed char, we treat the value as
//a BOOL if it is exactly YES or NO, and a char otherwise.
static NSString* FKStringFromBoolOrCharValue(BOOL boolOrCharvalue) {
	if(boolOrCharvalue == YES)
		return @"YES";
	if(boolOrCharvalue == NO)
		return @"NO";
	return [NSString stringWithFormat:@"'%c'", boolOrCharvalue];
}

static NSString *FKStringFromFourCharCodeOrUnsignedInt32(FourCharCode fourcc) {
	return [NSString stringWithFormat:@"%u ('%c%c%c%c')",
          fourcc,
          (fourcc >> 24) & 0xFF,
          (fourcc >> 16) & 0xFF,
          (fourcc >> 8) & 0xFF,
          fourcc & 0xFF];
}

static NSString *FKStringFromNSDecimalWithCurrentLocal(NSDecimal dcm) {
	return NSDecimalString(&dcm, [NSLocale currentLocale]);
}

static NSString * FKStringFromTypeAndValue(const char * typeCode, void * value) {
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
	IF_TYPE_MATCHES_INTERPRET_WITH(BOOL,FKStringFromBoolOrCharValue);
	IF_TYPE_MATCHES_INTERPRET_WITH(NSDecimal,FKStringFromNSDecimalWithCurrentLocal);
  
#define IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(typeToMatch,formatString) \
if (strcmp(typeCode, @encode(typeToMatch)) == 0) \
return [NSString stringWithFormat:(formatString), (*(typeToMatch*)value)]
  
#define IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(typeToMatch,formatString) \
if (strcmp(typeCode, @encode(typeToMatch)) == 0) \
return [NSString stringWithFormat:(formatString), value]
    
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(CFStringRef,@"%@"); //CFStringRef is toll-free bridged to NSString*
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(CFArrayRef,@"%@"); //CFArrayRef is toll-free bridged to NSArray*
	IF_TYPE_MATCHES_INTERPRET_WITH(FourCharCode, FKStringFromFourCharCodeOrUnsignedInt32);
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(long long,@"%lld");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(unsigned long long,@"%llu");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(float,@"%f");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(double,@"%f");
  
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(short,@"%hi");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(unsigned short,@"%hu");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(int,@"%i");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(unsigned, @"%u");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(long,@"%i");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(long double,@"%Lf"); //WARNING on older versions of OS X, @encode(long double) == @encode(double)
  
	//C-strings
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(char*, @"%s");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(const char*, @"%s");
	if(FKTypeCodeIsCharArray(typeCode))
		return [NSString stringWithFormat:@"%s", (char*)value];

  // objc object
  if (strcmp(typeCode, @encode(id)) == 0)
    return [NSString stringWithFormat:(@"%@"), ((__bridge id)value)];

	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT_WITHOUT_DEREFERENCING(void*,@"(void*)%p");
  
	//This is a hack to print out CLLocationCoordinate2D, without needing to #import <CoreLocation/CoreLocation.h>
	//A CLLocationCoordinate2D is a struct made up of 2 doubles.
	//We detect it by hard-coding the result of @encode(CLLocationCoordinate2D).
	//We get at the fields by treating it like an array of doubles, which it is identical to in memory.
	if(strcmp(typeCode, "{?=dd}")==0)//@encode(CLLocationCoordinate2D)
		return [NSString stringWithFormat:@"{latitude=%g,longitude=%g}",((double*)value)[0],((double*)value)[1]];
  
	//we don't know how to convert this typecode into an NSString
	return nil;
}
