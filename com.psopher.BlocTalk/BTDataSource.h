
//  BTDataSource.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.


#import <Foundation/Foundation.h>
#import "JSQMessages.h"
#import "JSQMessagesBubbleImageFactory.h"


@class BTUser;

@interface BTDataSource : NSObject


//- (BTUser *) userDisplayName;

//@property (nonatomic, strong, readonly) NSArray *mediaItems;
@property (strong, nonatomic) NSMutableArray *conversations;
//@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSMutableDictionary *avatars;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) BTUser *user;

- (void) addPeerWithUser:(BTUser *)user;
+(instancetype) sharedInstance;

@end
