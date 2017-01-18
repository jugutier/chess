//
//  Horse.m
//  Chess
//
//  Created by julian Gutierrez on 12/03/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "Knight.h"

@implementation Knight
-(BOOL)moveToPosition:(Position *)position{
    if(position.x == self.position.x+2 && position.y == self.position.y+1 && [self.board checkIfEnemiesFor:self.position And:position]){
        [super moveToPosition:position];
        return YES;
    }
    else if(position.x ==self.position.x+2 && position.y ==self.position.y-1 && [self.board checkIfEnemiesFor:self.position And:position]){
        [super moveToPosition:position];
        return YES;
    }
    else if(position.x ==self.position.x-2 && position.y ==self.position.y+1 && [self.board checkIfEnemiesFor:self.position And:position]){
        [super moveToPosition:position];
        return YES;
    }
    else if(position.x ==self.position.x-2 && position.y ==self.position.y-1 && [self.board checkIfEnemiesFor:self.position And:position]){
        [super moveToPosition:position];
        return YES;
    }
    else if(position.x ==self.position.x+1 && position.y ==self.position.y-2 && [self.board checkIfEnemiesFor:self.position And:position]){
        [super moveToPosition:position];
        return YES;
    }
    else if(position.x ==self.position.x-1 && position.y ==self.position.y-2 && [self.board checkIfEnemiesFor:self.position And:position]){
        [super moveToPosition:position];
        return YES;
    }
    else if(position.x ==self.position.x+1 && position.y ==self.position.y+2 && [self.board checkIfEnemiesFor:self.position And:position]){
        [super moveToPosition:position];
        return YES;
    }
    else if(position.x ==self.position.x-1 && position.y ==self.position.y+2 && [self.board checkIfEnemiesFor:self.position And:position]){
        [super moveToPosition:position];
        return YES;
    }
    return NO;
}
-(BOOL)isEmpty{
    return NO;
}

-(NSMutableArray*) getAvailablePositions{
    NSMutableArray *availables = [[NSMutableArray alloc]init];
    Position * myPos = [[Position alloc]initWithX:self.position.x andY:self.position.y];
    if(self.position.x +2 >= 0 && self.position.x +2 <8 && self.position.y+1 >=0 && self.position.y+1 < 8 &&
       [self.board checkIfEnemiesFor:myPos And:[[Position alloc]initWithX:self.position.x +2 andY:self.position.y+1]]){
        [availables addObject:[[Position alloc]initWithX:self.position.x +2 andY:self.position.y+1]];
    }
    if(self.position.x +2 >= 0 && self.position.x +2 <8 && self.position.y-1 >=0 && self.position.y-1 < 8 &&
       [self.board checkIfEnemiesFor:myPos And:[[Position alloc]initWithX:self.position.x +2 andY:self.position.y-1]]){
        [availables addObject:[[Position alloc]initWithX:self.position.x +2 andY:self.position.y-1]];
    }
    if(self.position.x -2 >= 0 && self.position.x -2 <8 && self.position.y+1 >=0 && self.position.y+1 < 8 &&
       [self.board checkIfEnemiesFor:myPos And:[[Position alloc]initWithX:self.position.x -2 andY:self.position.y+1]]){
        [availables addObject:[[Position alloc]initWithX:self.position.x -2 andY:self.position.y+1]];
    }
    if(self.position.x -2 >= 0 && self.position.x -2 <8 && self.position.y-1 >=0 && self.position.y-1 < 8 &&
       [self.board checkIfEnemiesFor:myPos And:[[Position alloc]initWithX:self.position.x -2 andY:self.position.y-1]]){
        [availables addObject:[[Position alloc]initWithX:self.position.x -2 andY:self.position.y-1]];
    }
    if(self.position.x +1 >= 0 && self.position.x +1 <8 && self.position.y-2 >=0 && self.position.y-2 < 8 &&
       [self.board checkIfEnemiesFor:myPos And:[[Position alloc]initWithX:self.position.x +1 andY:self.position.y-2]]){
        [availables addObject:[[Position alloc]initWithX:self.position.x +1 andY:self.position.y-2]];
    }
    if(self.position.x -1 >= 0 && self.position.x -1 <8 && self.position.y-2 >=0 && self.position.y-2 < 8 &&
       [self.board checkIfEnemiesFor:myPos And:[[Position alloc]initWithX:self.position.x -1 andY:self.position.y-2]]){
        [availables addObject:[[Position alloc]initWithX:self.position.x -1 andY:self.position.y-2]];
    }
    if(self.position.x +1 >= 0 && self.position.x +1 <8 && self.position.y+2 >=0 && self.position.y+2 < 8 &&
       [self.board checkIfEnemiesFor:myPos And:[[Position alloc]initWithX:self.position.x +1 andY:self.position.y+2]]){
        [availables addObject:[[Position alloc]initWithX:self.position.x +1 andY:self.position.y+2]];
    }
    if(self.position.x -1 >= 0 && self.position.x -1 <8 && self.position.y+2 >=0 && self.position.y+2 < 8 &&
       [self.board checkIfEnemiesFor:myPos And:[[Position alloc]initWithX:self.position.x -1 andY:self.position.y+2]]){
        [availables addObject:[[Position alloc]initWithX:self.position.x -1 andY:self.position.y+2]];
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
    return [NSString stringWithFormat:@"knight_%@", color];
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
    return [NSNumber numberWithInt:1];
}

@end
