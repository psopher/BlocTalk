//
//  BTUser.m
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BTUser.h"
#import "AppDelegate.h"
#import "BTMPCHandler.h"

@implementation BTUser

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *username = [aDecoder decodeObjectForKey:@"username"];
    NSUUID *UUID = [aDecoder decodeObjectForKey:@"UUID"];
    return [self initWithUsername:username UUID:UUID];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_UUID forKey:@"UUID"];
}

-(instancetype)initWithUsername:(NSString *)username UUID:(NSUUID *)UUID;
{
    self = [super init];
    
    if (self) {
        _username = username;
        _UUID = UUID;
    }
    return self;
}

-(instancetype)initWithUsername:(NSString *)username;
{
    return [self initWithUsername:username UUID:[[UIDevice currentDevice] identifierForVendor]];
}

- (instancetype)init
{
    return [self initWithUsername:@""];
}


@end
