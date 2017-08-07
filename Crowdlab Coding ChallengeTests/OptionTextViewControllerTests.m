//
//  OptionTextViewControllerTests.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TaskFetcher.h"
#import "OptionTextViewController.h"
#import <CoreData/CoreData.h>

@interface OptionTextViewControllerTests : XCTestCase

@end

@implementation OptionTextViewControllerTests{
    OptionTextViewController *sut;
    __block NSManagedObjectContext *context;
}

- (NSManagedObjectContext *)createMemoryDatabase {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // Coordinator with in-mem store type
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    XCTAssertNotNil([coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil],@"Can't add persistent store with in memory type.");
    
    // Context with private queue
    NSManagedObjectContext *newcontext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]; // Choose your concurrency type, or leave it off entirely
    newcontext.persistentStoreCoordinator = coordinator;
    return newcontext;
}

- (void)setUp {
    TaskFetcher *fetcher = [TaskFetcher getFetcher];
    [super setUp];
    
    context = [self createMemoryDatabase];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    sut = [[OptionTextViewController alloc] init];
    [sut view];
    
    // make sure we're pointing at the memory database
    sut.dbcontext = context;
    fetcher.dbcontext = context;
    
    [fetcher parseUrl:@""];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    context = nil;
    TaskFetcher *fetcher = [TaskFetcher getFetcher];
    [fetcher forgetMe];
    
    fetcher = nil;
    
    [super tearDown];
}

- (void)testCheckQuestionLabelIsPresent {
    XCTAssertNotNil(sut.questionLabel, @"questionLabel must not be nil.");
}

- (void)testCheckOptionLabelIsPresent {
    XCTAssertNotNil(sut.optionLabel, @"optionLabel must not be nil.");
}

- (void)testCheckAnswerTextAreaIsPresent {
    XCTAssertNotNil(sut.answerTextArea, @"answerTextArea must not be nil.");
}


@end
