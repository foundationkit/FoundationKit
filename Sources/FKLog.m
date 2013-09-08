#import "FKLog.h"

#if	TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#endif

const NSString *kFKLogInternalDontOutputMe = @"don't output me";

static BOOL FKTypeCodeIsCharArray(const char *typeCode);
static NSString* FKStringFromBoolOrCharValue(BOOL boolOrCharvalue);
static NSString *FKStringFromFourCharCodeOrUnsignedInt32(FourCharCode fourcc);
static NSString *FKStringFromNSDecimalWithCurrentLocal(NSDecimal dcm);
static NSString * FKStringFromTypeAndValue(const char * typeCode, void * value);

NSString *_FKLogToString(NSString *file, unsigned int line, ...) {
  va_list ap;
  va_start(ap, line);

  NSMutableString *msg = [NSMutableString stringWithFormat:@"[%@:%u]", file, line];
  
  while (true) {
    char *argumentTypeEncoding = va_arg(ap, char *);
    char *argumentName = va_arg(ap, char *);
    void *argument = va_arg(ap, void *);
    
    if (*(void **)argument == (__bridge void *)kFKLogInternalDontOutputMe) {
      break;
    }

    // special case inline strings
    if ((strcmp(argumentTypeEncoding, @encode(id)) == 0) && (strncmp(argumentName, "@\"", 2) == 0)) {
      [msg appendFormat:@" %@", *(void **)argument];
    } else {
      NSString *stringRepresentation = FKStringFromTypeAndValue(argumentTypeEncoding,  argument);
      [msg appendFormat:@" %s = %@", argumentName, stringRepresentation];
    }
  }
  va_end(ap);
  
  return msg;
}


NS_INLINE BOOL FKTypeCodeIsCharArray(const char *typeCode){
    unsigned long lastCharOffset = strlen(typeCode) - 1;
    unsigned long secondToLastCharOffset = lastCharOffset - 1 ;

    BOOL isCharArray = typeCode[0] == '[' && typeCode[secondToLastCharOffset] == 'c' && typeCode[lastCharOffset] == ']';
    if(isCharArray) {
        // check if typeCode conforms to regexp: \[ (\d)+ c \]
        for(int i = 1; i < secondToLastCharOffset; i++) {
            if (!isdigit(typeCode[i])) {
                isCharArray = NO;
                break;
            }
        }
    }
    return isCharArray;
}

//since BOOL is #defined as a signed char, we treat the value as
//a BOOL if it is exactly YES or NO, and a char otherwise.
NS_INLINE NSString* FKStringFromBoolOrCharValue(BOOL boolOrCharvalue) {
	if(boolOrCharvalue == YES)
		return @"YES";
	if(boolOrCharvalue == NO)
		return @"NO";
	return [NSString stringWithFormat:@"'%c'", boolOrCharvalue];
}

NS_INLINE NSString *FKStringFromFourCharCodeOrUnsignedInt32(FourCharCode fourcc) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat"
	return [NSString stringWithFormat:@"%u ('%u%u%u%u')",
          fourcc,
          (fourcc >> 24) & 0xFF,
          (fourcc >> 16) & 0xFF,
          (fourcc >> 8) & 0xFF,
          fourcc & 0xFF];
#pragma clang diagnostic pop
}

NS_INLINE NSString *FKStringFromNSDecimalWithCurrentLocal(NSDecimal dcm) {
	return NSDecimalString(&dcm, [NSLocale currentLocale]);
}

NS_INLINE NSString * FKStringFromTypeAndValue(const char * typeCode, void * value) {
#define IF_TYPE_MATCHES_INTERPRET_WITH(typeToMatch,func) \
if (strcmp(typeCode, @encode(typeToMatch)) == 0) \
return (func)(*(typeToMatch*)value)
  
#if	TARGET_OS_IPHONE
	IF_TYPE_MATCHES_INTERPRET_WITH(CGPoint,NSStringFromCGPoint);
	IF_TYPE_MATCHES_INTERPRET_WITH(CGSize,NSStringFromCGSize);
	IF_TYPE_MATCHES_INTERPRET_WITH(CGRect,NSStringFromCGRect);
  IF_TYPE_MATCHES_INTERPRET_WITH(UIOffset,NSStringFromUIOffset);
  IF_TYPE_MATCHES_INTERPRET_WITH(UIEdgeInsets,NSStringFromUIEdgeInsets);
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
  
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(CFStringRef,@"%@"); //CFStringRef is toll-free bridged to NSString*
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(CFArrayRef,@"%@"); //CFArrayRef is toll-free bridged to NSArray*
  IF_TYPE_MATCHES_INTERPRET_WITH(FourCharCode, FKStringFromFourCharCodeOrUnsignedInt32);
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long long,@"%lld");
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned long long,@"%llu");
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(float,@"%f");
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(double,@"%f");

  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(short,@"%hi");
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned short,@"%hu");
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(int,@"%i");
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(unsigned, @"%u");
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long,@"%li");
  IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(long double,@"%Lf"); //WARNING on older versions of OS X, @encode(long double) == @encode(double)
  
	//C-strings
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(char*, @"%s");
	IF_TYPE_MATCHES_INTERPRET_WITH_FORMAT(const char*, @"%s");
	if(FKTypeCodeIsCharArray(typeCode))
		return [NSString stringWithFormat:@"%s", (char*)value];

  // objc object
  if (strcmp(typeCode, @encode(id)) == 0)
    return [NSString stringWithFormat:(@"%@"), (*(__unsafe_unretained id *)value)];

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
