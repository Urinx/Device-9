//
//  PreToolsConfig.h
//  
//
//  Created by maximli on 15/4/20.
//  Copyright (c) 2015年 testin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PreToolsDelegate.h"
#import "PreToolsLog.h"

#if XCODE_VER_6_4

#   define NONNULL       _Nonnull
#   define NULLABLE      _Nullable

#else

#   define NONNULL
#   define NULLABLE

#endif

@interface PreToolsConfig : NSObject
{
    __unsafe_unretained id crashDelegate_;
}

// delegate.
@property(nonatomic, assign) id<PreToolsDelegate> crashDelegate;

// Exception monitor enabled, default YES.
@property(nonatomic, assign) BOOL enabledMonitorException;

// enabled shake to report problem, default NO.
@property(nonatomic, assign) BOOL enabledShakeReport;

// use user location info, default NO.
@property(nonatomic, assign) BOOL useLocationInfo;

// only wifi report data, default YES.
@property(nonatomic, assign) BOOL reportOnlyWIFI;

// set upload log level, default 0 nothing.
@property(nonatomic, assign) NSInteger uploadLogLevel;

// print log in simulator for debug, default NO.
@property(nonatomic, assign) BOOL printLogForDebug;


+ (PreToolsConfig*)defaultConfig;

@end
