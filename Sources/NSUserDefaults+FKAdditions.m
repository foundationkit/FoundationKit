// Part of FoundationKit http://foundationk.it

#import "NSUserDefaults+FKAdditions.h"

FKLoadCategory(NSUserDefaultsFKAdditions);

@implementation NSUserDefaults (FKAdditions)

- (void)registerDefaultsFromBundle:(NSString *)bundle file:(NSString *)file {
  NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[bundle stringByAppendingPathComponent:file]];
  NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
  NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
  
  for(NSDictionary *prefSpecification in preferences) {
    NSString *key = [prefSpecification objectForKey:@"Key"];
    id defaultValue = [prefSpecification objectForKey:@"DefaultValue"];
    
    if(key && defaultValue) {
      [defaultsToRegister setObject:defaultValue forKey:key];
    }
  }
  
  [self registerDefaults:defaultsToRegister];
}

- (void)registerDefaultsFromSettingsBundle {
  NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
  
  if(!settingsBundle) {
    // DDLogWarn(@"Could not find Settings.bundle");
    return;
  }
  
  [self registerDefaultsFromBundle:settingsBundle file:@"Root.plist"];
}

@end
