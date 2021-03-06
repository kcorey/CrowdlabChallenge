//
//  OptionViewController.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Question.h"

@interface OptionViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *dbcontext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Question *question;

@end
