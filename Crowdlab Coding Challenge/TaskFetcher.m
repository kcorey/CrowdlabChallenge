//
//  TaskFetcher.m
//  Crowdlab Coding Challenge
//
// TaskFetcher is the brain of the app...all significant logic should be done in here.
//
//  Created by Ken Corey on 14/02/2015.
//  Copyright (c) 2015 Flippin' Bits Software, Ltd. All rights reserved.
//

#import "TaskFetcher.h"

@implementation TaskFetcher

@synthesize urlToParse, parsedUrl, fileContents, jsonResults;
@synthesize defaultFilename;

static TaskFetcher *sharedInstance = nil;

#pragma mark - TaskFetcher Lifecycle

+(TaskFetcher *)getFetcher {
    if (!sharedInstance) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

// Since TaskFetcher is a singleton, its state would persist between
// invocations.
//
// For testing, we need to be able to forget our link to ourselves, so
// that when the next test starts, we get a fresh singleton.
//
-(void)forgetMe {
    sharedInstance = nil;
}

-(id)init {
    if (self = [super init]) {
        // Any initing required?
        self.defaultFilename = @"tasks";
    }
    return self;
}

#pragma mark - TaskFetcher Logic

-(NSString *)actualUrl:(NSString *)theUrlToParse {
    NSString *result = nil;
    if (theUrlToParse && ! [theUrlToParse isEqualToString:@""]) {
        result = theUrlToParse;
    } else {
        result = [[NSBundle mainBundle] pathForResource:self.defaultFilename ofType:@"json"];
    }
    
    return result;
}

- (NSError *)readfile {
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.parsedUrl]) {
        NSLog(@"File Exists..");
        self.fileContents = [NSString stringWithContentsOfFile:self.parsedUrl encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"When trying to read file '%@', got error of '%@'.",self.parsedUrl,error.localizedDescription);
        }
    }
    return error;
}

- (NSError *)readJSONFromFileData:(NSData *)fileData {
    NSError *error = nil;
    @try {
        // Ack!  NSJSONSerialization throws an NSInvalidArgumentException
        // if it runs into bad JSON.  This isn't very nice.  We're
        // creating a fake NSError object to pass back, so we can deal
        // with the error at a higher level.
        //
        // This also means that we can continue the unit tests after
        // encountering an expected error like this.
        //
        self.jsonResults =
        [NSJSONSerialization JSONObjectWithData:fileData
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
    }
    @catch (NSException *e) {
        NSLog(@"Caught an error!  %@", [e description]);
        error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                    code:-47
                                userInfo:nil];
    }
    
    return error;
}

-(NSError *)parseUrl:(NSString *)theUrlToParse {
    NSError *error;
    
    self.parsedUrl = [self actualUrl:theUrlToParse];

    // XXX todo revisit to handle the situation of a remote URL
    error = [self readfile];

    if (!error) {
        NSData *fileData = [NSData dataWithContentsOfFile:self.parsedUrl];
        error = [self readJSONFromFileData:fileData];
    }
    return error;
}







@end
