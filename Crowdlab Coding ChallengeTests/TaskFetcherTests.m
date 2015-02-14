//
//  TaskFetcherTests.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TaskFetcher.h"

@interface TaskFetcherTests : XCTestCase

@end

@implementation TaskFetcherTests {
    TaskFetcher *sut;
}

- (void)setUp {
    [super setUp];
    sut = [TaskFetcher getFetcher];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    // We want the singleton to go away after each test so no state
    // is persisted.
    [sut forgetMe];
    
    // We forget our link to it.
    sut = nil;
    
    [super tearDown];
}

- (void)testTaskFetcherCanBeInstantiated {
    XCTAssertNotNil(sut,@"can't instantiate the TaskFetcher singleton");
}

- (void)testCheckFetcherHasParseMethod {
    XCTAssert([sut respondsToSelector:@selector(parseUrl:)], @"TaskFetcher needs to support the parseUrl:(NSString *) method.");
}

- (void)testCheckFetcherHasActualUrlMethod {
    XCTAssert([sut respondsToSelector:@selector(actualUrl:)], @"TaskFetcher needs to support the (NSURL *)actualUrl:(NSString *) method.");
}

- (void)testActualUrlMethodReturnsPathToFileIfNoURLProvided {
    NSString *result = [sut actualUrl:nil];
    XCTAssert(result,@"Resulting url is nil, expected something.");
}

- (void)testActualUrlMethodReturnsPathToFileIfBlankURLProvided {
    NSString *result = [sut actualUrl:@""];
    XCTAssert(result,@"Resulting url is nil, expected something.");
}

- (void)testActualUrlMethodReturnsURLIfUrlIsProvided {
    NSString *result = [sut actualUrl:@"http://testing.json"];
    NSString *testingUrl = @"http://testing.json";
    XCTAssertEqualObjects(result, testingUrl,@"When givin a url, the returned url should match.");
}

- (void)testCheckParseUrlLoadsTheFileToProcess {
    // parse the default (bundled) json file
    [sut parseUrl:@""];
    
    XCTAssertGreaterThan([sut.fileContents length],0,@"Before the file is parsed by TaskFetcher, it should be downloaded to fileContents.");
}

- (void)testCheckToSeeIfJSONLoads {
    [sut parseUrl:@""];
    XCTAssertEqual([sut.jsonResults count], 5, @"When loading JSON from the default file, we should be getting 5 items.");
}

- (void)testCheckToSeeIfEmptyJSONFlagsAnError {
    sut.defaultFilename = @"emptytasks";
    NSError *myErr = [sut parseUrl:@""];
    
    XCTAssertEqual(myErr.code, 3840,@"We should be getting a 3840 error here indicating the data is corrupted.");
}

- (void)testCheckToSeeIfBrokenJSONFlagsAnError {
    sut.defaultFilename = @"brokentasks";
    NSError *myErr = [sut parseUrl:@""];
    
    XCTAssertEqual(myErr.code, -47,@"We should be getting a -47 error here indicating the data is corrupted.");
}

@end
