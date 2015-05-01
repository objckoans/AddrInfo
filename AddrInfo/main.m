//
//  main.m
//  AddrInfo
//
//  Created by Calvin Cheng on 1/5/15.
//  Copyright (c) 2015 Hello HQ Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddrInfo.h"
#import <netdb.h>
#import <arpa/inet.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        struct addrinfo *res;
        struct addrinfo hints;
        
        memset(&hints, 0, sizeof(hints));
        hints.ai_family = AF_UNSPEC;
        hints.ai_socktype = SOCK_STREAM;
        
        AddrInfo *ai = [[AddrInfo alloc] init];
        [ai addrWithHostname:@"www.yahoo.com" Service:@"443" andHints:&hints];
        if (ai.errorCode != 0) {
            NSLog(@"Error in getaddrinfo(): %@", [ai errorString]);
            return -1;
        }
        
        // display results
        struct addrinfo *results = ai.results;
        for (res = results; res != NULL; res = res->ai_next) {
            void *addr;
            NSString *ipver = @"";
            char ipstr[INET6_ADDRSTRLEN];
            
            if (res->ai_family == AF_INET) {
                struct sockaddr_in *ipv4 = (struct sockaddr_in *)res->ai_addr;
                addr = &(ipv4->sin_addr);
                ipver = @"IPv4";
            } else if (res->ai_family == AF_INET6) {
                struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)res->ai_addr;
                addr = &(ipv6->sin6_addr);
                ipver = @"IPv6";
            } else {
                continue;
            }
            
            inet_ntop(res->ai_family, addr, ipstr, sizeof(ipstr));
            NSLog(@"    %@  %s", ipver, ipstr);
            
            AddrInfo *ai2 = [[AddrInfo alloc] init];
            [ai2 nameWithSockaddr:res->ai_addr];
            if (ai2.errorCode == 0) {
                NSLog(@"--%@ %@", ai2.hostname, ai2.service);
            }
            
        }
        freeaddrinfo(results);
        
    }
    return 0;
}
