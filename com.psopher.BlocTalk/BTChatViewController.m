//
//  BTChatViewController.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 7/20/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTChatViewController.h"
#import "BTMPCHandler.h"
#import "BTUser.h"
#import "BTMessageData.h"
#import "BTDataSource.h"
#import "AppDelegate.h"
#import "BTMPCViewController.h"

@interface BTChatViewController ()

@property (strong, nonatomic) AppDelegate* appDelegate;
//@property (strong, nonatomic) MCPeerID* user;

@end

@implementation BTChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController.navigationBar setHidden:NO];
    self.title = self.conversation.conversationName;
    //        self.participateViewController.title = self.person;
    
    /**
     *  You MUST set your senderId and display name
     */
//    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
//    self.user = [[BTDataSource sharedInstance] userDisplayName];
//    self.user = [[BTDataSource sharedInstance] randomUser];
//    self.user = [self.appDelegate.mpcHandler peerID];
    
    self.senderId = [[BTDataSource sharedInstance].user.UUID UUIDString];
//    self.senderDisplayName = self.user.username;
    self.senderDisplayName = [BTDataSource sharedInstance].user.username;
    
    self.finishedSending = [NSNumber numberWithFloat:0];
    self.finishedReceiving = [NSNumber numberWithFloat:0];
    
    
    /**
     *  Load up our fake data for the demo
     */
//    self.demoData = [[BTDemoModelData alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveInvitationNotification)
                                                 name:@"MCDidReceiveInvitationNotification"
                                               object:nil];
    
    
    
    [self scrollToBottomAnimated:YES];
    
    /**
     *  You can set custom avatar sizes
     */
    if (![NSUserDefaults incomingAvatarSetting]) {
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    }
    
    if (![NSUserDefaults outgoingAvatarSetting]) {
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    }
    
    self.showLoadEarlierMessagesHeader = NO;
    
    //removes the attachment button
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    NSLog(@"This method fired: viewDidLoad");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = [NSUserDefaults springinessSetting];
    
    //    [self.demoData.messages removeAllObjects];
    //    [self.collectionView reloadData];
    
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
//    BTUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.appDelegate.mpcHandler setupPeerWithDisplayName:[BTDataSource sharedInstance].user.username];
    [self.appDelegate.mpcHandler advertiseSelf:YES];
    [self.appDelegate.mpcHandler setupBrowser];
    
    NSLog(@"This method fired: viewDidAppear");
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    
    self.finishedSending = [NSNumber numberWithFloat:0];
    
    if (text.length > 0)
    {
        
        BTMessageData *message = [[BTMessageData alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text channelName:[BTDataSource sharedInstance].user.username];
        NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:@[message]];
        
        //send the message
        NSError *error = nil;
        [self.appDelegate.mpcHandler.session sendData:messageData toPeers:self.appDelegate.mpcHandler.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
        NSLog(@"Error %@", error.localizedDescription);
        
        [self.conversation.messages addObject:message];
//        [[BTDataSource sharedInstance].messages addObject:message];
        
        //contains collectionView reloadData
        [self finishSendingMessage];
        self.finishedSending = [NSNumber numberWithFloat:1];
        
        NSDictionary *sentMessage = @{ @"data": messageData};
        
//        [[BTMPCHandler sharedInstance] addData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidSendNewMessage"
                                                                object:nil
                                                              userInfo:sentMessage];
        });
        
    }
    
    NSLog(@"This method fired: didPressSendButton");
}

#pragma mark - MCManager Notification handlers

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    //    NSLog(@"peerDidChangeStateWithNotification %@", notification);
    //    if ([notification.userInfo[@"state"] integerValue] == MCSessionStateConnected && self.demoData.messages > 0) {
    //        //send up to the most recent 30 messages if a new device connects and this device has messages
    //        NSData *recentMessageData = [NSKeyedArchiver archivedDataWithRootObject:[self.demoData.messages subarrayWithRange:NSMakeRange(0, MIN([self.demoData.messages count], 30))] ];
    //        NSError *error = nil;
    //        [self.multipeerManager.session sendData:recentMessageData toPeers:self.multipeerManager.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
    //        NSLog(@"did send data");
    //    }
    
}

- (void)peerDidReceiveDataWithNotification:(NSNotification *)notification
{

    self.finishedReceiving = [NSNumber numberWithFloat:0];
    [self.collectionView reloadData];
    self.finishedReceiving = [NSNumber numberWithFloat:1];
    

    NSLog(@"This method fired: peerDidReceiveDataWithNotification");
}

- (void)didReceiveInvitationNotification
{
    NSLog(@"didReceiveInvitation");
    //    [self.demoData.messages removeAllObjects];
    //    self.multipeerManager.numberOfMessagesInCurrentChannel = [[NSNumber numberWithInteger:[self.demoData.messages count]] stringValue];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.collectionView reloadData];
    }];
    
    NSLog(@"This method fired: didReceiveInvitationNotification");
}



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        NSDictionary *receivedMessage = @{ @"data": [self.conversation.messages objectAtIndex:indexPath.item]};

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveNewMessage"
                                                                object:nil
                                                              userInfo:receivedMessage];
        });
    
    NSLog(@"This should be legible if serializaion worked: %@", [self.conversation.messages objectAtIndex:indexPath.item]);
    
    NSLog(@"This method fired: messageDataForItemAtIndexPath");
    
    
    return [self.conversation.messages objectAtIndex:indexPath.item];
}

- (void) parseDataUserInfoDictionary:(NSDictionary *) unserializedMessageData fromRequestWithParameters:(NSDictionary *)parameters {
    NSLog(@"%@", unserializedMessageData);
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.conversation.messages objectAtIndex:indexPath.item];
    
    NSLog(@"This method fired: messageBubbleImageDataForItemAtIndexPath");
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return [BTDataSource sharedInstance].outgoingBubbleImageData;
    } else {
        return [BTDataSource sharedInstance].incomingBubbleImageData;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.conversation.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        if (![NSUserDefaults outgoingAvatarSetting]) {
            return nil;
        }
    }
    else {
        if (![NSUserDefaults incomingAvatarSetting]) {
            return nil;
        }
    }
    
    NSLog(@"This method fired: avatarImageDataForItemAtIndexPath");
    
    return [[BTDataSource sharedInstance].avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.conversation.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    NSLog(@"This method fired: attributedTextForCellTopLabelAtIndexPath");
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.conversation.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.conversation.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    
    NSLog(@"This method fired: attributedTextForMessageBubbleTopLabelAtIndexPath");
    
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"This method fired: attributedTextForCellBottomLabelAtIndexPath");
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSLog(@"The number of collection view items: %ld", [self.conversation.messages count]);
    return [self.conversation.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.conversation.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }

        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    NSLog(@"This method fired: cellForItemAtIndexPath");
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    NSLog(@"This method fired: heightForCellTopLabelAtIndexPath");
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.conversation.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.conversation.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    NSLog(@"This method fired: heightForMessageBubbleTopLabelAtIndexPath");
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"This method fired: heightForCellBottomLabelAtIndexPath");
    
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

@end
