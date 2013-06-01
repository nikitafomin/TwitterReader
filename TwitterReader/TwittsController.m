//
//  TwittsController.m
//  TwitterReader
//
//  Created by Nikita on 5/30/13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import "TwittsController.h"
#import "MGTwitterEngine.h"

@implementation TwittsController

- (void)dealloc
{
    [_engine closeAllConnections];
}

- (void)updateTwittsForCount:(NSInteger)count
{
    _engine = [[MGTwitterEngine alloc] initWithDelegate:self];
    [_engine getUserTimelineFor:@"flatstack" sinceID:0 startingAtPage:0 count:count];
}

#pragma mark MGTwitterEngineDelegate methods


- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    //NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)",
          connectionIdentifier,
          [error localizedDescription],
          [error userInfo]);
    
    if ([_delegate respondsToSelector:@selector(twittsControllerFailedRequest:)]) {
        [_delegate twittsControllerFailedRequest:self];
    }
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
    //NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, statuses);
    
    NSLog(@"\n\ntwitts count:  %d\n\n",[statuses count]);
    
    
    // twitts array from response
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[statuses count]];
    for (int i = 0; i < [statuses count]; i++) {
        [array addObject:[Twitt twittFromDictionary:[statuses objectAtIndex:i]]];
    }
    
    if ([_delegate respondsToSelector:@selector(twittsController:getTwitts:)]) {
        [_delegate twittsController:self getTwitts:[NSArray arrayWithArray:array]];
    }
}

@end
