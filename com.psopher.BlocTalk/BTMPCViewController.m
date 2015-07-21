//
//  BTMPCViewController.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/16/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTMPCViewController.h"
#import "AppDelegate.h"
#import "BTMPCHandler.h"
#import "BTParticipateInConversationViewController.h"

@interface BTMPCViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UILocalNotification *expireNotification;
@property (nonatomic, assign) NSUInteger taskId;
@property (nonatomic, strong) BTParticipateInConversationViewController *participateViewController;

@end

static UIFont *lightFont;

@implementation BTMPCViewController

- (void) loadView {
    
    self.view = [[UIView alloc] init];
    
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    
    UISwitch *switchBar = [[UISwitch alloc] init];
    UILabel *switchBarLabel = [[UILabel alloc] init];
    UIButton *contactsButton = [[UIButton alloc] init];
    UITextView *availableContactsView = [[UITextView alloc] init];
    UITableView *tableViewOfContacts = [[UITableView alloc] init];
    
    [self.view addSubview:switchBar];
    [self.view addSubview:switchBarLabel];
    [self.view addSubview:contactsButton];
    [self.view addSubview:availableContactsView];
    [self.view addSubview:tableViewOfContacts];
    
    self.switchVisible = switchBar;
        [self.switchVisible addTarget:self action:@selector(switchHasSwitched) forControlEvents:UIControlEventValueChanged];
    self.labelVisible = switchBarLabel;
    self.contactsListButton = contactsButton;
    self.contactsList = availableContactsView;
    
    self.tableOfContacts = tableViewOfContacts;
    self.tableOfContacts.dataSource = self;
    self.tableOfContacts.delegate = self;

    self.labelVisible.numberOfLines = 0;
    
    self.labelVisible.text = [NSString stringWithFormat:@"Visible to Others?"];
    [self.contactsListButton setTitle:NSLocalizedString(@"List of Available Contacts", @"List of Available Contacts") forState:UIControlStateNormal];
    [self.contactsListButton addTarget:self action:@selector(searchForPlayers:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.labelVisible setFont:lightFont];
    [self.contactsListButton.titleLabel setFont:lightFont];

}
                                             
- (void) switchHasSwitched{
    NSLog(@"HEELLLOO");
    [self.appDelegate.mpcHandler advertiseSelf:self.switchVisible.isOn];
                                                 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableOfContacts];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.appDelegate.mpcHandler setupPeerWithDisplayName:[UIDevice currentDevice].name];
    [self.appDelegate.mpcHandler setupSession];
    [self.switchVisible setOn:true];
    [self.appDelegate.mpcHandler advertiseSelf:self.switchVisible.isOn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerChangedStateWithNotification:)
                                                 name:@"MPCDemo_DidChangeStateNotification"
                                               object:nil];
    
    self.title = NSLocalizedString(@"Options", @"Options");
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    [[self.appDelegate mpcHandler] setupBrowser];
    
    self.contactsList.layer.borderColor=[[UIColor blackColor]CGColor];
    self.contactsList.layer.borderWidth = 1.0;
    
    self.contactsList.backgroundColor = [UIColor whiteColor];
    
    UITableViewCell *cell =[self.tableOfContacts dequeueReusableCellWithIdentifier:@"MyIdentifier"];
}

- (void)searchForPlayers:(id)sender {
    if (self.appDelegate.mpcHandler.session != nil) {
        [[self.appDelegate mpcHandler] setupBrowser];
        [[[self.appDelegate mpcHandler] browser] setDelegate:self];
        
        [self presentViewController:self.appDelegate.mpcHandler.browser
                           animated:YES
                         completion:nil];
    }
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self.appDelegate.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.appDelegate.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)peerChangedStateWithNotification:(NSNotification *)notification {
    // Get the state of the peer.
    int state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state == MCSessionStateConnecting) {
        NSLog(@"Connecting");
    }
    
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected");
    }
    
    if (state == MCSessionStateNotConnected) {
        NSLog(@"Not Connected");
    }
    
    // We care only for the Connected and the Not Connected states.
    
    //This Code works below to add Connected Peers to a Text View
//    if (state != MCSessionStateConnecting) {
//        // We'll just display all the connected peers (players) to the text view.
//        NSMutableArray *allPlayers = [NSMutableArray array];
//        
//        for (int i  = 0; i < self.appDelegate.mpcHandler.session.connectedPeers.count; i++) {
//            NSString *displayName = [[self.appDelegate.mpcHandler.session.connectedPeers objectAtIndex:i] displayName];
//            [allPlayers addObject:displayName];
//        }
//        
//        for (int i = 0; i < allPlayers.count; i++) {
//            [self.contactsList setText:allPlayers[i]];
//        }
//    }
    
    //Testing Code as a TableView
    if (state != MCSessionStateConnecting) {
        // We'll just display all the connected peers (players) to the text view.
        NSMutableArray *allPlayers = [NSMutableArray array];
        
        for (int i  = 0; i < self.appDelegate.mpcHandler.session.connectedPeers.count; i++) {
            NSString *displayName = [[self.appDelegate.mpcHandler.session.connectedPeers objectAtIndex:i] displayName];
            [allPlayers addObject:displayName];
        }
        
        self.listOfConnectedDisplayNames = allPlayers;
    }

}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat switchBarWidth = self.switchVisible.frame.size.width;
    CGFloat yOrigin = 64;
    CGFloat padding = 20;
    CGFloat switchBarCentered = (viewWidth - switchBarWidth)/2;
    CGFloat SwitchBarHeight = yOrigin + padding;
    
    self.switchVisible.frame = CGRectMake(switchBarCentered, SwitchBarHeight, switchBarWidth, self.switchVisible.frame.size.height);
    
    CGFloat swVisibleLabelYOrigin = CGRectGetMaxY(self.switchVisible.frame) + padding;
