//
//  OptionTextViewController.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Question.h"
#import "Option.h"

@interface OptionTextViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *dbcontext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) Option *theOption;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UITextView *answerTextArea;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
