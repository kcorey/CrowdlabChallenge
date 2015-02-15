//
//  QuestionViewController.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "QuestionViewController.h"
#import "Question.h"
#import "OptionViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionViewCell" bundle:nil] forCellReuseIdentifier:@"QuestionViewCell"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTitle:@"Questions"];
    
    [self.tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionViewCell" forIndexPath:indexPath];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:1];
    
    Question *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [lbl setText:[NSString stringWithFormat:@"%@ (%d)",question.title,[question.options count]]];
    
    return cell;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Tapped on row %d",[indexPath row]);
    
    OptionViewController *option = [[OptionViewController alloc] init];
    
    Question *question = [[self.fetchedResultsController fetchedObjects] objectAtIndex:[indexPath row]];
    option.question = question;
    option.dbcontext = self.dbcontext;
    
    [self.navigationController pushViewController:option animated:YES];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:self.dbcontext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Sort using the dbid property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dbid" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"task = %@",self.task]];
    
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
