// Part of FoundationKit http://foundationk.it
//
// CGAffineTransform-helpers derived from http://iphonedevelopment.blogspot.com/2011/02/couple-cgaffinetransform-goodies.html

#if	TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#endif

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Degree/Radian Conversion
////////////////////////////////////////////////////////////////////////

NS_INLINE double FKDegreesToRadian(double angleInDegrees) {
  return (M_PI * (angleInDegrees) / 180.0);
}

NS_INLINE double FKRadianToDegrees(double angleInRadian) {
  return (M_PI * 180.0 / (angleInRadian));
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSTimeInterval Helper
////////////////////////////////////////////////////////////////////////

NS_INLINE NSTimeInterval FKTimeIntervalMilliseconds(NSTimeInterval milliseconds) {
  return (NSTimeInterval)(milliseconds/ 1000.);
}

NS_INLINE NSTimeInterval FKTimeIntervalSeconds(NSTimeInterval seconds) {
  return seconds;
}

NS_INLINE NSTimeInterval FKTimeIntervalMinutes(NSTimeInterval minutes) {
  return (NSTimeInterval)(minutes * 60.);
}

NS_INLINE NSTimeInterval FKTimeIntervalHours(NSTimeInterval hours) {
  return (NSTimeInterval)(hours * 3600.);
}

// Note: Not every day has exactly 86400 Seconds, make sure to use NSCalendar if you need exact calculation
NS_INLINE NSTimeInterval FKTimeIntervalDays(NSTimeInterval days) {
  return (NSTimeInterval)(days * 3600. * 24.);
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark CGAffineTransform Helper
////////////////////////////////////////////////////////////////////////

NS_INLINE CGAffineTransform FKAffineTransformMakeRotateTranslate(CGFloat angle, CGFloat dx, CGFloat dy) {
  return CGAffineTransformMake(cosf(angle), sinf(angle), -sinf(angle), cosf(angle), dx, dy);
}

NS_INLINE CGAffineTransform FKAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy, CGFloat dx, CGFloat dy) {
  return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Number Helper
////////////////////////////////////////////////////////////////////////

NS_INLINE NSInteger FKLimitInteger(NSInteger number, NSInteger min, NSInteger max) {
  NSInteger bound = MAX(number, min);
  return MIN(bound, max);
}

NS_INLINE CGFloat FKLimitFloat(CGFloat number, CGFloat min, CGFloat max) {
  CGFloat bound = MAX(number, min);
  return MIN(bound, max);
}

NS_INLINE double FKLimitDouble(double number, double min, double max) {
  double bound = MAX(number, min);
  return MIN(bound, max);
}

NS_INLINE NSInteger FKSignumInteger(NSInteger number) {
  if (number == 0) {
    return 0;
  }
  
  return number > 0 ? 1 : -1;
}

NS_INLINE CGFloat FKSignumFloat(CGFloat number) {
  if (number == 0.f) {
    return 0.f;
  }

  return number > 0.f ? 1.f : -1.f;
}

NS_INLINE double FKSignumDouble(double number) {
  if (number == 0.) {
    return 0.;
  }

  return number > 0. ? 1. : -1.;
}

