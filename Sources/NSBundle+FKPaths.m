#import "NSBundle+FKPaths.h"

FKLoadCategory(NSBundleFKPaths);

@implementation NSBundle (FKPaths)

- (NSString *)documentsDirectory {
  return FKDocumentsDirectory();
}

- (NSString *)libraryDirectory {
  return FKLibraryDirectory();
}

- (NSString *)applicationSupportDirectory {
  return FKApplicationSupportDirectory();
}

- (NSString *)cacheDirectory {
  return FKCacheDirectory();
}

@end
