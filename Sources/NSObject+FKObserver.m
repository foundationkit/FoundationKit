#import "NSObject+FKObserver.h"

@implementation NSObject (FKObserver)

- (void)fkit_safeRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
  @try {
    [self removeObserver:observer forKeyPath:keyPath];
  }
  @catch (NSException *exception) {
    FKLogDebug(@"Tried to remove Observer '%@' for keyPath '%@' and got Exception: %@", observer, keyPath, exception);
  }
}

- (void)fkit_safeRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
  @try {
    if ([self respondsToSelector:@selector(removeObserver:forKeyPath:context:)]) {
      [self removeObserver:observer forKeyPath:keyPath context:context];
    } else {
      FKLogDebug(@"%@ does not respond to select removeObserver:forKeyPath:context, called removeObserver:forKeyPath: instead", self);
      [self removeObserver:observer forKeyPath:keyPath];
    }
  }
  @catch (NSException *exception) {
    FKLogDebug(@"Tried to remove Observer '%@' for keyPath '%@' in context and got Exception: %@", observer, keyPath, exception);
  }
}

@end
