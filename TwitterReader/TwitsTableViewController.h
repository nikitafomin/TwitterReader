//
//  TwitsTableViewController.h
//  TwitterReader
//
//  Created by nfomin on 29.05.13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "TwittCell.h"
#import "TwittsController.h"

@interface TwitsTableViewController : UITableViewController <EGORefreshTableHeaderDelegate, TwittsControllerDelegate>
{
    NSInteger _numberOfRows;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _isReloading;
    UIButton *_moreTwitts;
    
    TwittsController *_twittsController;
    NSArray *_twitts;
    
    UIActivityIndicatorView *_activityIndicator;
    UIView *_blackBackgroundView;
    BOOL _isActivityOnScreen;
}

@end
