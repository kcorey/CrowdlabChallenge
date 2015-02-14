//
//  Option.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Option : NSManagedObject

@property (nonatomic, retain) NSNumber * dbid;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) Question *question;

@end
