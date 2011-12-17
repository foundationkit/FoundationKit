// Part of FoundationKit http://foundationk.it
//
// Derived from Marcus Zarra's Blog-Post: http://www.cimgf.com/2010/05/02/my-current-prefix-pch-file/

#import "FKInternal.h"

// Debug Branch
#ifdef FK_DEBUG

// Log error and abort in case condition evaluates to NO
#define FKAssert(condition, ...) do { if ((condition) == NO) { FKLogAlways(__VA_ARGS__); assert(condition); }} while(0)

// Release Branch
// We block assertions in release branch and only log errors
#else

// Only Log error
#define FKAssert(condition, ...) do { if ((condition) == NO) { FKLogAlways(__VA_ARGS__); }} while(0)

// Block assert()
#ifndef NDEBUG
  #define NDEBUG
#endif

// Block NSAssert()
#ifndef NS_BLOCK_ASSERTIONS
  #define NS_BLOCK_ASSERTIONS
#endif

// block Log() macro
#ifndef NO_LOG_MACROS
  #define NO_LOG_MACROS
#endif

#endif