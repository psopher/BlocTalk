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

@property (strong, nonatomic) UISwitch *swVisible;
@property (strong, nonatomic) UILabel *swVisibleLabel;
@property (strong, nonatomic) UIButton *contactsListButton;
@property (strong, nonatomic) UITextView *contactsList;

- (void)searchForPlayers:(id)sender;
- (void)toggleVisibility:(id)sender;

@end
