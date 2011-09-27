#import "NSObject+FKObserver.h"

@implementation NSObject (FKObserver)

- (void)safeRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
  @try {
    [self removeObserver:observer forKeyPath:keyPath];
  }
  @catch (NSException *exception) {
    FKLogDebug(@"Tried to remove Observer '%@' for keyPath '%@' and got Exception: %@", observer, keyPath, exception);
  }
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
  @try {
    [self removeObserver:observer forKeyPath:keyPath context:context];
  }
  @catch (NSException *exception) {
    FKLogDebug(@"Tried to remove Observer '%@' for keyPath '%@' in context and got Exception: %@", observer, keyPath, exception);
  }
}

@end
