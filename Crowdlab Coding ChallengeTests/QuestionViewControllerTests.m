//
//  QuestionsViewControllerTests.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TaskFetcher.h"
#import "QuestionViewController.h"
#import <CoreData/CoreData.h>

@interface QuestionsViewControllerTests : XCTestCase

@end

@implementation QuestionsViewControllerTests{
    QuestionViewController *sut;
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
    sut = [[QuestionViewController alloc] init];
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

- (void)testCheckToSeeIfTaskViewHasAFetchedResultsControllerThatsNotNil {
    XCTAssertNotNil(sut.fetchedResultsController,@"The fetchedResultsController shouldn't be nil by now.");
}

- (NSArray *)getTaskMatches {
    // Check to see if it's already in the database.
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dbid" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"dbid = 5"];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    return matches;
}

- (void)testCheckNumberOfRows {
    NSArray *matches;
    matches = [self getTaskMatches];
    
    if ([matches count] == 1) {
        sut.task = [matches lastObject];
        XCTAssertEqual([sut tableView:nil numberOfRowsInSection:0], 3, @"For the sample data, we should have 3 Questions in the table.");
    } else {
        XCTAssert(NO,@"Couldn't find task 5, or there were more than one.");
    }
}

- (void)testCheckThatTheCellForRowAtIndexPathIsNotNil {
    NSArray *matches;
    matches = [self getTaskMatches];
    
    if ([matches count] == 1) {
        sut.task = [matches lastObject];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        XCTAssertNotNil([sut tableView:sut.tableView cellForRowAtIndexPath:newPath], @"The cellForRowAtIndexPath should be able to return a cell.");
    } else {
        XCTAssert(NO,@"Couldn't find task 5, or there were more than one.");
    }
}

- (void)testCheckRespondsToDidSelectRow {
    XCTAssert([sut respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)], @"Must handle clicks on table rows.");
}
@end
