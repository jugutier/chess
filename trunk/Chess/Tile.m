
//
//  Tile.m
//  Chess
//
//  Created by julian Gutierrez on 12/03/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "Tile.h"
#import "Position.h"
#import "Board.h"
@implementation Tile
-(id)copyWithZone:(NSZone *)zone{
    id new = [[[self class]allocWithZone:zone]initWith:[[Position alloc]initWithX:self.position.x andY:self.position.y] andBoard: self.board andColor: self.color];
    return new;
}

//-(void)setBoard:(NSMutableArray *)newBoard{
//    _board = newBoard;
//}



-(BOOL)moveToPosition:(Position *)pos{
    self.position = pos;
    return YES;
}
-(BOOL) validateTrayectoryFrom:(Position *)from To:(Position *)to{
    NSMutableArray* posibles = [self getAvailablePositions];
    int count = [posibles count];
    [posibles removeObject:to];
    if ([posibles count] < count) {
        return YES;
    }
    return NO;

}
-(BOOL)isEmpty{
    return YES;
}

-(id) initWith:(Position*)pos andBoard:(Board*)board andColor:(int) color{
    self = [super init];
    if(self){
        _position = pos;
        _board = board;
        _color = color;
    }
    return self;
}

-(NSMutableArray *)getAvailablePositions{
    return nil;
}


-(UIImageView *) getImgSized:(int)size{
    if(self.img){
        [self.img removeFromSuperview];
    }
    self.img = [[UIImageView alloc]initWithFrame:CGRectMake(self.position.x*size, self.position.y*size, 40, 40)];
    
    return self.img;
}

//el server usa WHITE true/false
-(NSNumber *)getServerColor{
    return [NSNumber numberWithInt:(_color==WHITE)?1:0];
}
-(NSNumber *)getServerType{
    return nil;
}
-(NSString *)getImgPath{
    return nil;
}

-(BOOL)isCoronated{
    return NO;
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.board = [decoder decodeObjectForKey:@"tile_board"];
        self.position = [decoder decodeObjectForKey:@"position"];
        self.color = [decoder decodeInt32ForKey:@"color"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.board forKey:@"tile_board"];
    [encoder encodeObject:self.position forKey:@"position"];
    [encoder encodeInt32:self.color forKey:@"color"];
}

@end

