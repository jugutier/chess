//
//  AppDelegate.m
//  Chess
//
//  Created by Jorge Lorenzon on 3/12/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "AppDelegate.h"
#import "Game.h"
#import "Settings.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaultPrefs" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (SRWebSocket*) socket {
    if (_socket == nil) {
        Settings * userSettings = [[Settings alloc]init];
        NSString * ip = userSettings.ip;
        NSLog(@"ip = %@",ip);
        NSString * ipFormatted = [NSString stringWithFormat:@"ws://%@:9000/connectWS",ip];
        NSMutableURLRequest* joinMatchRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ipFormatted]];
        _socket = [[SRWebSocket alloc] initWithURLRequest:joinMatchRequest];
    }
    return _socket;
}


+ (AppDelegate*) sharedInstance {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end