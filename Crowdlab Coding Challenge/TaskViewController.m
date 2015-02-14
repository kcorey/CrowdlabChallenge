//
//  TaskViewController.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController ()

@end

@implementation TaskViewController
@synthesize urlToParse,parsedUrl;

#pragma mark - ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlToParse = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setTitle:@"Tasks"];
    
    
}

#pragma mark - TaskFetcher Logic

-(void)parseUrl {
    TaskFetcher *fetcher = [TaskFetcher getFetcher];
    [fetcher parseUrl:self.urlToParse];
    self.parsedUrl = fetcher.parsedUrl;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


#pragma mark - Table view delegate
/*
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 */
@end
