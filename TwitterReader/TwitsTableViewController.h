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
    NSInteger _numberOfRows;                            // number of twitts
    
    
    
    EGORefreshTableHeaderView *_refreshHeaderView;      // "pull to refresh" view
    BOOL _isReloading;                                  // loading state
    UIButton *_moreTwitts;                              // "get more twitts" button
    
    
    
    TwittsController *_twittsController;                // twitts load controller
    NSArray *_twitts;                                   // array of current twitts
    
    
    
    ///////////////
    //
    // load animation block
    
    UIActivityIndicatorView *_activityIndicator;
    UIView *_blackBackgroundView;
    BOOL _isActivityOnScreen;                           // state of activity indicator
    
    //////////////
}

@end
