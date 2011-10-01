// Part of FoundationKit http://foundationk.it

#import <mach/mach_time.h>

NS_INLINE void FKBenchmark(char *title, dispatch_block_t b) {
  if (b == NULL) {
    return;
  }
  if (title == NULL) {
    title = "<untitled>";
  }
#ifdef DEBUG
  ^{
    const uint64_t start = mach_absolute_time();
    NSLog(@"'%s' benchmark started...", title);
    b();
    const uint64_t end = mach_absolute_time();
    const uint64_t elapsedMTU = end - start;
    
    // Get information for converting from MTU to nanoseconds
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    // Get elapsed time in nanoseconds:
    const double elapsedNS = (double)elapsedMTU * (double)info.numer / (double)info.denom;
    NSLog(@"'%s' benchmark finished: %fs (%fns)", title, elapsedNS / NSEC_PER_SEC, elapsedNS);
  }();
#else
  b();
#endif
}
