// Part of FoundationKit http://foundationk.it
//
// CGAffineTransform-helpers derived from http://iphonedevelopment.blogspot.com/2011/02/couple-cgaffinetransform-goodies.html

// angle conversion
NS_INLINE double NKDegreesToRadian(double angleInDegrees);
NS_INLINE double NKRadianToDegrees(double angleInRadian);

// time functions
NS_INLINE NSTimeInterval NKTimeIntervalMilliseconds(NSTimeInterval milliseconds); 
NS_INLINE NSTimeInterval NKTimeIntervalSeconds(NSTimeInterval seconds);
NS_INLINE NSTimeInterval NKTimeIntervalMinutes(NSTimeInterval minutes);
NS_INLINE NSTimeInterval NKTimeIntervalHours(NSTimeInterval hours);
NS_INLINE NSTimeInterval NKTimeIntervalDays(NSTimeInterval days);


// returns a matrix that rotates and translates at one time
NS_INLINE CGAffineTransform NKAffineTransformMakeRotateTranslate(CGFloat angle, CGFloat dx, CGFloat dy);

// returns a matrix that scales and translates at one time
NS_INLINE CGAffineTransform NKAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy, CGFloat dx, CGFloat dy);