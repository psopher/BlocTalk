//
//  BTMPCViewController.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/16/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BTMPCViewController : UIViewController <MCBrowserViewControllerDelegate>

@property (strong, nonatomic) UISwitch *switchVisible;
@property (strong, nonatomic) UILabel *labelVisible;
@property (strong, nonatomic) UIButton *contactsListButton;
@property (strong, nonatomic) UITextView *contactsList;
@property (strong, nonatomic) UITableView *tableOfContacts;

//@property (strong, nonatomic) NSString *person;


- (void)searchForPlayers:(id)sender;
- (void) switchHasSwitched;
//- (void) startConversation;

@end
