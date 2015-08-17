
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
        
        [self readFilesAtLaunch];
    }
    
    return self;
}

#pragma Saving Conversations Between Launches

- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}

- (void) saveToDisk{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger numberOfItemsToSave = MIN(self.conversations.count, 50);
        NSArray *conversationsToSave = [self.conversations subarrayWithRange:NSMakeRange(0, numberOfItemsToSave)];
        
        NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(conversations))];
        NSData *conversationsData = [NSKeyedArchiver archivedDataWithRootObject:conversationsToSave];
        
        NSError *dataError;
        BOOL wroteSuccessfully = [conversationsData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
        
        if (!wroteSuccessfully) {
            NSLog(@"Couldn't write file: %@", dataError);
        }
    });
    
    NSLog(@"This method fired: saveToDisk");
}

- (void) readFilesAtLaunch {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(conversations))];
        NSArray *storedconversations = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (storedconversations.count > 0) {
                NSMutableArray *mutableConversations = [storedconversations mutableCopy];
                
//                [self willChangeValueForKey:@"conversations"];
                self.conversations = mutableConversations;
//                [self didChangeValueForKey:@"conversations"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification" object:nil];
            }
//            else {
////                [self populateDataWithParameters:nil completionHandler:nil];
//            }
        });
    });
    
    NSLog(@"This method fired: readFilesAtLaunch");
}

@end
