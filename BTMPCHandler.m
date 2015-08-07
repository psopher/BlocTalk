//
//  BTMPCHandler.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/16/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTMPCHandler.h"
#import "BTMessageData.h"
//#import "BTDataSource.h"
#import <UICKeyChainStore.h>

#import "BTMessageContent.h"
#import "BTMedia.h"

#import "NSUserDefaults+DemoSettings.h"
#import "BTUser.h"
#import "JSQMessagesAvatarImageFactory.h"
#import "UIColor+JSQMessages.h"
#import "AppDelegate.h"

@interface BTMPCHandler ()

@property (nonatomic, strong) NSArray *mediaItems;
@property (strong, nonatomic) AppDelegate* appDelegate;
@property (nonatomic,strong) BTMessageData* message;

@end

@implementation BTMPCHandler 


+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(instancetype)init{
    self = [super init];
    
    if (self) {
        [self addRandomData];
        self.peerID = nil;
        self.session = nil;
        self.browser = nil;
        self.advertiser = nil;

        self.messages = [NSMutableArray new];
        
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        BTUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        self.avatars = [[NSMutableDictionary alloc] init];
        self.users = [[NSMutableDictionary alloc ] init];
        
        [self addPeerWithUser:user];
        
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

- (void)setupPeerWithDisplayName:(NSString *)displayName {

        self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];

}

- (void)setupSession {
//    if (self.session == nil) {
        self.session = [[MCSession alloc] initWithPeer:self.peerID];
        self.session.delegate = self;
//    }
}

- (void)setupBrowser {
//    if (self.browser == nil) {
        self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"BT-MPCList" session:_session];
//    }
    self.browser.delegate = self;
}

- (void)advertiseSelf:(BOOL)advertise {
    if (advertise) {
//        NSDictionary *elements = @{ @"numberOfMessagesInCurrentChannel": self.numberOfMessagesInCurrentChannel};
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
    
//    [self.browser stopBrowsingForPeers];
    self.browser.delegate = nil;
    self.browser = nil;
    
    [self.session disconnect];
    self.session.delegate = nil;
    self.session = nil;
}

//- (void)updateDelegate
//{
//    [self.delegate sessionDidChangeState];
//}

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
    
    self.message = [NSKeyedUnarchiver unarchiveObjectWithData:data][0];
//    BTMessageData* message = [NSKeyedUnarchiver unarchiveObjectWithData:data][0];
    
    [[BTMPCHandler sharedInstance].messages addObject:self.message];
    
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

- (void) addRandomData {
    NSMutableArray *randomMediaItems = [NSMutableArray array];
    
    for (int i = 1; i <= 2; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
        UIImage *image = [UIImage imageNamed:imageName];
        
        if (image) {
            BTMedia *media = [[BTMedia alloc] init];
            media.user = [self userDisplayName];
            media.image = image;
            
            NSUInteger messageCount = arc4random_uniform(10);
            NSMutableArray *randomMessages = [NSMutableArray array];
            
            for (int i  = 0; i <= messageCount; i++) {
                BTMessageContent *randomMessage = [self randomMessage];
                [randomMessages addObject:randomMessage];
            }
            
            media.messageContent = randomMessages;
            
            [randomMediaItems addObject:media];
        }
    }
    
    self.mediaItems = randomMediaItems;
}

- (BTUser *) userDisplayName {
    BTUser *user = [[BTUser alloc] init];
    
//    NSString *userDisplay = self.message.senderDisplayName;
    
    
    if (self.message.senderDisplayName != nil) {
        user.username = self.message.senderDisplayName;
    } else {
        user.username = @"Sender Display Name";
    }
    
    //    user.username = [self randomStringOfLength:arc4random_uniform(10)];
    //    user.username = [self.appDelegate.mpcHandler peerID]
    //
    //    NSString *firstName = [self randomStringOfLength:arc4random_uniform(7)];
    //    NSString *lastName = [self randomStringOfLength:arc4random_uniform(12)];
    //    user.username = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    return user;
}

- (BTMessageContent *) randomMessage {
    BTMessageContent *message = [[BTMessageContent alloc] init];
    
    message.from = [self userDisplayName];
    
    //    NSUInteger wordCount = arc4random_uniform(20);
    //
    //    NSMutableString *randomSentence = [[NSMutableString alloc] init];
    //
    //    for (int i  = 0; i <= wordCount; i++) {
    //        NSString *randomWord = [self randomStringOfLength:arc4random_uniform(12)];
    //        [randomSentence appendFormat:@"%@ ", randomWord];
    //    }
    //
    //    message.text = randomSentence;
    
    if (self.message.text != nil) {
        message.text = self.message.text;
    } else {
        message.text = @"Message Text";
    }
    
    
    return message;
}

- (NSString *) randomStringOfLength:(NSUInteger) len {
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
    
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i = 0U; i < len; i++) {
        u_int32_t r = arc4random_uniform((u_int32_t)[alphabet length]);
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return [NSString stringWithString:s];
}

- (void) addPeerWithUser:(BTUser *)user
{
    //parse username for initials
    NSArray *usernameWords = [user.username componentsSeparatedByString:@" "];
    NSString *usernameInitials = @"";
    
    if ([usernameWords count] == 1) {
        usernameInitials = [(NSString *)usernameWords[0] substringToIndex:1];
    } else if ([usernameWords count] > 2)
    {
        NSUInteger lastIndex = [usernameWords count] - 1;
        usernameInitials = [NSString stringWithFormat:@"%@%@%@", [(NSString *)usernameWords[0] substringToIndex:1], [(NSString *)usernameWords[1] substringToIndex:1], [(NSString *)usernameWords[lastIndex] substringToIndex:1]];
        
    } else if ([usernameWords count] == 2)
    {
        usernameInitials = [NSString stringWithFormat:@"%@%@", [(NSString *)usernameWords[0] substringToIndex:1], [(NSString *)usernameWords[1] substringToIndex:1]];
    }
    
    /**
     *  Create avatar images once.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     *  If you are not using avatars, ignore this.
     */
    
    
    //    JSQMessagesAvatarImage *avatarImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:usernameInitials
    //                                                                                     backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
    //                                                                                           textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
    //                                                                                                font:[UIFont systemFontOfSize:14.0f]
    //                                                                                            diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    //
    //
    //    self.avatars[[user.UUID UUIDString]] = avatarImage;
    
    //    self.users[[user.UUID UUIDString]] = user.username;
}


@end
