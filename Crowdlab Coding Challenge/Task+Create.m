//
//  Task+Create.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "Task+Create.h"
#import "Question+Create.h"

@implementation Task (Create)
+(Task *)insertFromDict:(NSDictionary *)input
                withContext:(NSManagedObjectContext *)context {
    
    Task *result = nil;
    
    // Check to see if it's already in the database.
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dbid" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"dbid = %@",
                         [input objectForKey:@"id"]];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1) {
        // That's odd...found an error.  Report it.  Hrm...return type is Task*.
        // Wish this were Swift where we could return tuples.
        // Perhaps store the error in a property in the TaskFetcher Singleton.  Can
        // you say "Thread-unsafe Global Variables"?  Meh.
    } else if (![matches count]) {
        // Not in the database yet...create it.
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
        
        result.dbid = [input objectForKey:@"id"];
        result.title = [[input objectForKey:@"title"] description];
        result.hidden = [input objectForKey:@"hidden"];
        
        NSArray *questions = [input objectForKey:@"questions"];
        for (NSDictionary *item in questions) {
            NSMutableDictionary *itemMutable = [item mutableCopy];
            [itemMutable setObject:result forKey:@"task"];
            [Question insertFromDict:itemMutable
                         withContext:context];
        }
    } else {
        // found the one in the database...just give that one back.
        result = [matches lastObject];
    }
    
    return result;
}

@end
