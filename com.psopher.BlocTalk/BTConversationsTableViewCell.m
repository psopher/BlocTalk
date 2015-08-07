//
//  BTConversationsTableViewCell.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/13/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTConversationsTableViewCell.h"
#import "BTMedia.h"
//#import "BTMessageContent.h"
#import "BTUser.h"
#import "BTMPCHandler.h"
#import "BTMessageData.h"
//#import "BTMultiPeerConnectivity.h"
#import "BTChatViewController.h"

@interface BTConversationsTableViewCell ()

//@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) BTChatViewController* sentNewMessage;
@property (nonatomic, strong) BTChatViewController* receivedNewMessage;
@property (nonatomic, assign) BOOL cellShouldUpdate;


@end

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *usernameLabelGray;
static UIColor *messageLabelGray;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;

@implementation BTConversationsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.mediaImageView = [[UIImageView alloc] init];
        self.usernameLabel = [[UILabel alloc] init];
        self.usernameLabel.numberOfLines = 0;
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.numberOfLines = 0;
        
//        for (UIView *view in @[self.usernameLabel, self.messageLabel, self.mediaImageView]) {
        for (UIView *view in @[self.usernameLabel, self.messageLabel]) {
            [self.contentView addSubview:view];
        }
        
        self.receivedNewMessage = [[BTChatViewController alloc] init];
        self.sentNewMessage = [[BTChatViewController alloc] init];
        
        if (self.sentNewMessage.finishedSending || self.receivedNewMessage.finishedReceiving) {
            self.cellShouldUpdate = 1;
        } else {
            self.cellShouldUpdate = 0;
        }
    }
    return self;
}

+ (void)load {
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    usernameLabelGray = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    messageLabelGray = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1]; /*#e5e5e5*/
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1]; /*#58506d*/
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    
    paragraphStyle = mutableParagraphStyle;
}



//- (BOOL) cellShouldUpdate {
//    if ([self.receivedNewMessage finishSendingMessageAnimated:YES]) {
//        return 1;
//    } else {
//        return 0;
//    }
//}

- (NSAttributedString *) usernameString {
    
    if (self.cellShouldUpdate) {
        
        CGFloat usernameFontSize = 15;
    
        // Make a string that says "username text"
    
        NSString *baseString = [NSString stringWithFormat:@"%@", [[BTMPCHandler sharedInstance].messages objectAtIndex:1]];
    

    
        // Make an attributed string, with the "username" bold
        NSMutableAttributedString *mutableUsernameString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [boldFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName : paragraphStyle}];
    
        return mutableUsernameString;
        
    } else {
        return nil;
    }
}

- (NSAttributedString *) messageString {
    
    if (self.cellShouldUpdate) {
    
        NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] init];
    
        //    for (BTMessageContent *message in self.mediaItem.messageContent) {
        //        NSString *baseString = [NSString stringWithFormat:@"%@", message.text];
        NSString *baseString = [NSString stringWithFormat:@"%@", [[BTMPCHandler sharedInstance].messages objectAtIndex:4]];
        
        NSMutableAttributedString *oneCommentString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
        
        [messageString appendAttributedString:oneCommentString];
//    }
    
        return messageString;
    } else {
        return nil;
    }
}

- (CGSize) sizeOfString:(NSAttributedString *)string {
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) - 40, 0.0);
    CGRect sizeRect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    sizeRect.size.height += 20;
    sizeRect = CGRectIntegral(sizeRect);
    return sizeRect.size;
}

- (CGSize)sizeForMessageLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, 2 * label.font.lineHeight);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:UILineBreakModeWordWrap];
    
    return size;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat imageHeight = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.imageView.bounds);
//    self.mediaImageView.frame = CGRectMake(0, 0, 70, 70);
    
    CGSize sizeOfUsernameLabel = [self sizeOfString:self.usernameLabel.attributedText];
    
    self.usernameLabel.frame = CGRectMake(70, 0, CGRectGetWidth(self.contentView.bounds), sizeOfUsernameLabel.height);
    
//    CGSize sizeOfMessageLabel = [self sizeOfString:self.messageLabel.attributedText];
    
    CGSize sizeOfMessageLabel = [self sizeForMessageLabel:self.messageLabel];
    
    CGFloat messageLabelHeight = 70 - sizeOfUsernameLabel.height;
    
//    self.messageLabel.frame = CGRectMake(70, CGRectGetMaxY(self.usernameLabel.frame), CGRectGetWidth(self.contentView.bounds), messageLabelHeight);
    
    CGFloat messageLabelWidth = CGRectGetWidth(self.contentView.bounds) - 80;
    
    self.messageLabel.frame = CGRectMake(70, CGRectGetMaxY(self.usernameLabel.frame), messageLabelWidth, messageLabelHeight);
    
    // Hide the line between cells
//    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.bounds));
}

- (void) setMediaItem:(BTMedia *)mediaItem {
    _mediaItem = mediaItem;
//    self.mediaImageView.image = _mediaItem.image;
    self.usernameLabel.attributedText = [self usernameString];
    self.messageLabel.attributedText = [self messageString];
}

+ (CGFloat) heightForMediaItem:(BTMedia *)mediaItem width:(CGFloat)width {
    // Make a cell
    BTConversationsTableViewCell *layoutCell = [[BTConversationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    
    // Set it to the given width, and the maximum possible height
    layoutCell.frame = CGRectMake(0, 0, width, 100);
    
    // Give it the media item
    layoutCell.mediaItem = mediaItem;
    
    // Make it adjust the image view and labels
    [layoutCell layoutSubviews];
    
    // The height will be wherever the bottom of the messages label is
    return CGRectGetMaxY(layoutCell.messageLabel.frame);
}


@end
