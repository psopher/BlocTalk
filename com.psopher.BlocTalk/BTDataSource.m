
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
        
        self.conversations = [NSMutableArray new];
        
        self.user = [[BTUser alloc] init];
        self.user.username = [UIDevice currentDevice].name;
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

@end
