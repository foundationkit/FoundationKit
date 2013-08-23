// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>


@interface NSError (FKAdditions)

+ (NSError *)fkit_errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)description;

@end
