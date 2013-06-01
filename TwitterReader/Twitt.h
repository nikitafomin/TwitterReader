//
//  Twitt.h
//  TwitterReader
//
//  Created by Nikita on 5/30/13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTwitterEngine.h"

#define DidLoadUserIconNotification @"DidLoadUserIconNotification"

@interface Twitt : NSObject
{
    MGTwitterEngine *_engine;
}

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage *image;

+ (Twitt *)twittFromDictionary:(NSDictionary *)dict;  // create Twitt object from dictionary in response

@end
