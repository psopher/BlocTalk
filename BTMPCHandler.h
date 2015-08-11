//
//  BTMPCHandler.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/16/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "JSQMessages.h"
#import "JSQMessagesBubbleImageFactory.h"

@class BTUser;
@class BTMedia;

@interface BTMPCHandler : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;


- (void)setupPeerWithDisplayName:(NSString *)displayName;
- (void)setupSession;
- (void)setupBrowser;
- (void)advertiseSelf:(BOOL)advertise;

@end
