//
//  Twitt.m
//  TwitterReader
//
//  Created by Nikita on 5/30/13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import "Twitt.h"

@implementation Twitt

@synthesize userName = _userName;
@synthesize text = _text;
@synthesize date = _date;
@synthesize imageURL = _imageURL;
@synthesize image = _image;

static NSDateFormatter *_dateFormatter = nil;

- (void)dealloc
{
    // close connections after dealloc
    [_engine closeAllConnections];
}

+ (void)initialize
{
    // create single dateFormatter for all Twitt objects
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setLocale:usLocale];
    [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    [_dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
}

- (MGTwitterEngine *)engine
{
    if (!_engine) {
        _engine = [[MGTwitterEngine alloc] initWithDelegate:self];
    }
    return _engine;
}

+ (Twitt *)twittFromDictionary:(NSDictionary *)dict
{
    Twitt *newTwitt = [[Twitt alloc] init];
    
    newTwitt.text = [dict objectForKey:@"text"];
    newTwitt.date = [_dateFormatter dateFromString:[dict objectForKey:@"created_at"]];
    newTwitt.userName = [[dict objectForKey:@"user"] objectForKey:@"name"];
    newTwitt.imageURL = [[dict objectForKey:@"user"] objectForKey:@"profile_image_url"];
    
    
    return newTwitt;
}

- (UIImage *)image
{
    if (!_image) {
        [self loadIcon];
    }
    return _image;
}

- (void)loadIcon
{
    [[self engine] getImageAtURL:self.imageURL];
}

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
}

- (void)imageReceived:(UIImage *)image forRequest:(NSString *)connectionIdentifier
{
    //NSLog(@"Got an image for %@: %@", connectionIdentifier, image);
    
    _image = image;
    
    // call twitt cell
    [[NSNotificationCenter defaultCenter] postNotificationName:DidLoadUserIconNotification object:self];
}

@end
