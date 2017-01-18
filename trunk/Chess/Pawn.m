//
//  Pawn.m
//  Chess
//
//  Created by julian Gutierrez on 12/03/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "Pawn.h"
#import "Tile.h"
#import "Position.h"

@implementation Pawn

-(id)initWith:(Position*)pos andBoard:(Board *)board andColor:(int)color{
    self = [super initWith:pos andBoard: board andColor:color];
    if(self){
        _firstMove = YES;
    }
    return self;
}

-(void)setMoved:(BOOL)moved{
    self.firstMove = moved;
}

-(BOOL)moveToPosition:(Position *)pos{
    Position *starting = [[Position alloc]initWithX:self.position.x andY:self.position.y];
    if((_firstMove && self.position.x == pos.x && abs(self.position.y -pos.y)==2 && [self.board checkIfEnemiesFor:self.position And:pos]) ||
       ((self.position.x ==pos.x && abs(self.position.y -pos.y)==1) && [self.board checkIfEnemiesFor:self.position And:pos])|| ((abs(self.position.x -pos.x)==1) && (abs(self.position.y -pos.y)==1) && [self.board checkIfEnemiesFor:self.position And:pos])){
        // NSLog(@"destino valido\n");
        if([self validateTrayectoryFrom:starting To:pos]){
            // NSLog(@"trayectoria valida\n");
            [super moveToPosition:pos];
            if(_firstMove == YES){
                _firstMove = NO;
            }
            return YES;
        }
        return NO;
    }
    return NO;
}

-(BOOL)isEmpty{
    return NO;
}

-(NSMutableArray*) getAvailablePositions{
    NSMutableArray *availables = [[NSMutableArray alloc]init];
    if(self.color == WHITE){
        if((self.position.y-1 >= 0 && self.position.y-1 < 8) && ([self.board isEmpty:[[Position alloc]initWithX:self.position.x andY:self.position.y -1]])){
            [availables addObject:[[Position alloc]initWithX:self.position.x andY:self.position.y -1]];
        }
        if(_firstMove && [self.board isEmpty:[[Position alloc]initWithX:self.position.x andY:self.position.y -1]] && [self.board isEmpty:[[Position alloc]initWithX:self.position.x andY:self.position.y -2]]){
            [availables addObject:[[Position alloc]initWithX:self.position.x andY:self.position.y -2]];
        }
        if((self.position.y-1 >= 0 && self.position.y-1 < 8) && self.position.x+1 >= 0 && self.position.x+1 < 8 && [self.board checkIfEnemiesFor:[[Position alloc]initWithX:self.position.x+1 andY:self.position.y-1] And:[[Position alloc]initWithX:self.position.x andY:self.position.y]]){
            [availables addObject:[[Position alloc]initWithX:self.position.x+1 andY:self.position.y -1]];
        }
        if((self.position.y-1 >= 0 && self.position.y-1 < 8) && self.position.x-1 >= 0 && self.position.x-1 < 8 && [self.board checkIfEnemiesFor:[[Position alloc]initWithX:self.position.x-1 andY:self.position.y-1] And:[[Position alloc]initWithX:self.position.x andY:self.position.y]]){
            [availables addObject:[[Position alloc]initWithX:self.position.x-1 andY:self.position.y -1]];
        }
    }else{
        if(((self.position.y+1 >= 0 && self.position.y+1 < 8) && [self.board isEmpty:[[Position alloc]initWithX:self.position.x andY:self.position.y +1]])){
            [availables addObject:[[Position alloc]initWithX:self.position.x andY:self.position.y +1]];
        }
        if(_firstMove && (self.position.y+1 >= 0 && self.position.y+1 < 8) && [self.board isEmpty:[[Position alloc]initWithX:self.position.x andY:self.position.y +1]] && [self.board isEmpty:[[Position alloc]initWithX:self.position.x andY:self.position.y +2]]){
            [availables addObject:[[Position alloc]initWithX:self.position.x andY:self.position.y +2]];
        }
        if((self.position.y+1 >= 0 && self.position.y+1 < 8) && self.position.x+1 >= 0 && self.position.x+1 < 8 && [self.board checkIfEnemiesFor:[[Position alloc]initWithX:self.position.x+1 andY:self.position.y+1] And:[[Position alloc]initWithX:self.position.x andY:self.position.y]]){
            [availables addObject:[[Position alloc]initWithX:self.position.x+1 andY:self.position.y +1]];
        }
        if((self.position.y+1 >= 0 && self.position.y+1 < 8) && self.position.x-1 >= 0 && self.position.x-1 < 8 && [self.board checkIfEnemiesFor:[[Position alloc]initWithX:self.position.x-1 andY:self.position.y+1] And:[[Position alloc]initWithX:self.position.x andY:self.position.y]]){
            [availables addObject:[[Position alloc]initWithX:self.position.x-1 andY:self.position.y +1]];
        }
    }
    
    return availables;
    
}

-(NSString *)getImgPath{
    NSString *color;
    if(self.color==BLACK){
        color = @"blue";
    }else{
        color = @"gold";
    }
    return [NSString stringWithFormat:@"pawn_%@", color];
}

-(UIImageView *) getImgSized:(int)size{
    if(!self.img){
        UIImage * temp = [UIImage imageNamed:[self getImgPath]];
        
        self.img = [[UIImageView alloc]initWithImage:temp];
        [self.img setFrame:CGRectMake(self.position.x*size, self.position.y*size, 40, 40)];
        [self.img setAccessibilityIdentifier: [self getImgPath]];
    }
    return self.img;
}
-(NSNumber *)getServerType{
    return [NSNumber numberWithInt:0];
}

-(BOOL)isCoronated{
    return YES;
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        self.firstMove = [decoder decodeBoolForKey:@"pawn_firstmove"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:self.firstMove forKey:@"pawn_firstmove"];
}

@end
