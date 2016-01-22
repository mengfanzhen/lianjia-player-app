//
//  GeTuiPush.h
//  GeTuiPush
//
//  Created by X on 14-4-3.
//  Copyright (c) 2014年 io.dcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeTuiSdk.h"
#import "GeTuiSdkError.h"
#import "PGPush.h"

@interface PGGetuiPush : PGPush<GeTuiSdkDelegate> {
}

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;

- (NSMutableDictionary*)getClientInfoJSObjcet;
- (void) onRegRemoteNotificationsError:(NSError *)error;
- (void) onRevDeviceToken:(NSString *)deviceToken;
- (void) onAppEnterBackground;
- (void) onAppEnterForeground;
@end
