#import "NSData+NKBase64.h"


static const char _encode64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (NKBase64)

+ (NSData *)dataWithBase64String:(NSString *)string {
  if ([string length] <= 0) {
    return [NSData data];
  }
  
  // Build decoding table
  char decode64[256];
  memset(decode64, CHAR_MAX, 256);
  for (int i=0; i<64; i++) {
    decode64[(short)_encode64[i]] = i;
  }
  
  // Get data from string and init buffer
  const char *bytes = [string UTF8String];
  NSUInteger numBytes = [string length];
  
  NSUInteger dataLen = ((numBytes + 3) / 4) * 3;
  NSUInteger dataOffset = 0;
  char data[dataLen];
  
  NSUInteger i = 0;
  
  while (YES) {
    char buffer[4];
    short bufferOffset;
    
    for (bufferOffset = 0; bufferOffset < 4; i++) {
      short c = bytes[i];
      if (c == '\0') {
        break;
      }
      
      else if (isspace(c) || c == '=') {
        continue;
      }
      
      buffer[bufferOffset] = decode64[c];
      if (buffer[bufferOffset++] == CHAR_MAX) {
        return nil;
      }
    }
    
    if (bufferOffset == 0) {
      break;
    }
    else if(bufferOffset == 1) {
      return nil;
    }
    
    // Decode characters to bytes
    data[dataOffset++] = (buffer[0] << 2) | (buffer[1] >> 4);
    if (bufferOffset > 2) {
      data[dataOffset++] = (buffer[1] << 4) | (buffer[2] >> 2);
    }
    if (bufferOffset > 3) {
      data[dataOffset++] = (buffer[2] << 6) | buffer[3];
    }
  }
  
  return [NSData dataWithBytes:data length:dataLen];
}

- (NSString *)base64String {
  if ([self length] <= 0) {
    return @"";
  }
  
  // Get data bytes and length
  char *bytes = (char *)[self bytes];
  NSUInteger numBytes = [self length];
  
  // Output buffer
  NSUInteger offset = 0;
  NSUInteger outputLen = ((numBytes + 2) / 3) * 4; 
  char output[outputLen];
  
  // Convert data
  NSUInteger i = 0;
  
  while (i < numBytes) {
    char buffer[3] = {0};
    short bufferLen = 0;
    
    while (bufferLen < 3 && i < numBytes) {
      buffer[bufferLen++] = bytes[i++];
    }
    
    // Encode bytes to characters
    output[offset++] = _encode64[(buffer[0] & 0xFC) >> 2];
    output[offset++] = _encode64[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
    
    if (bufferLen > 1) {
      output[offset++] = _encode64[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
    }
    else {
      output[offset++] = '=';
    }
    
    if (bufferLen > 2) {
      output[offset++] = _encode64[buffer[2] & 0x3F];
    }
    else {
      output[offset++] = '=';
    }
  }
  
  // Generate output string
  NSString *encoded = [[NSString alloc] initWithBytes:output
                                               length:offset
                                             encoding:NSASCIIStringEncoding];
  
  return encoded;
}

@end
