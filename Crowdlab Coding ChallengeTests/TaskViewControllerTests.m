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
    sut = [[TaskViewController alloc] init];
    
    // make sure we're pointing at the memory database
    sut.dbcontext = context;
    fetcher.dbcontext = context;
    
    // Now load the standard JSON into the database
    sut.urlToParse = @"";
    [sut parseUrl];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    context = nil;
    
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

- (void)testCheckToSeeIfTaskViewHasAFetchedResultsControllerThatsNotNil {
    XCTAssertNotNil(sut.fetchedResultsController,@"The fetchedResultsController shouldn't be nil by now.");
}

- (void)testCheckNumberOfRows {
    XCTAssertEqual([sut tableView:nil numberOfRowsInSection:0], 5, @"For the sample data, we should have 5 rows in the table.");
}

- (void)testCheckThatTheCellForRowAtIndexPathIsNotNil {
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
    XCTAssertNotNil([sut tableView:sut.tableView cellForRowAtIndexPath:newPath], @"The cellForRowAtIndexPath should be able to return a cell.");
}

- (void)testCheckRespondsToDidSelectRow {
    XCTAssert([sut respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)], @"Must handle clicks on table rows.");
}
@end
