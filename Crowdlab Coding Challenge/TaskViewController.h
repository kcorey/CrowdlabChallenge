//
//  TaskViewController.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskFetcher.h"
#import <CoreData/CoreData.h>

@interface TaskViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSString *urlToParse;
@property (strong, nonatomic) NSString *parsedUrl;

@property (strong, nonatomic) NSManagedObjectContext *dbcontext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void)parseUrl;


@end
