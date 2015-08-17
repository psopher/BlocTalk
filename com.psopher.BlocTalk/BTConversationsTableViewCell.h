//
//  BTConversationsTableViewCell.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/13/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>

@class BTConversation;

@interface BTConversationsTableViewCell : SWTableViewCell <SWTableViewCellDelegate>

+ (CGFloat) heightForMediaItem:(BTConversation *)conversation width:(CGFloat)width;

@property (nonatomic, strong) BTConversation *conversation;

@end
