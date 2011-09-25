// Part of FoundationKit http://foundationk.it

// Internal logging macro
#ifdef FK_DEBUG
  #define FKLogDebug(fmt, ...) do { NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); } while(0)
#else
  #define FKLogDebug(...) do { } while (0)
#endif

#define FKLogAlways(fmt, ...) do { NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); } while(0)