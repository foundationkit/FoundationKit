#import "FKOperationQueueFinishedTests.h"
#import "NSArray+FKConcise.h"
#import "NSOperationQueue+FKBlocks.h"

@implementation FKOperationQueueFinishedTests

- (void)setUp {
  finishedCount = 0;
}

- (void)testQueueFinished {
  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
  NSArray *operations = @[[NSBlockOperation blockOperationWithBlock:^{ finishedCount++; }],
                               [NSBlockOperation blockOperationWithBlock:^{ finishedCount++; }]];
  
  [queue whenFinished:^{
    STAssertTrue(finishedCount == 2, @"Not all operations finished");
  }];
    
  [queue addOperations:operations waitUntilFinished:YES];
}

- (void)testRemove {
  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
  NSArray *operations = @[[NSBlockOperation blockOperationWithBlock:^{ finishedCount++; }],
                          [NSBlockOperation blockOperationWithBlock:^{ finishedCount++; }]];
  
  [queue whenFinished:^{
    finishedCount++;
    STFail(@"Observer didn't get removed, finished-block got executed");
  }];
  
  [queue removeFinishedBlock];
  [queue addOperations:operations waitUntilFinished:YES];
  
  STAssertTrue(finishedCount == 2, @"Observer didn't get removed");
}

@end
