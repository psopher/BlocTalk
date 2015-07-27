//
//  NSUserDefaults+DemoSettings.h
//  
//
//  Created by Philip Sopher on 7/27/15.
//
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (DemoSettings)

+ (void)saveExtraMessagesSetting:(BOOL)value;
+ (BOOL)extraMessagesSetting;

+ (void)saveLongMessageSetting:(BOOL)value;
+ (BOOL)longMessageSetting;

+ (void)saveEmptyMessagesSetting:(BOOL)value;
+ (BOOL)emptyMessagesSetting;

+ (void)saveSpringinessSetting:(BOOL)value;
+ (BOOL)springinessSetting;

+ (void)saveOutgoingAvatarSetting:(BOOL)value;
+ (BOOL)outgoingAvatarSetting;

+ (void)saveIncomingAvatarSetting:(BOOL)value;
+ (BOOL)incomingAvatarSetting;

@end
