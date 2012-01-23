#import "FKPaths.h"

NSString* FKDocumentsDirectory(void) {
  static __strong NSString *directory = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    directory = [directories firstObject];
  });
  
  return directory;
}

NSString* FKPathForResourceInDocumentsDirectory(NSString *resourceName) {
  return [FKDocumentsDirectory() stringByAppendingPathComponent:resourceName];
}

NSString* FKLibraryDirectory(void) {
  static __strong NSString *directory = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    directory = [directories firstObject];
  });
  
  return directory;
}

NSString* FKPathForResourceInLibraryDirectory(NSString *resourceName) {
  return [FKLibraryDirectory() stringByAppendingPathComponent:resourceName];
}

NSString* FKCacheDirectory(void) {
  static __strong NSString *directory = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    directory = [directories firstObject];
  });
  
  return directory;
}

NSString* FKPathForResourceInCacheDirectory(NSString *resourceName) {
  return [FKCacheDirectory() stringByAppendingPathComponent:resourceName];
}

NSString* FKApplicationSupportDirectory(void) {
  static __strong NSString *directory = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray* directories = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    directory = [directories firstObject];
  });
  
  return directory;
}

NSString* FKPathForResourceInApplicationSupportDirectory(NSString *resourceName) {
  return [FKApplicationSupportDirectory() stringByAppendingPathComponent:resourceName];
}