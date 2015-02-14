//
//  TaskViewController.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskFetcher.h"

@interface TaskViewController : UITableViewController
@property (strong, nonatomic) NSString *urlToParse;
@property (strong, nonatomic) NSString *parsedUrl;
-(void)parseUrl;

@end
