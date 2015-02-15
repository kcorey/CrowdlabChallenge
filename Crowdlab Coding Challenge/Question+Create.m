//
//  Question+Create.m
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "Question+Create.h"
#import "Option+Create.h"

@implementation Question (Create)

+(Question *)insertFromDict:(NSDictionary *)input
              withContext:(NSManagedObjectContext *)context {
    
    Question *result = nil;
    
    // Check to see if it's already in the database.
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
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
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
        
        result.dbid = [input objectForKey:@"id"];
        result.title = [[input objectForKey:@"title"] description];
        result.summary = [[input objectForKey:@"label"] description];
        
        NSArray *options = [input objectForKey:@"options"];
        for (NSDictionary *item in options) {
            NSMutableDictionary *itemMutable = [item mutableCopy];
            [itemMutable setObject:result forKey:@"question"];
            [Option insertFromDict:itemMutable
                       withContext:context];
        }
        
        result.task = [input objectForKey:@"task"];
    } else {
        // found the one in the DB...return it.
        result = [matches lastObject];
    }
    return result;
}


@end
