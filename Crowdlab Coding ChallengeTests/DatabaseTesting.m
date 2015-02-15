//
//  DatabaseTesting.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "TaskFetcher.h"
#import "Option+Create.h"
#import "Question+Create.h"
#import "Task+Create.h"

@interface DatabaseTesting : XCTestCase

@end

@implementation DatabaseTesting {
    __block NSManagedObjectContext *context;
    TaskFetcher *fetcher;
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
    [super setUp];
    context = [self createMemoryDatabase];

    fetcher = [TaskFetcher getFetcher];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    context = nil;
    [fetcher forgetMe];
    fetcher = nil;

    [super tearDown];
}

- (void)testAAAADatabaseContextIsNotNil {
    XCTAssertNotNil(context,@"In-memory database context is nil.");
}

- (void)testOptionEntityExists {
    Option *anOption = [NSEntityDescription insertNewObjectForEntityForName:@"Option"
                                                     inManagedObjectContext:context];
    
    XCTAssertNotNil(anOption,@"Option mustn't be nil.");
    XCTAssert([anOption isKindOfClass:[NSManagedObject class]],@"Option isn't a NSManagedObject class.");
}

- (void)testQuestionEntityExists {
    Question *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Question"
                                                     inManagedObjectContext:context];
    XCTAssertNotNil(aQuestion,@"Question mustn't be nil.");
    XCTAssert([aQuestion isKindOfClass:[NSManagedObject class]],@"Question isn't a NSManagedObject class.");
}

- (void)testTaskEntityExists {
    Task *aTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                     inManagedObjectContext:context];
    
    XCTAssertNotNil(aTask,@"Task mustn't be nil.");
    XCTAssert([aTask isKindOfClass:[NSManagedObject class]],@"Task isn't a NSManagedObject class.");
}

- (void)prepareDatabase {
    // use the in-memory database
    fetcher.dbcontext = context;
    
    // read and prepare the default data
    [fetcher parseUrl:@""];
    
    // insert the data into the database
    [fetcher insertJSONUsingContext:context];
}

- (NSArray *)selectAllRecordsInEntity:(NSString *)entityName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dbid" ascending:YES]];
    request.predicate = nil;
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    return matches;
}

- (NSArray *)selectRecordWithId:(NSNumber *)dbid InEntity:(NSString *)entityName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dbid" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"dbid = %ld", [dbid intValue]];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    return matches;
}

- (void)test10OptionsWereEntered {
    [self prepareDatabase];
    
    NSArray *matches = [self selectAllRecordsInEntity:@"Option"];
    
    XCTAssertEqual([matches count], 10, @"Exactly 10 Options should have been inserted.");
}

- (void)testOptionNumber10WasEntered {
    [self prepareDatabase];
    
    NSArray *matches = [self selectRecordWithId:@10 InEntity:@"Option"];
    
    XCTAssertEqual([matches count], 1, @"There should be just one Option #10 in the database.");
}

- (void)test10QuestionsWereEntered {
    [self prepareDatabase];
    
    NSArray *matches = [self selectAllRecordsInEntity:@"Question"];
    
    XCTAssertEqual([matches count], 10, @"Exactly 10 Question should have been inserted.");
}

- (void)testQuestionNumber10WasEntered {
    [self prepareDatabase];
    
    NSArray *matches = [self selectRecordWithId:@10 InEntity:@"Question"];
    
    XCTAssertEqual([matches count], 1, @"There should be just one Option #10 in the database.");
}

- (void)test5TasksWereEntered {
    [self prepareDatabase];
    
    NSArray *matches = [self selectAllRecordsInEntity:@"Task"];
    
    XCTAssertEqual([matches count], 5, @"Exactly 5 Task should have been inserted.");
}

- (void)testTaskNumber3WasEntered {
    [self prepareDatabase];
    
    NSArray *matches = [self selectRecordWithId:@3 InEntity:@"Task"];
    
    XCTAssertEqual([matches count], 1, @"There should be just one Task #3 in the database.");
}

//    Here's a bit more research about testing of the database class:
/*
 Things to test:
 1) creation of the dbdocument
 2) opening the dbdocument
 3) inserting an option
 
 3.5) checking each of the fields to ensure the data is in the correct format.
 3.6) checking what happens if the data is in an unacceptable format.
 4) checking to make sure duplicates are not allowed.
 5) inserting a question
 5.5) checking each of the fields to ensure the data is in the correct format.
 5.6) checking what happens if the data is in an unacceptable format.
 6) checking to make sure duplicates are not allowed.
 7) checking that the options for the question are linked with the question.
 8) inserting a task
 8.5) checking each of the fields to ensure the data is in the correct format.
 8.6) checking what happens if the data is in an unacceptable format.
 9) checking to make sure duplicates are not allowed.
 10) checking that the questions for the task are linked with the task.
 
 In the tests above, I just inserted all the data from the JSON, and then did a few queries.  It hardly qualifies as TDD or even close to full coverage.
 */

@end
