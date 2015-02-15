//
//  Option+Create.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "Option+Create.h"

@implementation Option (Create)

+(Option *)insertFromDict:(NSDictionary *)input
              withContext:(NSManagedObjectContext *)context {
    Option *result = nil;
    
    // Check to see if it's already in the database.
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Option"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dbid" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"dbid = %@",
                         [input objectForKey:@"id"]];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1) {
        // That's odd...found an error.  Report it.  Hrm...return type is Task*.
        // Wish this were Swift where we could return tuples.
    } else if (![matches count]) {
        // Not in the database yet...create it.
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:context];
        
        result.dbid = [input objectForKey:@"id"];
        result.type = [[input objectForKey:@"type"] description];
        result.label = [[input objectForKey:@"label"] description];
        result.question = [input objectForKey:@"question"];
    } else {
        // found the one in the DB...return it.
        result = [matches lastObject];
    }

    return result;
}

@end
