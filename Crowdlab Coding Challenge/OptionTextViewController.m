//
//  OptionTextViewController.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "OptionTextViewController.h"

@interface OptionTextViewController ()

@end

@implementation OptionTextViewController

@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.questionLabel setText:self.question.title];
    NSSet *options = self.question.options;
    self.theOption = (Option *)[options anyObject];
    [self.optionLabel setText:self.theOption.label];
    
    // Please read note 3 under Weaknesses of this Challenge
    [self.answerTextArea setText:self.theOption.answer];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self.answerTextArea becomeFirstResponder];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.answerTextArea.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.answerTextArea.frame animated:YES];
    }
    
    //    NSDictionary* info = [aNotification userInfo];
    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //    CGRect bkgndRect = self.answerTextArea.superview.frame;
    //    bkgndRect.size.height += kbSize.height;
    //    [self.answerTextArea.superview setFrame:bkgndRect];
    //    [scrollView setContentOffset:CGPointMake(0.0, self.answerTextArea.frame.origin.y-kbSize.height) animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// trap the back button and save the answer that the user might have been typing.
// Of course, 
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController]) {
        self.theOption.answer = self.answerTextArea.text;
        NSError *error;
        [self.dbcontext save:&error];
    }
}

@end
