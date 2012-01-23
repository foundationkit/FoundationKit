// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

/**
 This file contains several functions that can be used to get paths to specific folders in your App
 */

NSString* FKDocumentsDirectory(void); 
NSString* FKPathForResourceInDocumentsDirectory(NSString *resourceName);
NSString* FKLibraryDirectory(void);
NSString* FKPathForResourceInLibraryDirectory(NSString *resourceName);
NSString* FKCacheDirectory(void);
NSString* FKPathForResourceInCacheDirectory(NSString *resourceName);
NSString* FKApplicationSupportDirectory(void);
NSString* FKPathForResourceInApplicationSupportDirectory(NSString *resourceName);