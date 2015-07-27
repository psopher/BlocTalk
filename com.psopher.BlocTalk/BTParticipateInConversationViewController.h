//
//  BTParticipateInConversationViewController.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 7/20/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <JSQMessagesViewController.h>
#import <JSQMessages.h>
#import "BTDemoModelData.h"

#import "NSUserDefaults+DemoSettings.h"

@interface BTParticipateInConversationViewController : JSQMessagesViewController

@property (strong, nonatomic) BTDemoModelData *demoData;
@property (strong, nonatomic) NSString *channelName;

@end
