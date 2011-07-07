// Part of FoundationKit http://foundationk.it

#ifndef RK_INLINE
#define RK_INLINE static inline
#endif

// Localization
#define _(x) NSLocalizedString(x, nil)

// Four char codes
RK_INLINE char * NKFcc(code) { return (char[5]){(code >> 24) & 0xFF, (code >> 16) & 0xFF, (code >> 8) & 0xFF, code & 0xFF, 0}; }

// Foundation functions for CF
RK_INLINE CFIndex CFMaxRange(CFRange range) { return (range.location + range.length); }
RK_INLINE Boolean CFLocationInRange(CFIndex location, CFRange range) { return (location >= range.location ? (location <= CFMaxRange(range) ? YES : NO) : NO); }
