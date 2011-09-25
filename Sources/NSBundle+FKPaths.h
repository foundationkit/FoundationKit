// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

/**
 This category adds shortcuts to various important directories to NSBundle.
 It uses the FK-Directory-Functions.
 
 @see FKPaths
 */

@interface NSBundle (FKPaths)

- (NSString *)documentsDirectory;
- (NSString *)libraryDirectory;
- (NSString *)applicationSupportDirectory;
- (NSString *)cacheDirectory;

@end
