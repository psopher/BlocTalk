//
//  BTMessageData.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 7/27/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTMessageData.h"

@interface BTMessageData ()

@end

@implementation BTMessageData 

- (instancetype)initWithSenderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date text:(NSString *)text channelName:(NSString *)channelName
{
    self = [super initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
    if (self) {
        _channelName = channelName;
    }
    
    NSLog(@"%@", text);
    
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _channelName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(channelName))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.channelName forKey:NSStringFromSelector(@selector(channelName))];
    
}

@end
