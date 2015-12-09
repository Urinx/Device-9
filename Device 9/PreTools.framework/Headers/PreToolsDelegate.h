//
//  PreToolsDelegate.h
//  
//
//  Created by maximli on 15/5/22.
//  Copyright (c) 2015年 testin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PreToolsDelegate <NSObject>

@optional

- (void)receivedCrashNotification:(NSString*)stackTrace;

@end
