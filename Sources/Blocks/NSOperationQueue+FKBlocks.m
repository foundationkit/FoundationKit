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

@property (nonatomic, copy) dispatch_block_t fkit_finishedBlock;

@end

static char finishedBlockKey;
static char finishedContext;
static FKObserver *observer = nil;

@implementation NSOperationQueue (FKBlocks)

- (void)fkit_whenFinished:(void (^)())block {
  self.fkit_finishedBlock = block;
}

- (void)fkit_removeFinishedBlock {
  self.fkit_finishedBlock = nil;
}

- (dispatch_block_t)fkit_finishedBlock {
  return [self fkit_associatedValueForKey:&finishedBlockKey];
}

- (void)setfkit_finishedBlock:(dispatch_block_t)fkit_finishedBlock {
  dispatch_block_t finishedBlock = self.fkit_finishedBlock;
  
  if (fkit_finishedBlock != finishedBlock) {
    // old observer to remove?
    if (finishedBlock != nil) {
      [self removeObserver:observer forKeyPath:kFKOperationCountKeyPath];
    }
    
    [self fkit_associateCopiedValue:fkit_finishedBlock withKey:&finishedBlockKey];
    
    if (fkit_finishedBlock != nil) {
      [self addObserver:observer
             forKeyPath:kFKOperationCountKeyPath 
                options:NSKeyValueObservingOptionNew
                context:&finishedContext];
    }
  }
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark - Internal
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
    
    if (operationQueue.operationCount == 0 && operationQueue.fkit_finishedBlock != nil) {
      operationQueue.fkit_finishedBlock();
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

@end