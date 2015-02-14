//
//  StartViewController.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

#pragma mark - ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setTitle:@"Start"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TaskFetcher Logic

- (IBAction)parseUrl:(id)sender {
    TaskViewController *taskVC = [[TaskViewController alloc] init];
    taskVC.urlToParse = self.urlForJSON.text;
    [self.navigationController pushViewController:taskVC animated:YES];
}

@end
