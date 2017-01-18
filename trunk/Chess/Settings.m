//
//  Settings.m
//  Chess
//
//  Created by julian Gutierrez on 25/05/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "Settings.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
@interface Settings(){
    BOOL isServer;
}
@end
@implementation Settings
- (id)init
{
    self = [super init];
    if (self) {
        isServer = YES;
        _ip = nil;
        isServer =[[NSUserDefaults standardUserDefaults] boolForKey:@"isServer_preference"];
        if(!isServer){
            _ip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ip_preference"];
        }else{
            _ip = [self getIPAddress];
        }
        _autosaveOnBack = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoSave_preference"];
    }
    return self;
}

- (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]||[name isEqualToString:@"en1"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : nil;
}
+(UIFont *)appfontMain{
    return [UIFont fontWithName:@"Phosphate" size:30.0f];
}
+(UIFont *)appfontSecondary{
    return [UIFont fontWithName:@"Superclarendon" size:20.0f];
}
@end
