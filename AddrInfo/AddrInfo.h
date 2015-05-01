//
//  AddrInfo.h
//  AddrInfo
//
//  Created by Calvin Cheng on 1/5/15.
//  Copyright (c) 2015 Hello HQ Pte. Ltd. All rights reserved.
//

#ifndef AddrInfo_AddrInfo_h
#define AddrInfo_AddrInfo_h

#import <Foundation/Foundation.h>

@interface AddrInfo : NSObject

@property (nonatomic, strong) NSString *hostname, *service;
@property (nonatomic) struct addrinfo *results;
@property (nonatomic) struct sockaddr *sa;
@property (nonatomic, readonly) int errorCode;

-(void)addrWithHostname:(NSString*)lHostname Service:(NSString *)lService andHints:(struct addrinfo*)lHints;

-(void)nameWithSockaddr:(struct sockaddr *)saddr;

-(NSString *)errorString;

@end


#endif
