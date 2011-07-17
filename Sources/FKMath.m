// Part of FoundationKit http://foundationk.it
//
// CGAffineTransform-helpers derived from http://iphonedevelopment.blogspot.com/2011/02/couple-cgaffinetransform-goodies.html

#import "FKMath.h"

NS_INLINE double FKDegreesToRadian(double angleInDegrees) {
  return (M_PI * (angleInDegrees) / 180.0);
}

NS_INLINE double FKRadianToDegrees(double angleInRadian) {
  return (M_PI * 180.0 / (angleInRadian));
}

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

NS_INLINE NSTimeInterval FKTimeIntervalDays(NSTimeInterval days) {
  return (NSTimeInterval)(days * 3600. * 24.);
}

NS_INLINE CGAffineTransform FKAffineTransformMakeRotateTranslate(CGFloat angle, CGFloat dx, CGFloat dy) {
    return CGAffineTransformMake(cosf(angle), sinf(angle), -sinf(angle), cosf(angle), dx, dy);
}

NS_INLINE CGAffineTransform FKAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy, CGFloat dx, CGFloat dy) {
    return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}