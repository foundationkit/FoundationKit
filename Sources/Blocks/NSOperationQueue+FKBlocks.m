#import "NSOperationQueue+FKBlocks.h"
#import "NSObject+FKSwizzle.h"
#import "NSObject+FKAssociatedObjects.h"
#import "FKInternal.h"
#import "NSObject+FKObserver.h"

FKLoadCategory(NSOperationQueueFKBlocks);

#define kFKOperationCountKeyPath  @"operationCount"

/**
 Internal class that acts as the observer for the keyPath "operationCount" for all NSOperationQueues
 */
@interface FKObserver : NSObject 
@end

@interface NSOperationQueue ()

@property (nonatomic, copy) dispatch_block_t fk_finishedBlock;

@end

static char finishedBlockKey;
static char finishedContext;
static FKObserver *observer = nil;

@implementation NSOperationQueue (FKBlocks)

- (void)whenFinished:(void (^)())block {
  self.fk_finishedBlock = block;
  
  [self addObserver:observer
         forKeyPath:kFKOperationCountKeyPath 
            options:NSKeyValueObservingOptionNew
            context:&finishedContext];
}

- (void)removeFinishedBlock {
  self.fk_finishedBlock = nil;
}

- (dispatch_block_t)fk_finishedBlock {
  return [self associatedValueForKey:&finishedBlockKey];
}

- (void)setFk_finishedBlock:(dispatch_block_t)fk_finishedBlock {
  [self associateCopiedValue:fk_finishedBlock withKey:&finishedBlockKey];
  
  if (fk_finishedBlock == nil) {
    [self safeRemoveObserver:observer forKeyPath:kFKOperationCountKeyPath];
  }
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Internal
////////////////////////////////////////////////////////////////////////

@implementation FKObserver

+ (void)initialize {
  if (self == [FKObserver class]) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      observer = [[FKObserver alloc] init];
    });
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([object isKindOfClass:[NSOperationQueue class]] && context == &finishedContext && [keyPath isEqualToString:kFKOperationCountKeyPath]) {
    NSOperationQueue *operationQueue = (NSOperationQueue *)object;
    
    if (operationQueue.operationCount == 0 && operationQueue.fk_finishedBlock != nil) {
      operationQueue.fk_finishedBlock();
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

@end