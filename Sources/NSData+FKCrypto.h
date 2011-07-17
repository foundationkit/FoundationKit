// Part of FoundationKit http://foundationk.it
//
// Derived from Jim Dovey's BSD-licensed AQToolkit: https://bitbucket.org/itay/bluemit/src/0a183f27bfae/Classes/Imported/AQCommonCrypto/NSData%2BCommonCrypto.h

#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>


extern NSString * const kFKCryptoErrorDomain;

@interface NSError (FKCrypto)
+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status;
@end


@interface NSData (FKDigest)

- (NSData *)MD2Sum;
- (NSData *)MD4Sum;
- (NSData *)MD5Sum;
- (NSData *)SHA1Hash;
- (NSData *)SHA224Hash;
- (NSData *)SHA256Hash;
- (NSData *)SHA384Hash;
- (NSData *)SHA512Hash;

@end

@interface NSData (FKCryptor)

- (NSData *)AES256EncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)decryptedAES256DataUsingKey:(id)key error:(NSError **)error;
- (NSData *)DESEncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)decryptedDESDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)CASTEncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)decryptedCASTDataUsingKey:(id)key error:(NSError **)error;

@end

@interface NSData (FKLowLevelCryptor)

// Keys and initialization vectors: NSData or NSString
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key error:(CCCryptorStatus *)error;
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key options:(CCOptions)options error:(CCCryptorStatus *)error;
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key initializationVector:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error;
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key error:(CCCryptorStatus *)error;
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key options:(CCOptions)options error:(CCCryptorStatus *)error;
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key initializationVector:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error;

@end

@interface NSData (FKHMAC)

- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)algorithm;
- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;

@end
