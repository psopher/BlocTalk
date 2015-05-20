//
//  AppDelegate.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/11/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTMPCHandler;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) BTMPCHandler *mpcHandler;


@end

