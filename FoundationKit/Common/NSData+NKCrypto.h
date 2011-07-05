//
//  NSData+NKCrypto.h
//  FoundationKit
//
//  Created by Jim Dovey on 31.8.2008.
//  Licensed under BSD.
//
//  Modified by:
//      - Erik Aigner
//

#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>


extern NSString * const kNKCryptoErrorDomain;

@interface NSError (CommonCryptoErrorDomain)
+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status;
@end


@interface NSData (Digest)

- (NSData *)MD2Sum;
- (NSData *)MD4Sum;
- (NSData *)MD5Sum;
- (NSData *)SHA1Hash;
- (NSData *)SHA224Hash;
- (NSData *)SHA256Hash;
- (NSData *)SHA384Hash;
- (NSData *)SHA512Hash;

@end

@interface NSData (Cryptor)

- (NSData *)AES256EncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)decryptedAES256DataUsingKey:(id)key error:(NSError **)error;
- (NSData *)DESEncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)decryptedDESDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)CASTEncryptedDataUsingKey:(id)key error:(NSError **)error;
- (NSData *)decryptedCASTDataUsingKey:(id)key error:(NSError **)error;

@end

@interface NSData (LowLevelCryptor)

// Keys and initialization vectors: NSData or NSString
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key error:(CCCryptorStatus *)error;
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key options:(CCOptions)options error:(CCCryptorStatus *)error;
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key initializationVector:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error;
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key error:(CCCryptorStatus *)error;
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key options:(CCOptions)options error:(CCCryptorStatus *)error;
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key initializationVector:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error;

@end

@interface NSData (HMAC)

- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)algorithm;
- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key;

@end
