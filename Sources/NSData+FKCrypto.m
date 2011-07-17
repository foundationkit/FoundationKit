#import "NSData+FKCrypto.h"

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>


NSString * const kFKCryptoErrorDomain = @"FKCryptoErrorDomain";

@implementation NSError (FKCrypto)

+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status {
  NSString *description = nil;
  NSString *reason = nil;
  switch (status) {
    case kCCSuccess:
      description = _(@"Success");
      break;
    case kCCParamError:
      description = _(@"Parameter Error");
      reason = _(@"Illegal parameter supplied to encryption/decryption algorithm");
      break;
    case kCCBufferTooSmall:
      description = _(@"Buffer Too Small");
      reason = _(@"Insufficient buffer provided for specified operation");
      break;
    case kCCMemoryFailure:
      description = _(@"Memory Failure");
      reason = _(@"Failed to allocate memory");
      break;
    case kCCAlignmentError:
      description = _(@"Alignment Error");
      reason = _(@"Input size to encryption algorithm was not aligned correctly");
      break;
    case kCCDecodeError:
      description = _(@"Decode Error");
      reason = _(@"Input data did not decode or decrypt correctly");
      break;
    case kCCUnimplemented:
      description = _(@"Unimplemented Function");
      reason = _(@"Function not implemented for the current algorithm");
      break;
    default:
      description = _(@"Unknown Error");
      break;
  }
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  [userInfo setObject:description forKey:NSLocalizedDescriptionKey];
  
  if (reason) {
    [userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
  }
  
  return [NSError errorWithDomain:kFKCryptoErrorDomain code:status userInfo:userInfo];
}

@end

#pragma mark -

@implementation NSData (FKDigest)

static NSData *nsdata_nk_digest(NSData *this, unsigned char *(*func)(const void *, CC_LONG, unsigned char *), size_t digestLen) {
  unsigned char hash[digestLen];
  func([this bytes], (CC_LONG)[this length], hash);
  return [NSData dataWithBytes:hash length:digestLen];
}

- (NSData *)MD2Sum {
  return nsdata_nk_digest(self, CC_MD2, CC_MD2_DIGEST_LENGTH);
}

- (NSData *)MD4Sum {
  return nsdata_nk_digest(self, CC_MD4, CC_MD4_DIGEST_LENGTH);
}

- (NSData *)MD5Sum {
  return nsdata_nk_digest(self, CC_MD5, CC_MD5_DIGEST_LENGTH);
}

- (NSData *)SHA1Hash {
  return nsdata_nk_digest(self, CC_SHA1, CC_SHA1_DIGEST_LENGTH);
}

- (NSData *)SHA224Hash {
  return nsdata_nk_digest(self, CC_SHA224, CC_SHA224_DIGEST_LENGTH);
}

- (NSData *)SHA256Hash {
  return nsdata_nk_digest(self, CC_SHA256, CC_SHA256_DIGEST_LENGTH);
}

- (NSData *)SHA384Hash {
  return nsdata_nk_digest(self, CC_SHA384, CC_SHA384_DIGEST_LENGTH);
}

- (NSData *)SHA512Hash {
  return nsdata_nk_digest(self, CC_SHA512, CC_SHA512_DIGEST_LENGTH);
}

@end

@implementation NSData (FKCrypto)

#define kNKCryptoEncrypt YES
#define kNKCryptoDecrypt NO

static NSData *nsdata_nk_crypt(BOOL encrypt, NSData *this, CCAlgorithm algo, id key, CCOptions opt, NSError **error) {
  CCCryptorStatus status = kCCSuccess;
  NSData *result = nil;
  if (encrypt) {
    result = [this dataEncryptedUsingAlgorithm:algo key:key options:opt error:&status];
  }
  else {
    result = [this decryptedDataUsingAlgorithm:algo key:key options:opt error:&status];
  }
  if (result) {
    return result;
  }
  if (error) {
    *error = [NSError errorWithCCCryptorStatus:status];
  }
  return nil;
}

- (NSData *)AES256EncryptedDataUsingKey:(id)key error:(NSError **)error {
  return nsdata_nk_crypt(kNKCryptoEncrypt, self, kCCAlgorithmAES128, key, kCCOptionPKCS7Padding, error);
}

- (NSData *)decryptedAES256DataUsingKey:(id)key error:(NSError **)error {
  return nsdata_nk_crypt(kNKCryptoDecrypt, self, kCCAlgorithmAES128, key, kCCOptionPKCS7Padding, error);
}

- (NSData *)DESEncryptedDataUsingKey:(id)key error:(NSError **)error {
  return nsdata_nk_crypt(kNKCryptoEncrypt, self, kCCAlgorithmDES, key, kCCOptionPKCS7Padding, error);
}

- (NSData *)decryptedDESDataUsingKey:(id)key error:(NSError **)error {
  return nsdata_nk_crypt(kNKCryptoDecrypt, self, kCCAlgorithmDES, key, kCCOptionPKCS7Padding, error);
}

- (NSData *)CASTEncryptedDataUsingKey:(id)key error:(NSError **)error {
  return nsdata_nk_crypt(kNKCryptoEncrypt, self, kCCAlgorithmCAST, key, kCCOptionPKCS7Padding, error);
}

- (NSData *)decryptedCASTDataUsingKey:(id)key error:(NSError **)error {
  return nsdata_nk_crypt(kNKCryptoDecrypt, self, kCCAlgorithmCAST, key, kCCOptionPKCS7Padding, error);
}

@end

@implementation NSData (FKLowLevelCryptor)

#define kNKDontEnforceKeyLength -1

static void nsdata_nk_enforce_key_len(CCAlgorithm algorithm, NSMutableData *keyData, NSMutableData *ivData) {
  NSUInteger keyLength = [keyData length];
  NSInteger forceTo = kNKDontEnforceKeyLength;
  switch (algorithm) {
    case kCCAlgorithmAES128: forceTo = (keyLength < 16 ? 16 : (keyLength < 24 ? 24 : 32)); break;
    case kCCAlgorithmDES: forceTo = 8; break;
    case kCCAlgorithm3DES: forceTo = 24; break;
    case kCCAlgorithmCAST: forceTo = (keyLength < 5 ? 5 : (keyLength > 16 ? 16 : kNKDontEnforceKeyLength)); break;
    case kCCAlgorithmRC4: forceTo = (keyLength > 512 ? 512 : kNKDontEnforceKeyLength); break;
  }
  if (forceTo != kNKDontEnforceKeyLength) {
    [keyData setLength:forceTo];
  }
  [ivData setLength:[keyData length]];
}

static NSData *nsdata_nk_run_cryptor(NSData *this, CCCryptorRef cryptor, CCCryptorStatus *status) {
  size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[this length], true);
  void * buf = malloc(bufsize);
  size_t bufused = 0;
  size_t bytesTotal = 0;
  *status = CCCryptorUpdate(cryptor, [this bytes], (size_t)[this length], buf, bufsize, &bufused);
  if (*status != kCCSuccess) {
    free(buf);
    return nil;
  }
  
  bytesTotal += bufused;
  
  // From Brent Royal-Gordon (Twitter: architechies):
  // Need to update buf ptr past used bytes when calling CCCryptorFinal()
  *status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
  if (*status != kCCSuccess) {
    free(buf);
    return nil;
  }
  
  bytesTotal += bufused;
  
  return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key error:(CCCryptorStatus *)error {
  return [self dataEncryptedUsingAlgorithm:algorithm key:key initializationVector:nil options:0 error:error];
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key options:(CCOptions)options error:(CCCryptorStatus *)error {
  return [self dataEncryptedUsingAlgorithm:algorithm key:key initializationVector:nil options:options error:error];
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key initializationVector:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error {
  CCCryptorRef cryptor = NULL;
  CCCryptorStatus status = kCCSuccess;
  
  assert([key isKindOfClass:[NSData class]] || [key isKindOfClass:[NSString class]]);
  assert(iv == nil || [iv isKindOfClass:[NSData class]] || [iv isKindOfClass:[NSString class]]);
  
  NSMutableData *keyData = nil;
  NSMutableData *ivData = nil;
  if ([key isKindOfClass:[NSData class]]) {
    keyData = (NSMutableData *)[key mutableCopy];
  }
  else {
    keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
  }
  if ([iv isKindOfClass:[NSString class]]) {
    ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
  }
  else {
    ivData = (NSMutableData *)[iv mutableCopy];
  }
  
  // Ensure correct lengths for key and iv data, based on algorithms
  nsdata_nk_enforce_key_len(algorithm, keyData, ivData);
  status = CCCryptorCreate(kCCEncrypt, algorithm, options, [keyData bytes], [keyData length], [ivData bytes], &cryptor);
  if (status != kCCSuccess) {
    if ( error != NULL ) {
      *error = status;
    }
    return nil;
  }
  
  NSData *result = nsdata_nk_run_cryptor(self, cryptor, &status);
  if (!result && error) {
    *error = status;
  }
  
  CCCryptorRelease(cryptor);
  
  return result;
}

- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key error:(CCCryptorStatus *)error {
  return [self decryptedDataUsingAlgorithm:algorithm key:key initializationVector:nil options:0 error:error];
}

- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key options:(CCOptions)options error:(CCCryptorStatus *)error {
  return [self decryptedDataUsingAlgorithm:algorithm key:key initializationVector:nil options:options error:error];
}

- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key initializationVector:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error {
  CCCryptorRef cryptor = NULL;
  CCCryptorStatus status = kCCSuccess;
  
  assert([key isKindOfClass:[NSData class]] || [key isKindOfClass:[NSString class]]);
  assert(iv == nil || [iv isKindOfClass:[NSData class]] || [iv isKindOfClass:[NSString class]]);
  
  NSMutableData *keyData = nil;
  NSMutableData *ivData = nil;
  if ([key isKindOfClass:[NSData class]]) {
    keyData = (NSMutableData *)[key mutableCopy];
  }
  else {
    keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
  }
  if ([iv isKindOfClass:[NSString class]]) {
    ivData = [[iv dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
  }
  else {
    ivData = (NSMutableData *)[iv mutableCopy];
  }
  
  // Ensure correct lengths for key and iv data, based on algorithms
  nsdata_nk_enforce_key_len(algorithm, keyData, ivData);
  
  status = CCCryptorCreate(kCCDecrypt, algorithm, options, [keyData bytes], [keyData length], [ivData bytes], &cryptor);
  if (status != kCCSuccess) {
    if (error) {
      *error = status;
    }
    return nil;
  }
  
  NSData *result = nsdata_nk_run_cryptor(self, cryptor, &status);
  if (!result && error) {
    *error = status;
  }
  
  CCCryptorRelease(cryptor);
  
  return result;
}

@end

@implementation NSData (FKHMAC)

- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)algorithm {
  return [self HMACWithAlgorithm:algorithm key:nil];
}

- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key {
  assert(key == nil || [key isKindOfClass:[NSData class]] || [key isKindOfClass:[NSString class]]);
  NSData *keyData = nil;
  if ([key isKindOfClass:[NSString class]]) {
    keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
  }
  else {
    keyData = (NSData *)key;
  }
  
  // This could be either CC_SHA1_DIGEST_LENGTH or CC_MD5_DIGEST_LENGTH. SHA1 is larger.
  unsigned char buf[CC_SHA1_DIGEST_LENGTH];
  CCHmac(algorithm, [keyData bytes], [keyData length], [self bytes], [self length], buf);
  
  return [NSData dataWithBytes:buf length:(algorithm == kCCHmacAlgMD5 ? CC_MD5_DIGEST_LENGTH : CC_SHA1_DIGEST_LENGTH)];
}

@end
