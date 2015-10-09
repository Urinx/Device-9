//
//  Bridging-Header.h
//  Device 9
//
//  Created by Eular on 9/19/15.
//  Copyright © 2015 Eular. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#include <objc/runtime.h>
#import "WXApi.h"

@interface ObjC : NSObject

-(NSString*) SSID;
-(NSString*) BSSID;
- (NSArray*) getAppList;
-(NSDictionary*) getDataFlowBytes;

@end