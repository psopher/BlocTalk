//
//  BTConversation.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 8/11/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTConversation : NSObject

@property (strong, nonatomic) NSMutableArray* messages;
@property (strong, nonatomic) NSString* conversationName;

@end
