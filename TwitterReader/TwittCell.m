//
//  TwittCell.m
//  TwitterReader
//
//  Created by Nikita on 5/30/13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import "TwittCell.h"

#define TextLabelFont [UIFont systemFontOfSize:14.0f]
#define DetailTextLabelFont [UIFont systemFontOfSize:10.0f]

@implementation TwittCell

static NSDateFormatter *_dateFormatter = nil;

+ (void)initialize
{
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[self textLabel] setNumberOfLines:0];
        [[self textLabel] setFont:TextLabelFont];
        [[self textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [self.detailTextLabel setFont:DetailTextLabelFont];
        [[self imageView] setFrame:CGRectMake(0, 0, 48, 48)];
        [[self imageView] setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    return self;
}

- (void)updateWithTwitt:(Twitt *)twitt
{
    if (twitt) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DidLoadUserIconNotification object:nil];
        
        [[self textLabel] setText:twitt.text];
        
        NSString *date = [_dateFormatter stringFromDate:twitt.date];
        [[self detailTextLabel] setText:[NSString stringWithFormat:@"%@,   %@",twitt.userName,date]];
        
        if (twitt.image) {
            [[self imageView] setImage:twitt.image];
        } else {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageWithNotification:) name:DidLoadUserIconNotification object:twitt];
            
            UIImage *thumbnail = [UIImage imageNamed:@"noimage.png"];
            CGSize itemSize = CGSizeMake(48, 48);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [thumbnail drawInRect:imageRect];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
}

- (void)updateImageWithNotification:(NSNotification *)notif
{
    Twitt *twitt = [notif object];
    UIImage *icon = twitt.image;
    if (icon) {
        [self.imageView setImage:icon];
    }
}

+ (CGFloat)twittCellHeigtWithTwitt:(Twitt *)twitt
{
    CGFloat height = [twitt.text sizeWithFont:TextLabelFont constrainedToSize:CGSizeMake(250, 99999999) lineBreakMode:UILineBreakModeWordWrap].height;
    height += [twitt.userName sizeWithFont:DetailTextLabelFont].height;
    height += 20.0f;
    
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
