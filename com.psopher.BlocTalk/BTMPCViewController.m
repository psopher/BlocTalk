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

@interface BTMPCViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

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
    
    [self.view addSubview:switchBar];
    [self.view addSubview:switchBarLabel];
    [self.view addSubview:contactsButton];
    [self.view addSubview:availableContactsView];
    
    self.swVisible = switchBar;
    self.swVisibleLabel = switchBarLabel;
    self.contactsListButton = contactsButton;
    self.contactsList = availableContactsView;

    self.swVisibleLabel.numberOfLines = 0;
    
    self.swVisibleLabel.text = [NSString stringWithFormat:@"Visible to Others?"];
    [self.contactsListButton setTitle:NSLocalizedString(@"List of Available Contacts", @"List of Available Contacts") forState:UIControlStateNormal];
    [self.contactsListButton addTarget:self action:@selector(searchForPlayers:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.swVisibleLabel setFont:lightFont];
    [self.contactsListButton.titleLabel setFont:lightFont];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.appDelegate.mpcHandler setupPeerWithDisplayName:[UIDevice currentDevice].name];
    [self.appDelegate.mpcHandler setupSession];
    [self.appDelegate.mpcHandler advertiseSelf:self.swVisible.isOn];
    
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
    
    // We care only for the Connected and the Not Connected states.
    // The Connecting state will be simply ignored.
    if (state != MCSessionStateConnecting) {
        // We'll just display all the connected peers (players) to the text view.
        NSString *allPlayers = @"Other players connected with:\n\n";
        
        for (int i = 0; i < self.appDelegate.mpcHandler.session.connectedPeers.count; i++) {
            NSString *displayName = [[self.appDelegate.mpcHandler.session.connectedPeers objectAtIndex:i] displayName];
            
            allPlayers = [allPlayers stringByAppendingString:@"\n"];
            allPlayers = [allPlayers stringByAppendingString:displayName];
        }
        
        [self.contactsList setText:allPlayers];
    }
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat switchBarWidth = self.swVisible.frame.size.width;
    CGFloat yOrigin = 64;
    CGFloat padding = 20;
    CGFloat switchBarCentered = (viewWidth - switchBarWidth)/2;
    CGFloat SwitchBarHeight = yOrigin + padding;
    
    self.swVisible.frame = CGRectMake(switchBarCentered, SwitchBarHeight, switchBarWidth, self.swVisible.frame.size.height);
    
    CGFloat swVisibleLabelYOrigin = CGRectGetMaxY(self.swVisible.frame) + padding;
//    CGFloat swVisibleLabelHeight = self.swVisibleLabel.frame.size.height;
    CGFloat swVisibleLabelHeight = 10;
//    CGFloat swVisibleLabelWidth = self.swVisibleLabel.frame.size.width;
    CGFloat swVisibleLabelWidth = 80;
    CGFloat swVisibleLabelCentered = (viewWidth - swVisibleLabelWidth)/2;
    
    self.swVisibleLabel.frame = CGRectMake(swVisibleLabelCentered, swVisibleLabelYOrigin, swVisibleLabelWidth, swVisibleLabelHeight);
//    self.swVisibleLabel.frame = CGRectMake(swVisibleLabelCentered, swVisibleLabelYOrigin, swVisibleLabelWidth, swVisibleLabelHeight);
    
    CGFloat contactsListButtonYOrigin = CGRectGetMaxY(self.swVisibleLabel.frame) + padding + padding;
//    CGFloat contactsListButtonHeight = self.contactsListLabel.frame.size.height;
    CGFloat contactsListButtonHeight = 10;
//    CGFloat contactsListButtonWidth = self.contactsListLabel.frame.size.width;
    CGFloat contactsListButtonWidth = 120;
    CGFloat contactsListButtonCentered = (viewWidth - contactsListButtonWidth)/2;
    
    self.contactsListButton.frame = CGRectMake(contactsListButtonCentered, contactsListButtonYOrigin, contactsListButtonWidth, contactsListButtonHeight);
    
    CGFloat contactListWidth = viewWidth - padding - padding;
    CGFloat contactListYOrigin = CGRectGetMaxY(self.contactsListButton.frame) + padding;
    CGFloat contactListHeight = viewHeight - contactListYOrigin - padding;
    
    self.contactsList.frame = CGRectMake(padding, contactListYOrigin, contactListWidth, contactListHeight);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
