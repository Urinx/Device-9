//
//  PreToolsLog.h
//  
//
//  Created by maximli on 15/6/8.
//  Copyright (c) 2015年 testin. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef TAPM_DEBUG_DISABLE

#define TLOG(nsstring_format, ...)
#define TLOGE(nsstring_format, nsstring_tag ...)

#define TLOG_ERROR(nsstring_format, ...)
#define TLOG_WARN(nsstring_format, ...)
#define TLOG_INFO(nsstring_format, ...)
#define TLOG_VERB(nsstring_format, ...)

#else

#define TLOG_ERROR(nsstring_format, ...) TLOGE(TLogLevelError, nil, nsstring_format, ##__VA_ARGS__)
#define TLOG_WARN(nsstring_format, ...)  TLOGE(TLogLevelWarning, nil, nsstring_format, ##__VA_ARGS__)
#define TLOG_INFO(nsstring_format, ...)  TLOGE(TLogLevelInfo, nil, nsstring_format, ##__VA_ARGS__)
#define TLOG_VERB(nsstring_format, ...)  TLOGE(TLogLevelVerbose, nil, nsstring_format, ##__VA_ARGS__)

#define TLOG(nsstring_format, ...)    \
do {                        \
[PreToolsLog logWithLevel:TLogLevelInfo \
                    tag:nil \
                   file:[NSString stringWithUTF8String:__FILE__] \
                 method:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                   line:__LINE__ \
             stacktrace:[NSThread callStackReturnAddresses]\
                 format:nsstring_format, ##__VA_ARGS__];\
} while(0)

#define TLOGE(TLogLevel, nsstring_tag, nsstring_format, ...)    \
do {                        \
[PreToolsLog logWithLevel:TLogLevel \
                    tag:nsstring_tag \
                   file:[NSString stringWithUTF8String:__FILE__] \
                 method:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                   line:__LINE__ \
             stacktrace:[NSThread callStackReturnAddresses]\
                 format:nsstring_format, ##__VA_ARGS__];\
} while(0)

#endif //TAPM_DEBUG_DISABLE

typedef enum __TLogLevel
{
    TLogLevelAll      = 0xFFFF,
    TLogLevelError    = 1 << 0,
    TLogLevelWarning  = 1 << 1,
    TLogLevelInfo     = 1 << 2,
    TLogLevelVerbose  = 1 << 3,
}TLogLevel;

@interface PreToolsLog : NSObject


+ (void)logWithLevel:(TLogLevel)level
                 tag:(NSString*)tag
                file:(NSString*)file
              method:(NSString*)method
                line:(NSInteger)line
          stacktrace:(NSArray*)stacktrace
              format:(NSString*)format, ...;

+ (void)logWithLevel:(TLogLevel)level
                 tag:(NSString*)tag
                file:(NSString*)file
              method:(NSString*)method
                line:(NSInteger)line
          stacktrace:(NSArray*)stacktrace
       outputConsole:(BOOL)outputConsole
              format:(NSString*)format, ...;

@end
