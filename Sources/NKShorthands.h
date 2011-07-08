// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>


// Localization
#define _(x) NSLocalizedString(x, nil)

// Four char codes
NS_INLINE char * NKFcc(code) { return (char[5]){(code >> 24) & 0xFF, (code >> 16) & 0xFF, (code >> 8) & 0xFF, code & 0xFF, 0}; }

// Foundation functions for CF
NS_INLINE CFIndex CFMaxRange(CFRange range) { return (range.location + range.length); }
NS_INLINE Boolean CFLocationInRange(CFIndex location, CFRange range) { return (location >= range.location ? (location <= CFMaxRange(range) ? YES : NO) : NO); }
