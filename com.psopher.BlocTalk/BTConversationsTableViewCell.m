//
//  BTConversationsTableViewCell.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/13/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTConversationsTableViewCell.h"
#import "BTMPCHandler.h"
#import "BTDataSource.h"
#import "BTChatViewController.h"
#import "BTConversation.h"

@interface BTConversationsTableViewCell ()

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
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
        self.usernameLabel = [[UILabel alloc] init];
        self.usernameLabel.numberOfLines = 0;
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.numberOfLines = 0;
        
        self.archiveButton = [[UIButton alloc] init];
        self.moreButton = [[UIButton alloc] init];
        
        for (UIView *view in @[self.usernameLabel, self.messageLabel]) {
            [self.contentView addSubview:view];
        }
        
        if ([BTDataSource sharedInstance].conversations != nil) {
            self.cellShouldUpdate = YES;
        } else {
            self.cellShouldUpdate = NO;
        }
    }
    
    NSLog(@"This method fired: BTConversationsTableViewCell initWithStyle");
    
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
    
    NSLog(@"This method fired: BTConversationsTableViewCell load");
}


- (NSAttributedString *) usernameString {
    
    if (self.cellShouldUpdate) {
        
        CGFloat usernameFontSize = 15;
    
        // Make a string that says "username text"
    
        NSString *baseString = [NSString stringWithFormat:@"%@", [self.conversation conversationName]];
    

    
        // Make an attributed string, with the "username" bold
        NSMutableAttributedString *mutableUsernameString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [boldFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName : paragraphStyle}];
    
        NSLog(@"This method fired: BTConversationsTableViewCell usernameString");
        
        return mutableUsernameString;
        
    } else {
        return nil;
    }
}

- (NSAttributedString *) messageString {
    
    if (self.cellShouldUpdate) {
    
        NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] init];
    
        NSString *baseString = [NSString stringWithFormat:@"%@", [self.conversation.messages.lastObject text]];
        
        NSMutableAttributedString *oneCommentString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
        
        [messageString appendAttributedString:oneCommentString];
    
        NSLog(@"This method fired: BTConversationsTableViewCell messageString");
        
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
    
    
    NSLog(@"This method fired: BTConversationsTableViewCell sizeForMessageLabel");
    
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
    
    NSLog(@"This method fired: BTConversationsTableViewCell layoutSubviews");
    
    // Hide the line between cells
//    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.bounds));
}

- (void) setConversation:(BTConversation *)conversation{
    _conversation = conversation;
    self.usernameLabel.attributedText = [self usernameString];
    self.messageLabel.attributedText = [self messageString];
    
    NSLog(@"This method fired: BTConversationsTableViewCell setConversation");
}

+ (CGFloat) heightForMediaItem:(BTConversation *)conversation width:(CGFloat)width {
    
    // Make a cell
    BTConversationsTableViewCell *layoutCell = [[BTConversationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    
    // Set it to the given width, and the maximum possible height
    layoutCell.frame = CGRectMake(0, 0, width, 100);
    
    // Give it the media item
    layoutCell.conversation = conversation;
    
    // Make it adjust the image view and labels
    [layoutCell layoutSubviews];
    
    NSLog(@"This method fired: BTConversationsTableViewCell heightForMediaItem");
    
    // The height will be wherever the bottom of the messages label is
    return CGRectGetMaxY(layoutCell.messageLabel.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    NSLog(@"This method fired: BTConversationsTableViewCell setSelected");
    
    // Configure the view for the selected state
}


@end
