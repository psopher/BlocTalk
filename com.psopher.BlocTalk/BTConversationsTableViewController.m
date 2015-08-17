//
//  BTConversationsTableViewController.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTConversationsTableViewController.h"
#import "BTDataSource.h"
#import "BTConversationsTableViewCell.h"
#import "AppDelegate.h"
#import "BTMPCHandler.h"
#import "BTMPCViewController.h"

#import "DAContextMenuCell.h"

@interface BTConversationsTableViewController () <DAContextMenuCellDataSource, DAContextMenuCellDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) BTMPCViewController *optionsVC;

@end

@implementation BTConversationsTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.optionsVC = [[BTMPCViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIBarButtonItem *startNewConvoButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", @"Start New Conversation Button") style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Options", @"Options Button") style:UIBarButtonItemStyleDone target:self action:@selector(optionsPressed:)];
    
    [self.tableView registerClass:[BTConversationsTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
    self.navigationItem.title = NSLocalizedString(@"Conversations", @"Conversations");
    self.navigationItem.rightBarButtonItem = startNewConvoButton;
    self.navigationItem.leftBarButtonItem = optionsButton;
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([BTDataSource sharedInstance].conversations != nil) {
        
        [self.tableView reloadData];
        
        NSLog(@"This code fired: TableView should reload with persisted data");
        NSLog(@"The conversations array is: %@", [[BTDataSource sharedInstance].conversations lastObject]);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:@"MCDidSendNewMessage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:@"MCDidReceiveNewMessage"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //array is your db, here we just need how many they are
    
    NSLog(@"This BTConversationsTableViewController code fired: numberOfSectionsInTableView");
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"This BTConversationsTableViewController code fired: numberOfRowsInSection");
    
    return [BTDataSource sharedInstance].conversations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BTConversationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.conversation = [BTDataSource sharedInstance].conversations[indexPath.row];
    
    if (cell.conversation != nil) {
        [[BTDataSource sharedInstance] saveToDisk];
    }
    
    cell.dataSource = self;
    cell.delegate = self;
    
    NSLog(@"This BTConversationsTableViewController code fired: cellForRowAtIndexPath");
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat padding = 20;
    CGFloat tableViewWidth = viewWidth - padding;
    
    BTConversation *item = [BTDataSource sharedInstance].conversations[indexPath.row];
    
    NSLog(@"This BTConversationsTableViewController code fired: heightForRowAtIndexPath");
    
    return [BTConversationsTableViewCell heightForMediaItem:item width:tableViewWidth];
}

- (void) reloadTableView:(NSNotification *)notification {

    [self.tableView reloadData];
    
    
    NSLog(@"This method fired: reloadTableView");
    
}

//- (void) refreshControlDidFire:(UIRefreshControl *) sender {
//    [[BTDataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error) {
//        [sender endRefreshing];
//    }];
//}

- (void) optionsPressed:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:self.optionsVC animated:YES];
    
    NSLog(@"This BTConversationsTableViewController code fired: optionsPressed");
}

#pragma mark * DAContextMenuCell data source

- (CGFloat)contextMenuCell:(DAContextMenuCell *)cell heightForButtonAtIndex:(NSUInteger)index
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat padding = 20;
    CGFloat buttonWidth = (viewWidth - padding)/5;
    
    BTConversation *item = [BTDataSource sharedInstance].conversations[index];
    
    NSLog(@"This BTConversationsTableViewController code fired: heightForButtonAtIndex");
    
    return [BTConversationsTableViewCell heightForMediaItem:item width:buttonWidth];
}

- (CGFloat)contextMenuCell:(DAContextMenuCell *)cell widthForButtonAtIndex:(NSUInteger)index
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat padding = 20;
    CGFloat buttonWidth = (viewWidth - padding)/5;
    
    NSLog(@"This BTConversationsTableViewController code fired: widthForButtonAtIndex");
    
    return buttonWidth;
}

- (NSUInteger)numberOfButtonsInContextMenuCell:(DAContextMenuCell *)cell
{
    NSLog(@"This BTConversationsTableViewController code fired: numberOfButtonsInContextMenuCell");
    
    return 2;
}

- (UIButton *)contextMenuCell:(BTConversationsTableViewCell *)cell buttonAtIndex:(NSUInteger)index
{
    BTConversationsTableViewCell *daCell = [cell isKindOfClass:[BTConversationsTableViewCell class]] ? (BTConversationsTableViewCell *)cell : nil;
    
    NSLog(@"This BTConversationsTableViewController code fired: buttonAtIndex");
    
    switch (index) {
        case 0: return daCell.moreButton;
        case 1: return daCell.archiveButton;
        default: return nil;
    }
}

- (DAContextMenuCellButtonVerticalAlignmentMode)contextMenuCell:(DAContextMenuCell *)cell alignmentForButtonAtIndex:(NSUInteger)index
{
    NSLog(@"This BTConversationsTableViewController code fired: alignmentForButtonAtIndex");
    
    return DAContextMenuCellButtonVerticalAlignmentModeCenter;
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCell:(DAContextMenuCell *)cell buttonTappedAtIndex:(NSUInteger)index
{
    NSInteger numberOfCells = [BTDataSource sharedInstance].conversations.count;
    
    NSLog(@"This BTConversationsTableViewController code fired: buttonTappedAtIndex");
    
    switch (index) {
        case 0: {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Reply", @"Forward", @"Flag", @"Mark as Unread", @"Move to Junk", @"Move Message...",  nil];
            [actionSheet showInView:self.view];
        } break;
        case 1: {
            if ([self.tableView indexPathForCell:cell]) {
                numberOfCells -= 1;
                [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            }
        } break;
        default: break;
            
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
