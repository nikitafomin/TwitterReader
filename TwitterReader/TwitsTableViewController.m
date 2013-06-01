//
//  TwitsTableViewController.m
//  TwitterReader
//
//  Created by nfomin on 29.05.13.
//  Copyright (c) 2013 nfomin. All rights reserved.
//

#import "TwitsTableViewController.h"

@interface TwitsTableViewController ()

@end

@implementation TwitsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _numberOfRows = 30;
    _isActivityOnScreen = NO;
    
    
    // create twitts controller
    _twittsController = [[TwittsController alloc] init];
    [_twittsController setDelegate:self];
    
    
    ////////////
    //
    // add "pull to refresh" view
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [self.tableView addSubview:_refreshHeaderView];
    
    //  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    ////////////
    ////////////
    
    
    
    [self startUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // show activity in first start
    if (_isReloading) {
        [self showActivityIndicator];
    }
}

// add "increase" button
- (void)addTableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    _moreTwitts = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat offset = 40.0f;
    [_moreTwitts setFrame:CGRectMake(offset, 10.0f, footerView.frame.size.width - 2*offset, 40.0f)];
    [_moreTwitts addTarget:self action:@selector(increaseTwittsCount) forControlEvents:UIControlEventTouchUpInside];
    [_moreTwitts setTitle:@"More twitts" forState:UIControlStateNormal];
    
    [footerView addSubview:_moreTwitts];
    
    [self.tableView setTableFooterView:footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _twitts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TwittCell twittCellHeigtWithTwitt:[_twitts objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TwittCell";
    TwittCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TwittCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    Twitt *twitt = [_twitts objectAtIndex:indexPath.row];
    [cell updateWithTwitt:twitt];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

// to increase twitts count and update (increase button tap)
- (void)increaseTwittsCount
{
    NSLog(@"\n\nIncrease twitts count\n\n");
    
    _numberOfRows += 30;
    [self showActivityIndicator];
    [self startUpdate];
}

#pragma mark -Activity indicator

//////////////////////////////////
//
// block with show/hide activity indicator animation

- (void)showActivityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setCenter:CGPointMake(160, 240)];
        
        _blackBackgroundView = [[UIView alloc] initWithFrame:self.tableView.window.bounds];
        [_blackBackgroundView addSubview:_activityIndicator];
        [_blackBackgroundView setAlpha:0.0f];
        [_blackBackgroundView setBackgroundColor:[UIColor blackColor]];
    }
    
    _isActivityOnScreen = YES;
    [self.tableView.window addSubview:_blackBackgroundView];
    [_activityIndicator startAnimating];
    
    [UIView animateWithDuration:0.3f animations:^(){
        [_blackBackgroundView setAlpha:0.65f];
    }];
}

- (void)hideActivityIndicator
{
    [UIView animateWithDuration:0.3f animations:^(){
        [_blackBackgroundView setAlpha:0.0f];
    }completion:^(BOOL finished){
        [_activityIndicator stopAnimating];
        [_blackBackgroundView removeFromSuperview];
        _isActivityOnScreen = NO;
    }];
}

//////////////////////////////////
//////////////////////////////////


#pragma mark - Loading delegate

//////////////////////////////////
//
// block with updating

- (void)startUpdate
{
    [self.tableView setScrollEnabled:NO];
    [_moreTwitts setEnabled:NO];
    _isReloading = YES;
    [_twittsController updateTwittsForCount:_numberOfRows];
}

- (void)endUpdate
{
    [self.tableView setScrollEnabled:YES];
    [_moreTwitts setEnabled:YES];
    _isReloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
    if (!_moreTwitts) {
        [self addTableFooterView];
    }
    if (_isActivityOnScreen) {
        [self hideActivityIndicator];
    }
}

//////////////////////////////////
//////////////////////////////////


#pragma mark - Pull to refresh delegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    // call when need start update
    
    [self startUpdate];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _isReloading; // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - Scroll view delegate

////////////////////
//
// Transmit scroll vew delegat calls

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

//
////////////////////
////////////////////

#pragma mark -Twitter controller delegate

- (void)twittsController:(TwittsController *)controller getTwitts:(NSArray *)twitts
{
    // call when get new twitts
    //
    
    _twitts = twitts;
    [self endUpdate];
}

- (void)twittsControllerFailedRequest:(TwittsController *)controller
{
    // call when request fault
    //
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Request error. sorry :(" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    
    [self endUpdate];
}

@end
