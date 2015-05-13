//
//  BTConversationsTableViewCell.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/13/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTMedia;

@interface BTConversationsTableViewCell : UITableViewCell

+ (CGFloat) heightForMediaItem:(BTMedia *)mediaItem width:(CGFloat)width;

@property (nonatomic, strong) BTMedia *mediaItem;

@end
