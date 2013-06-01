//
//  TwittsController.m
//  TwitterReader
//
//  Created by Nikita on 5/30/13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import "TwittsController.h"
#import "MGTwitterEngine.h"
#import <Twitter/Twitter.h>

@implementation TwittsController

- (void)dealloc
{
    [_engine closeAllConnections];
}

- (void)updateTwittsForCount:(NSInteger)count
{
//    TWRequest *request = [[TWRequest alloc] initWithURL:<#(NSURL *)#> parameters:<#(NSDictionary *)#> requestMethod:<#(TWRequestMethod)#>];
//    request performRequestWithHandler:<#^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)handler#>
    
    _engine = [[MGTwitterEngine alloc] initWithDelegate:self];
    [_engine getUserTimelineFor:@"flatstack" sinceID:0 startingAtPage:0 count:count];
    //[_engine getUserInformationFor:@"flatstack"];
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
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[statuses count]];
    for (int i = 0; i < [statuses count]; i++) {
        [array addObject:[Twitt twittFromDictionary:[statuses objectAtIndex:i]]];
    }
    
    if ([_delegate respondsToSelector:@selector(twittsController:getTwitts:)]) {
        [_delegate twittsController:self getTwitts:[NSArray arrayWithArray:array]];
    }
}














//- (void)imageReceived:(UIImage *)image forRequest:(NSString *)connectionIdentifier
//{
//    NSLog(@"Got an image for %@: %@", connectionIdentifier, image);
//    
//    // Save image to the Desktop.
////    NSString *path = [[NSString stringWithFormat:@"~/Desktop/%@.tiff", connectionIdentifier] stringByExpandingTildeInPath];
////    [[image TIFFRepresentation] writeToFile:path atomically:NO];
//}
//
//- (void)connectionFinished:(NSString *)connectionIdentifier
//{
//    NSLog(@"Connection finished %@", connectionIdentifier);
//}
//
//- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
//{
//    NSLog(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
//}
//
//
//- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
//{
//    NSLog(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
//}
//
//
//- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier
//{
//	NSLog(@"Got misc info for %@:\r%@", connectionIdentifier, miscInfo);
//}
//
//
//- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier
//{
//	NSLog(@"Got search results for %@:\r%@", connectionIdentifier, searchResults);
//}
//
//
//- (void)socialGraphInfoReceived:(NSArray *)socialGraphInfo forRequest:(NSString *)connectionIdentifier
//{
//	NSLog(@"Got social graph results for %@:\r%@", connectionIdentifier, socialGraphInfo);
//}
//
//- (void)userListsReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
//{
//    NSLog(@"Got user lists for %@:\r%@", connectionIdentifier, userInfo);
//}
//
//
//
//
////- (void)accessTokenReceived:(OAToken *)aToken forRequest:(NSString *)connectionIdentifier
////{
////	NSLog(@"Access token received! %@",aToken);
////    
////	token = [aToken retain];
////	[self runTests];
////}
//
//#if YAJL_AVAILABLE || TOUCHJSON_AVAILABLE
//
//- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier
//{
//    NSLog(@"Got an object for %@: %@", connectionIdentifier, dictionary);
//}
//
//#endif

@end
