//
//  BTChatViewController.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 7/20/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <JSQMessagesViewController.h>
#import <JSQMessages.h>
#import "BTDataSource.h"

#import "NSUserDefaults+DemoSettings.h"

@interface BTChatViewController : JSQMessagesViewController

//@property (strong, nonatomic) BTDemoModelData *demoData;
@property (strong, nonatomic) NSString *channelName;
@property (strong, nonatomic) BTUser *user;

@end
