//
//  StartViewController.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskFetcher.h"

@interface StartViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextField *urlForJSON;
@property (weak, nonatomic) IBOutlet UIButton *parseButton;
@property (weak, nonatomic) IBOutlet UITextView *explainText;

@end
