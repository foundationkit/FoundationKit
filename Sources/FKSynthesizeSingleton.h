// Part of FoundationKit http://foundationk.it
//
// FKDefineSingletonUsingBlock derived from lukeredpath's gist: https://gist.github.com/1057420


// Use like this:
// + (id)sharedInstance {
//  FKDefineSingletonUsingBlock(^{
//    return [[self alloc] init];
//  });
// }

#define FKDefineSingletonUsingBlock(block) \
static dispatch_once_t pred; \
__strong static id sharedObject_ = nil; \
dispatch_once(&pred, ^{ sharedObject_ = block(); }); \
return sharedObject_;