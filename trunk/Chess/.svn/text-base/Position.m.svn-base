//
//  Position.m
//  Chess
//
//  Created by julian Gutierrez on 12/03/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "Position.h"

@implementation Position

-(id) initWithX:(int)x andY:(int)y{
    self = [super init];
    if (self) {
        _x = x;
        _y= y;
    }
    return self;
    
}

-(id) initWithIndex:(int)index{
    self = [super init];
    if (self) {
        _x = (index%8);
        _y = (index/8);
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:_x forKey:@"x"];
    [encoder encodeInt32:_y forKey:@"y"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _x = [decoder decodeInt32ForKey:@"x"];
        _y = [decoder decodeInt32ForKey:@"y"];
    }
    return self;
}

- (BOOL)isEqual:(Position*)pos {
    if (pos == self)
        return YES;
    if (!pos || ![pos isKindOfClass:[self class]])
        return NO;
    return [self isEqualToPosition:pos];
}

- (BOOL)isEqualToPosition:(Position *)pos {
    if (self == pos){
         return YES;
    }

    if (self.x != pos.x)
        return NO;
    if (self.y != pos.y)
        return NO;
    return YES;
}



@end
