//
//  Position.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 12/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject<NSCoding>
@property(nonatomic) int x;
@property(nonatomic) int y;
-(id) initWithX:(int)x andY:(int)y;
-(id) initWithIndex:(int)index;
- (BOOL)isEqualToPosition:(Position *)pos;
@end