//    CGFloat swVisibleLabelHeight = self.swVisibleLabel.frame.size.height;
    CGFloat swVisibleLabelHeight = 10;
//    CGFloat swVisibleLabelWidth = self.swVisibleLabel.frame.size.width;
    CGFloat swVisibleLabelWidth = 80;
    CGFloat swVisibleLabelCentered = (viewWidth - swVisibleLabelWidth)/2;
    
    self.labelVisible.frame = CGRectMake(swVisibleLabelCentered, swVisibleLabelYOrigin, swVisibleLabelWidth, swVisibleLabelHeight);
//    self.swVisibleLabel.frame = CGRectMake(swVisibleLabelCentered, swVisibleLabelYOrigin, swVisibleLabelWidth, swVisibleLabelHeight);
    
    CGFloat contactsListButtonYOrigin = CGRectGetMaxY(self.labelVisible.frame) + padding + padding;
//    CGFloat contactsListButtonHeight = self.contactsListLabel.frame.size.height;
    CGFloat contactsListButtonHeight = 10;
//    CGFloat contactsListButtonWidth = self.contactsListLabel.frame.size.width;
    CGFloat contactsListButtonWidth = 120;
    CGFloat contactsListButtonCentered = (viewWidth - contactsListButtonWidth)/2;
    
    self.contactsListButton.frame = CGRectMake(contactsListButtonCentered, contactsListButtonYOrigin, contactsListButtonWidth, contactsListButtonHeight);
    
    CGFloat contactListWidth = viewWidth - padding - padding;
    CGFloat contactListYOrigin = CGRectGetMaxY(self.contactsListButton.frame) + padding;
    CGFloat contactListHeight = viewHeight - contactListYOrigin - padding;
    
//    self.contactsList.frame = CGRectMake(padding, contactListYOrigin, contactListWidth, contactListHeight);
    self.tableOfContacts.frame = CGRectMake(padding, contactListYOrigin, contactListWidth, contactListHeight);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Dealing with Disconnects

- (void) createExpireNotification
{
    [self killExpireNotification];
    
    if (self.appDelegate.mpcHandler.session.connectedPeers.count != 0) // if peers connected, setup kill switch
    {
        NSTimeInterval gracePeriod = 20.0f;
        
        // create notification that will get the user back into the app when the background process time is about to expire
        NSTimeInterval msgTime = UIApplication.sharedApplication.backgroundTimeRemaining - gracePeriod;
        UILocalNotification* n = [[UILocalNotification alloc] init];
        self.expireNotification = n;
        self.expireNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:msgTime];
        self.expireNotification.alertBody = [NSString stringWithFormat:@"Text_MultiPeerIsAboutToExpire"];
        self.expireNotification.soundName = UILocalNotificationDefaultSoundName;
        self.expireNotification.applicationIconBadgeNumber = 1;
        
        [UIApplication.sharedApplication scheduleLocalNotification:self.expireNotification];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //array is your db, here we just need how many they are
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    
    return self.listOfConnectedDisplayNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell =[self.tableOfContacts dequeueReusableCellWithIdentifier:MyIdentifier];
//    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil){
//        UITableViewCell *cell = [self.tableOfContacts dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
        cell.textLabel.text=[self.listOfConnectedDisplayNames objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)startConversation{
    BTParticipateInConversationViewController *participateVC = [[BTParticipateInConversationViewController alloc] init];
    [self.navigationController pushViewController:participateVC animated:YES];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    
    NSString *person = [NSString stringWithFormat:@"%@", self.listOfConnectedDisplayNames[row]];
    
    if (self.participateViewController == nil) {
        self.participateViewController = [[BTParticipateInConversationViewController alloc] init];
        [self.navigationController pushViewController:self.participateViewController animated:YES];
        self.participateViewController.title = person;
    }
}

//- (BTParticipateInConversationViewController *)participateViewController
//{
//    if (!participateViewController)
//    {
//        BTParticipateInConversationViewController = [[BTParticipateInConversationViewController alloc] init];
//    }
//    
//    return BTParticipateInConversationViewController;
//}


//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
//    CGFloat padding = 20;
//    CGFloat tableViewWidth = viewWidth - padding;
//    
//    BTMedia *item = [BTDataSource sharedInstance].mediaItems[indexPath.row];
//    
//    return [BTConversationsTableViewCell heightForMediaItem:item width:tableViewWidth];;
//}

- (void) killExpireNotification
{
    if (self.expireNotification != nil)
    {
        [UIApplication.sharedApplication cancelLocalNotification:self.expireNotification];
        self.expireNotification = nil;
    }
}

- (void) applicationWillEnterBackground
{
//    self.taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^
//                   {
//                       [self shutdownMultiPeerStuff];
//                       [[UIApplication sharedApplication] endBackgroundTask:self.taskId];
//                       self.taskId = UIBackgroundTaskInvalid;
//                   }];
//    [self createExpireNotification];
}

- (void) applicationWillEnterForeground
{
    [self killExpireNotification];
    if (self.taskId != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.taskId];
        self.taskId = UIBackgroundTaskInvalid;
    }
}

- (void) applicationWillTerminate
{
//    [self killExpireNotification];
//    [self stop]; // shutdown multi-peer
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
