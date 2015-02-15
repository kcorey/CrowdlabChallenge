//
//  OptionViewController.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "OptionViewController.h"
#import "Option.h"

@interface OptionViewController ()

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OptionViewCell" bundle:nil] forCellReuseIdentifier:@"OptionViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *fetched = [self.fetchedResultsController fetchedObjects];
    
    return [fetched count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionViewCell" forIndexPath:indexPath];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:1];
    
    Option *option = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [lbl setText:[NSString stringWithFormat:@"%@ (%@)",option.label,option.type]];
    
    return cell;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Option" inManagedObjectContext:self.dbcontext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Sort using the dbid property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dbid" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"question = %@",self.question]];
    
    // Use the sectionIdentifier property to group into sections.
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                 initWithFetchRequest:fetchRequest
                                 managedObjectContext:self.dbcontext
                                 sectionNameKeyPath:nil
                                 cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    [_fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Ack! During performFetch, got %@",error.localizedDescription);
    }
    
    return _fetchedResultsController;
}

@end
