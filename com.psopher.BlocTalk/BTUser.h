//
//  BTUser.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BTUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSUUID *UUID;
-(instancetype)initWithUsername:(NSString *)username;
-(instancetype)initWithUsername:(NSString *)username UUID:(NSUUID *)UUID;

@end
