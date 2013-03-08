// Part of FoundationKit http://foundationk.it

// check for common Debug-Macros and define custom Debug-Macro for check within FoundationKit
#if (defined(DEBUG) || defined(CONFIGURATION_Debug))
  #define FK_DEBUG
#endif

// Internal logging macro
#ifdef FK_DEBUG
  #define FKLogDebug(fmt, ...) do { NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); } while(0)
#else
  #define FKLogDebug(...) do { } while (0)
#endif

#define FKLogAlways(fmt, ...) do { NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); } while(0)


// Force a category to be loaded when an app starts up.
//
// Add this macro before each category implementation, so we don't have to use
// -all_load or -force_load to load object files from static libraries that only contain
// categories and no classes.
// See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.

#define FKLoadCategory(name) @interface FK_LOAD_CATEGORY_##name : NSObject @end @implementation FK_LOAD_CATEGORY_##name @end