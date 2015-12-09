//
//  Device9Kit.h
//  Device9Kit
//
//  Created by Eular on 12/9/15.
//  Copyright © 2015 Eular. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Device9Kit.
FOUNDATION_EXPORT double Device9KitVersionNumber;

//! Project version string for Device9Kit.
FOUNDATION_EXPORT const unsigned char Device9KitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Device9Kit/PublicHeader.h>

@interface Network : NSObject
-(NSString*) SSID;
-(NSString*) BSSID;
-(NSArray*) getAppList;
-(NSDictionary*) getDataFlowBytes;
-(NSString*) getIPAddress;
@end