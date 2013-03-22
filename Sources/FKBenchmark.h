// Part of FoundationKit http://foundationk.it

#import <mach/mach_time.h>
#import "FKInternal.h"

/**
 If we are in Debug-Mode this functions benchmarks the given block and logs
 information about it's duration. Otherwise the block is just executed.
 
 @param title the name of the benchmark
 @param block the block to benchmark
 */
NS_INLINE void FKBenchmark(NSString *title, dispatch_block_t block) {
  if (block == nil) {
    return;
  }
  
#ifdef FK_DEBUG
  ^{
    FKLogAlways(@"'%@' benchmark started...", title ?: @"untitled");
    
    const uint64_t start = mach_absolute_time();
    block();
    const uint64_t end = mach_absolute_time();
    const uint64_t elapsedMTU = end - start;
    
    // Get information for converting from MTU to nanoseconds
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    // Get elapsed time in nanoseconds:
    const double elapsedNS = (double)elapsedMTU * (double)info.numer / (double)info.denom;
    FKLogAlways(@"'%@' benchmark finished: %fs (%fns)", title, elapsedNS / NSEC_PER_SEC, elapsedNS);
  }();
#else
  block();
#endif
}
