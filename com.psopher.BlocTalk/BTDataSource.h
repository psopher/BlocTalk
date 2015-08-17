
//  BTDataSource.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSQMessages.h"
#import "JSQMessagesBubbleImageFactory.h"


@class BTUser;

//typedef void (^BLCNewItemCompletionBlock)(NSError *error);

@interface BTDataSource : NSObject


@property (strong, nonatomic) NSMutableArray *conversations;

@property (strong, nonatomic) NSMutableDictionary *avatars;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) BTUser *user;

+(instancetype) sharedInstance;
//- (void) requestNewItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler;
- (void) saveToDisk;

@end
