// Part of FoundationKit http://foundationk.it

// Localization
#define _(x) NSLocalizedString(x, nil)

// Four char codes
#define NKFcc(code) (char[5]){(code >> 24) & 0xFF, (code >> 16) & 0xFF, (code >> 8) & 0xFF, code & 0xFF, 0}

// Foundation functions for CF
#define CFMaxRange(r) (r.location + r.length)
#define CFLocationInRange(l, r) (l >= r.location ? (l <= CFMaxRange(r) ? YES : NO) : NO)
