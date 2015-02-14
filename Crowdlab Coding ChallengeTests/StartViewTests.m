//
//  StartViewTests.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TaskFetcher.h"

@interface StartViewTests : XCTestCase

@end

@implementation StartViewTests {
    StartViewController *sut;
}

- (void)setUp {
    [super setUp];
    sut = [[StartViewController alloc] init];
    
    [sut view];
}

- (void)tearDown {
    sut = nil;
    [super tearDown];
}

- (void)testCheckUrlForJSONFieldIsConnected {
    XCTAssertNotNil([sut urlForJSON],@"the text field urlForJSON shouldn't be nil");
}

- (void)testCheckParseButtonIsConnected {
    XCTAssertNotNil([sut parseButton],@"the parse button shouldn't be nil.");
}

- (void)testCheckButtonHasParseFunction {
    NSArray *actionsArray = [[sut parseButton] actionsForTarget:sut forControlEvent:UIControlEventTouchUpInside];
    XCTAssertNotNil(actionsArray,@"Make sure that the actions for target are not nil.");
    XCTAssert([actionsArray containsObject:@"parseUrl:"],@"parseUrl should be the function.");
}

- (void)testCheckExplanatoryTextIsPresent {
    XCTAssertNotNil([sut explainText],@"The explanatory text should be present.");
}

@end
