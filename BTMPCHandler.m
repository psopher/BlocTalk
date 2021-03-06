//
//  BTMPCHandler.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/16/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTMPCHandler.h"
#import "BTMessageData.h"
#import "BTDataSource.h"
#import <UICKeyChainStore.h>

#import "JSQMessagesAvatarImageFactory.h"
#import "UIColor+JSQMessages.h"
#import "AppDelegate.h"
#import "BTConversation.h"

@interface BTMPCHandler ()

@property (nonatomic, strong) NSArray *mediaItems;
@property (strong, nonatomic) AppDelegate* appDelegate;

@end

@implementation BTMPCHandler 


-(instancetype)init{
    self = [super init];
    
    if (self) {
        self.peerID = nil;
        self.session = nil;
        self.browser = nil;
        self.advertiser = nil;
        
    }
    
    return self;
}

- (void)setupPeerWithDisplayName:(NSString *)displayName {

    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];

}

- (void)setupSession {
    
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;

}

- (void)setupBrowser {
    
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"BT-MPCList" session:_session];
    self.browser.delegate = self;

}

- (void)advertiseSelf:(BOOL)advertise {
    if (advertise) {
        
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"BT-MPCList" discoveryInfo:nil session:self.session];
        self.advertiser.delegate = self;
        [self.advertiser start];
        
    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

- (void) disconnect
{
    
    [self.advertiser stop];
    self.advertiser.delegate = nil;
    self.advertiser = nil;
    
    self.browser.delegate = nil;
    self.browser = nil;
    
    [self.session disconnect];
    self.session.delegate = nil;
    self.session = nil;
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    NSDictionary *userInfo = @{ @"peerID": peerID,
                                @"state" : @(state) };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
    
}



- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSDictionary *userInfo = @{ @"data": data,
                                @"peerID": peerID };
    
    BTMessageData* message = [NSKeyedUnarchiver unarchiveObjectWithData:data][0];
    
    for (BTConversation* conversation in [BTDataSource sharedInstance].conversations){
        if ([conversation.conversationName isEqualToString:message.channelName]){
            [conversation.messages addObject:message];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
    
}

- (void) session:(MCSession*)session didReceiveCertificate:(NSArray*)certificate fromPeer:(MCPeerID*)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    if (certificateHandler != nil) { certificateHandler(YES); }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}


#pragma user and message data for Conversations Table View Controller


@end
