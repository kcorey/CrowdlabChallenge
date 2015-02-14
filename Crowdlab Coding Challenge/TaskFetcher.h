//
//  TaskFetcher.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartViewController.h"
#import "TaskViewController.h"

@interface TaskFetcher : NSObject
@property (strong, nonatomic) NSString *urlToParse;
@property (strong, nonatomic) NSString *parsedUrl;
@property (strong, nonatomic) NSString *fileContents;
@property (strong, nonatomic) NSArray *jsonResults;
@property (strong, nonatomic) NSString *defaultFilename;


+(TaskFetcher *)getFetcher;

-(NSError *)parseUrl:(NSString *)urlToParse;
-(NSString *)actualUrl:(NSString *)urlToParse;

-(void)forgetMe;

@end
