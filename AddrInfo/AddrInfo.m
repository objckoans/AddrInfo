//
//  AddrInfo.m
//  AddrInfo
//
//  Created by Calvin Cheng on 1/5/15.
//  Copyright (c) 2015 Hello HQ Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddrInfo.h"
#import <netdb.h>
#import <netinet/in.h>
#import <netinet6/in6.h>

@implementation AddrInfo

@synthesize results = _results;

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setVars];
    }
    
    return self;
}

-(void)setVars {
    self.hostname = @"";
    self.service = @"";
    //self.results = (__bridge struct addrinfo *)(@"");
    _errorCode = 0;
}

// casting to set our results from struct to NSString
-(void)setResults:(struct addrinfo *)lResults {
    freeaddrinfo(self.results);
    _results = lResults;
}

-(void)addrWithHostname:(NSString*)lHostname Service:(NSString *)lService andHints:(struct addrinfo*)lHints {
    [self setVars];
    self.hostname = lHostname;
    self.service = lService;
    struct addrinfo *res;
    
    // POSIX API call: given hostname, return us socket address
    // under-the-hood, these POSIX functions send our requests to appropriate DNS servers to perform the resolution
    _errorCode = getaddrinfo([self.hostname UTF8String], [self.service UTF8String], lHints, &res);
    self.results = res;
}

-(void)nameWithSockaddr:(struct sockaddr *)saddr {
    [self setVars];
    char host[1024];
    char serv[20];
    
    // POSIX API call: given socket address, return us the hostname
    // under-the-hood, these POSIX functions send our requests to appropriate DNS servers to perform the resolution
    _errorCode = getnameinfo(saddr, sizeof(saddr), host, sizeof(host), serv, sizeof(serv), 0);
    self.hostname = [NSString stringWithUTF8String:host];
    self.service = [NSString stringWithUTF8String:serv];
    
}

-(NSString *)errorString {
    return [NSString stringWithCString:gai_strerror(_errorCode) encoding:NSASCIIStringEncoding];
}

@end
