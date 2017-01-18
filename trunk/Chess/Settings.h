//
//  Settings.h
//  Chess
//
//  Created by julian Gutierrez on 25/05/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
@property(nonatomic,retain) NSString * ip;
@property(nonatomic) BOOL autosaveOnBack;
+(UIFont *)appfontMain;
+(UIFont *)appfontSecondary;
@end
