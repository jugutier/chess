//
//  AppDelegate.h
//  Chess
//
//  Created by Julian Gutierrez on 3/12/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketRocket/SocketRocket.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) SRWebSocket * socket;

+ (AppDelegate*) sharedInstance;

@end
