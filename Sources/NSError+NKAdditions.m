#import "NSError+NKAdditions.h"


@implementation NSError (NKAdditions)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)description {
  NSDictionary *desc = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
  return [NSError errorWithDomain:domain code:code userInfo:desc];
}

@end
