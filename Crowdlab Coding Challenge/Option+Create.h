//
//  Option+Create.h
//  Crowdlab Coding Challenge
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "Option.h"

@interface Option (Create)

+(Option *)insertFromDict:(NSDictionary *)input
              withContext:(NSManagedObjectContext *)context;

@end
