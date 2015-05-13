//
//  BTDataSource.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTDataSource.h"
#import "BTUser.h"
#import "BTMessageContent.h"
#import "BTMedia.h"

@interface BTDataSource ()

@property (nonatomic, strong) NSArray *mediaItems;

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
        [self addRandomData];
    }
    
    return self;
}

- (void) addRandomData {
    NSMutableArray *randomMediaItems = [NSMutableArray array];
    
    for (int i = 1; i <= 2; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
        UIImage *image = [UIImage imageNamed:imageName];
        
        if (image) {
            BTMedia *media = [[BTMedia alloc] init];
            media.user = [self randomUser];
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

- (BTUser *) randomUser {
    BTUser *user = [[BTUser alloc] init];
    
    user.userName = [self randomStringOfLength:arc4random_uniform(10)];
    
    NSString *firstName = [self randomStringOfLength:arc4random_uniform(7)];
    NSString *lastName = [self randomStringOfLength:arc4random_uniform(12)];
    user.fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    return user;
}

- (BTMessageContent *) randomMessage {
    BTMessageContent *message = [[BTMessageContent alloc] init];
    
    message.from = [self randomUser];
    
    NSUInteger wordCount = arc4random_uniform(20);
    
    NSMutableString *randomSentence = [[NSMutableString alloc] init];
    
    for (int i  = 0; i <= wordCount; i++) {
        NSString *randomWord = [self randomStringOfLength:arc4random_uniform(12)];
        [randomSentence appendFormat:@"%@ ", randomWord];
    }
    
    message.text = randomSentence;
    
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

@end
