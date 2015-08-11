
//  BTDataSource.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.


#import "BTDataSource.h"
#import "BTMessageContent.h"
#import "BTMedia.h"
#import <UICKeyChainStore.h>

#import "NSUserDefaults+DemoSettings.h"
#import "BTUser.h"
#import "JSQMessagesAvatarImageFactory.h"
#import "UIColor+JSQMessages.h"
#import "AppDelegate.h"

@interface BTDataSource ()

@property (nonatomic, strong) NSArray *mediaItems;
@property (strong, nonatomic) AppDelegate* appDelegate;

@end

@implementation BTDataSource

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
//        [self addRandomData];
        
        self.conversations = [NSMutableArray new];
        
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        BTUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        self.avatars = [[NSMutableDictionary alloc] init];
        self.users = [[NSMutableDictionary alloc ] init];
        
        [self addPeerWithUser:user];
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
        self.user = [[BTUser alloc] init];
        self.user.username = [UIDevice currentDevice].name;
    }
    
    return self;
}

//- (void) addRandomData {
//    NSMutableArray *randomMediaItems = [NSMutableArray array];
//    
//    for (int i = 1; i <= 2; i++) {
//        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
//        UIImage *image = [UIImage imageNamed:imageName];
//        
//        if (image) {
//            BTMedia *media = [[BTMedia alloc] init];
//            media.user = [self userDisplayName];
//            media.image = image;
//            
//            NSUInteger messageCount = arc4random_uniform(10);
//            NSMutableArray *randomMessages = [NSMutableArray array];
//            
//            for (int i  = 0; i <= messageCount; i++) {
//                BTMessageContent *randomMessage = [self randomMessage];
//                [randomMessages addObject:randomMessage];
//            }
//            
//            media.messageContent = randomMessages;
//            
//            [randomMediaItems addObject:media];
//        }
//    }
//    
//    self.mediaItems = randomMediaItems;
//}

//- (BTMessageContent *) randomMessage {
//    BTMessageContent *message = [[BTMessageContent alloc] init];
//    
//    message.from = [self userDisplayName];
//
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
//    
//    message.text = [[BTDataSource sharedInstance].messages objectAtIndex:text];
//    
//    return message;
//}

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
