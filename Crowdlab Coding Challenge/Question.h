//
//  Question.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Option, Task;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * dbid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) NSSet *options;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addOptionsObject:(Option *)value;
- (void)removeOptionsObject:(Option *)value;
- (void)addOptions:(NSSet *)values;
- (void)removeOptions:(NSSet *)values;

@end
