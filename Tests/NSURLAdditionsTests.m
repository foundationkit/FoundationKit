//
//  NSURLAdditionsTests.m
//  FoundationKit
//
//  Created by Matthias Tretter on 20.12.12.
//  Copyright (c) 2012 FoundationKit. All rights reserved.
//

#import "NSURLAdditionsTests.h"
#import "NSURL+FKQueryParameters.h"

@implementation NSURLAdditionsTests

- (void)testQueryParameters {
  NSURL *URL = [NSURL fkit_URLWithString:@"http://foundationk.it" queryValuesForKeys:nil];

  STAssertEqualObjects([URL absoluteString], @"http://foundationk.it", nil);

  URL = [NSURL fkit_URLWithString:@"http://foundationk.it" queryValuesForKeys:@"value1",@"key1",@"value2",@"key2",nil];
  STAssertEqualObjects([URL absoluteString], @"http://foundationk.it?key1=value1&key2=value2", nil);

  URL = [NSURL fkit_URLWithString:@"http://foundationk.it" queryValuesForKeys:@"value 1",@"key1",@"value 2",@"key2",nil];
  STAssertEqualObjects([URL absoluteString], @"http://foundationk.it?key1=value%201&key2=value%202", nil);
}

@end
