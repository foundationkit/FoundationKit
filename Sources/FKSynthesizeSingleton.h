// Part of FoundationKit http://foundationk.it
//
// FKDefineSingletonUsingBlock derived from lukeredpath's gist: https://gist.github.com/1057420

#define FKSynthesizeSingletonForClass(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
static dispatch_once_t pred; \
dispatch_once(&pred, ^{ shared##classname = [[self alloc] init]; }); \
return shared##classname; \
}


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
return sharedObject_; \