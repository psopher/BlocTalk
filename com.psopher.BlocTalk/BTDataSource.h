//
//  BTDataSource.h
//  com.psopher.BlocTalk
//
//  Created by Philip Sopher on 5/12/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTDataSource : NSObject

+(instancetype) sharedInstance;

@property (nonatomic, strong, readonly) NSArray *mediaItems;

@end
