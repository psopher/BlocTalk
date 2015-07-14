//
//  BTConversationsTableViewController.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTConversationsTableViewController.h"
#import "BTUser.h"
#import "BTMessageContent.h"
#import "BTMedia.h"
#import "BTDataSource.h"
#import "BTConversationsTableViewCell.h"
#import "BTMPCViewController.h"
#import "AppDelegate.h"
#import "BTMPCHandler.h"

@interface BTConversationsTableViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation BTConversationsTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //array is your db, here we just need how many they are
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    
    return [BTDataSource sharedInstance].mediaItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // Prof Pic on Left in the tableview cell...
    
    BTConversationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.mediaItem = [BTDataSource sharedInstance].mediaItems[indexPath.row];
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat padding = 20;
    CGFloat tableViewWidth = viewWidth - padding;
    
    BTMedia *item = [BTDataSource sharedInstance].mediaItems[indexPath.row];
    
    return [BTConversationsTableViewCell heightForMediaItem:item width:tableViewWidth];;
}

- (void) startPressed:(UIBarButtonItem *)sender {

    
    
}

- (void) optionsPressed:(UIBarButtonItem *)sender {
    BTMPCViewController *optionsVC = [[BTMPCViewController alloc] init];
    [self.navigationController pushViewController:optionsVC animated:YES];
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
