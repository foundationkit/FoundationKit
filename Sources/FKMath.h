// Part of FoundationKit http://foundationk.it
//
// CGAffineTransform-helpers derived from http://iphonedevelopment.blogspot.com/2011/02/couple-cgaffinetransform-goodies.html

// angle conversion
NS_INLINE double FKDegreesToRadian(double angleInDegrees);
NS_INLINE double FKRadianToDegrees(double angleInRadian);

// time functions
NS_INLINE NSTimeInterval FKTimeIntervalMilliseconds(NSTimeInterval milliseconds); 
NS_INLINE NSTimeInterval FKTimeIntervalSeconds(NSTimeInterval seconds);
NS_INLINE NSTimeInterval FKTimeIntervalMinutes(NSTimeInterval minutes);
NS_INLINE NSTimeInterval FKTimeIntervalHours(NSTimeInterval hours);
NS_INLINE NSTimeInterval FKTimeIntervalDays(NSTimeInterval days);


// returns a matrix that rotates and translates at one time
NS_INLINE CGAffineTransform FKAffineTransformMakeRotateTranslate(CGFloat angle, CGFloat dx, CGFloat dy);

// returns a matrix that scales and translates at one time
NS_INLINE CGAffineTransform FKAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy, CGFloat dx, CGFloat dy);