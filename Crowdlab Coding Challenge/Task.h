//
//  Task.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * dbid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSSet *questions;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(NSManagedObject *)value;
- (void)removeQuestionsObject:(NSManagedObject *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
