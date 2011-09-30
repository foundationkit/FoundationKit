// Part of FoundationKit http://foundationk.it

#import <zlib.h>

typedef enum {
  FKUnzipFileTypeGzip = 1
} FKUnzipFileType;

NS_INLINE BOOL FKUnzip(FKUnzipFileType ftype, NSString *src, NSString *dst) {
  if (ftype == FKUnzipFileTypeGzip) {
    static unsigned rchunk = 16384;
    BOOL result = YES;
    gzFile file = gzopen([src UTF8String], "rb");
    FILE *dest = fopen([dst UTF8String], "w");
    unsigned char buffer[rchunk];
    int uncompressedLength;
    while ((uncompressedLength = gzread(file, buffer, rchunk)) ) {
      if (fwrite(buffer, 1, uncompressedLength, dest) != uncompressedLength || ferror(dest)) {
        result = NO;
        break;
      }
    }
    fclose(dest);
    gzclose(file);
    return result;
  }
  return NO;
}