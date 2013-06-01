//
//  TwittsController.h
//  TwitterReader
//
//  Created by Nikita on 5/30/13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTwitterEngine.h"
#import "Twitt.h"

@class TwittsController;

@protocol TwittsControllerDelegate <NSObject>

@optional
- (void)twittsController:(TwittsController *)controller getTwitts:(NSArray *)twitts;    // call delegate, when get response with twitts
- (void)twittsControllerFailedRequest:(TwittsController *)controller;                   // call delegate, when request failed

@end

@interface TwittsController : NSObject
{
    MGTwitterEngine *_engine;
}

@property (nonatomic, weak) id <TwittsControllerDelegate> delegate;

- (void)updateTwittsForCount:(NSInteger)count;  // post reques and cal delegate, when get response

@end
