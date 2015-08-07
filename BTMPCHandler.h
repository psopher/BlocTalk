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

@interface BTMPCHandler : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate>

+(instancetype) sharedInstance;
- (BTUser *) userDisplayName;

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

@property (nonatomic, strong, readonly) NSArray *mediaItems;
@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSMutableDictionary *avatars;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) NSMutableDictionary *users;

- (void)setupPeerWithDisplayName:(NSString *)displayName;
- (void)setupSession;
- (void)setupBrowser;
- (void)advertiseSelf:(BOOL)advertise;

- (void) addPeerWithUser:(BTUser *)user;

@end
