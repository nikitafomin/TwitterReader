//
//  TwittCell.h
//  TwitterReader
//
//  Created by Nikita on 5/30/13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Twitt.h"
#import "MGTwitterEngine.h"

@interface TwittCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateWithTwitt:(Twitt *)twitt;

+ (CGFloat)twittCellHeigtWithTwitt:(Twitt *)twitt;

@end
