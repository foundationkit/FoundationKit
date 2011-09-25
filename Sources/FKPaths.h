// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

NS_INLINE NSString* FKDocumentsDirectory() {
  static NSString* directory = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    directory = [directories firstObject];
  });
  
  return directory;
}

NS_INLINE NSString* FKPathForResourceInDocumentsDirectory(NSString *resourceName) {
  return [FKDocumentsDirectory() stringByAppendingPathComponent:resourceName];
}

NS_INLINE NSString* FKLibraryDirectory() {
  static NSString* directory = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    directory = [directories firstObject];
  });
  
  return directory;
}

NS_INLINE NSString* FKPathForResourceInLibraryDirectory(NSString *resourceName) {
  return [FKLibraryDirectory() stringByAppendingPathComponent:resourceName];
}

NS_INLINE NSString* FKCacheDirectory() {
  static NSString* directory = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    directory = [directories firstObject];
  });
  
  return directory;
}

NS_INLINE NSString* FKPathForResourceInCacheDirectory(NSString *resourceName) {
  return [FKCacheDirectory() stringByAppendingPathComponent:resourceName];
}

NS_INLINE NSString* FKApplicationSupportDirectory() {
  static NSString* directory = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    directory = [directories firstObject];
  });
  
  return directory;
}

NS_INLINE NSString* FKPathForResourceInApplicationSupportDirectory(NSString *resourceName) {
  return [FKApplicationSupportDirectory() stringByAppendingPathComponent:resourceName];
}