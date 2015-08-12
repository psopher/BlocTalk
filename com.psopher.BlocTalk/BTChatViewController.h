//
//  BTChatViewController.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 7/20/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <JSQMessagesViewController.h>
#import <JSQMessages.h>
#import "NSUserDefaults+DemoSettings.h"

@class BTConversation;

@interface BTChatViewController : JSQMessagesViewController

@property (strong, nonatomic) NSString *channelName;
@property (strong, nonatomic) BTConversation *conversation;

@end
