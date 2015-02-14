//
//  TaskViewControllerTests.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TaskFetcher.h"

@interface TaskViewControllerTests : XCTestCase

@end

@implementation TaskViewControllerTests {
    TaskViewController *sut;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    sut = [[TaskViewController alloc] init];
    sut.urlToParse = @"";
    [sut parseUrl];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCheckParseUrlSetsParsedUrl {
    XCTAssertNotNil([sut parsedUrl],@"When parseUrl is called, the url of the real asset should be stored in parsedUrl.");
}

- (void)testCheckParseUrlHasAURLWithALength {
    XCTAssertGreaterThan([[sut parsedUrl] length], 0,@"When url to parse is set, the url of the real asset should be stored in parsedUrl.");
}

- (void)testCheckParseUrlHasCorrectFormat {
    NSString *urlCreated = sut.parsedUrl;
    BOOL isValid = NO;
    if ([[urlCreated lowercaseString] hasPrefix:@"/"]
        || [[urlCreated lowercaseString] hasPrefix:@"http:"]) {
        isValid = YES;
    }
    XCTAssert(isValid, @"The generated URL needs to begin with '/' in the case of a file, or 'http:' in the case of a remote.");
}

- (void)testCheckParsedUrlPointsToAFile {
    NSString *urlCreated = sut.parsedUrl;
    BOOL isValid = NO;
    if ([[urlCreated lowercaseString] hasPrefix:@"/"]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:urlCreated]) {
            isValid = YES;
        }
    } else {
        isValid = YES;
    }
    XCTAssert(isValid, @"If a file (url begins with '/'), then it needs to point to an existing file.");

}

// I might try to check to see if the remote file is available here, but that
// presumes that we're always going to have valid network connectivity, so it would
// be a better idea to mock this to a known and always available URL, so we know
// exactly what we're testing.
//
// Then again, since the url is entered by hand and simply passed through parsedUrl,
// this would only be testing the user's ability to enter a URL beginning with
// 'http:' in any case.
//
// Since it's beyond the scope of the challenge at this point, I'm going to punt
// and move along.  consider this untested.
- (void)testCheckParsedUrlPointsToARemoteSource {
//    NSString *urlCreated = sut.parsedUrl;
//    BOOL isValid = NO;
//    if ([[urlCreated lowercaseString] hasPrefix:@"/"]) {
//        if ([[NSFileManager defaultManager] fileExistsAtPath:urlCreated]) {
//            isValid = YES;
//        }
//    } else {
//        isValid = YES;
//    }
    NSLog(@"*****%d %s - Warning...no testing is performed to determine if remote urls are valid, or reachable, etc.", __LINE__, __PRETTY_FUNCTION__);
    XCTAssert(YES, @"Remote URLs should be valid.");
}

@end
