// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>


// TODO: implement for other types
#define NKShow(param) (^{ \
  char *h = @encode(__typeof__(param)); \
  if (!strcmp(h, @encode(CGRect))) { \
    CGRect *r = (CGRect *)&param; \
    printf("%s (CGRect): {%f, %f, %f, %f}\n", #param, r->origin.x, r->origin.y, r->size.width, r->size.height); \
  } \
  else { \
    printf("%s (unknown type)\n", #param); \
  } \
}());
