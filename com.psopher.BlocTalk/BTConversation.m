//
//  BTConversation.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 8/11/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTConversation.h"

@implementation BTConversation

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *conversationName = [aDecoder decodeObjectForKey:@"conversationName"];
    NSMutableArray *messages = [aDecoder decodeObjectForKey:@"messages"];

    return [self initWithConversationName:conversationName messages:messages];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.conversationName forKey:@"conversationName"];
    [aCoder encodeObject:self.messages forKey:@"messages"];
}

-(instancetype)initWithConversationName:(NSString *)conversationName messages:(NSMutableArray *)messages;
{
    self = [super init];
    
    if (self) {
        self.conversationName = conversationName;
        self.messages = messages;
    }
    return self;
}

//-(instancetype)initWithConversationName:(NSString *)conversationName;
//{
//    return [self initWithConversationName:conversationName messages:self.messages];
//}

//- (instancetype)init
//{
//    return [self initWithConversationName:@""];
//}


-(instancetype) init{
    
    self.conversationName = [NSString new];
    self.messages = [NSMutableArray new];
    
    return self;
}

@end
