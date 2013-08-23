// Part of FoundationKit http://foundationk.it
//
// Based on discussions on StackOverflow:
// http://stackoverflow.com/questions/510216/can-you-make-the-settings-in-settings-bundle-default-even-if-you-dont-open-the-s
// http://stackoverflow.com/questions/2076816/how-to-register-user-defaults-using-nsuserdefaults-without-overwriting-existing-v

#import <Foundation/Foundation.h>

@interface NSUserDefaults (FKAdditions)

- (void)fkit_registerDefaultsFromBundle:(NSString *)bundle file:(NSString *)file;
- (void)fkit_registerDefaultsFromSettingsBundle; // bundle = Settings.bundle, file = Root.plist

@end
