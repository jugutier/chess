//
//  Settings.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 25/05/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
@property(nonatomic,retain) NSString * ip;
@property(nonatomic) BOOL autosaveOnBack;
+(UIFont *)appfontMain;
+(UIFont *)appfontSecondary;
@end
