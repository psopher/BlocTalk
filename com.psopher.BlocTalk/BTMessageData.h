//
//  BTMessageData.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 7/27/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "JSQMessage.h"

@interface BTMessageData : JSQMessage <JSQMessageData, NSCoding>

@property (strong, nonatomic) NSString *channelName;

- (instancetype)initWithSenderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date text:(NSString *)text channelName:(NSString *)channelName;

@end

