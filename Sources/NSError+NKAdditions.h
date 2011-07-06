// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>


@interface NSError (NKAdditions)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)description;

@end
