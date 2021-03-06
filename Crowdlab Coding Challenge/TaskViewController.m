//
//  TaskViewController.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 15/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "TaskViewController.h"
#import "Task.h"
#import "QuestionViewController.h"

@interface TaskViewController ()

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TaskFetcher *fetcher = [TaskFetcher getFetcher];
    fetcher.dbcontext = self.dbcontext;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskViewCell" bundle:nil] forCellReuseIdentifier:@"TaskViewCell"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTitle:@"Tasks"];
    
    [self parseUrl];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSArray *fetched = [self.fetchedResultsController fetchedObjects];
    
    return [fetched count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskViewCell" forIndexPath:indexPath];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:1];
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [lbl setText:[NSString stringWithFormat:@"%@ (%d)",task.title,[task.questions count]]];
    
    return cell;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionViewController *question = [[QuestionViewController alloc] init];

    Task *task = [[self.fetchedResultsController fetchedObjects] objectAtIndex:[indexPath row]];
    question.task = task;
    question.dbcontext = self.dbcontext;
    
    [self.navigationController pushViewController:question animated:YES];    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.dbcontext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Sort using the dbid property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dbid" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    [fetchRequest setPredicate:nil];
    
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
