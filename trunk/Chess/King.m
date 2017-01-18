//
//  King.m
//  Chess
//
//  Created by julian Gutierrez on 12/03/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "King.h"
#import "Tile.h"

@implementation King



-(BOOL)moveToPosition:(Position *)pos{
    if(abs(self.position.x -pos.x)<=1 && abs(self.position.y -pos.y)<=1){
        if([self validateTrayectoryFrom:self.position To:pos]){
            [super moveToPosition:pos];
            return YES;
        }
        return NO;
    }
    return NO;
}
-(BOOL) validateTrayectoryFrom:(Position *)pos To:(Position *)to{
    return [self.board isEmpty:to] ||  [self.board checkIfEnemiesFor:pos And:to];
}

-(BOOL)isEmpty{
    return NO;
}

-(NSMutableArray*) getAvailablePositions{
    NSMutableArray *availables = [[NSMutableArray alloc]init];
    for(int i = -1; i<=1; i = i+1){
        for(int j = -1; j<=1; j =j+1){
            if(self.position.x + i >= 0 && self.position.x + i < 8 && self.position.y + j >= 0 && self.position.y + j< 8){
                
                
                if([self.board checkIfEnemiesFor:[[Position alloc]initWithX:self.position.x+i andY:self.position.y+j]
                                             And:[[Position alloc]initWithX:self.position.x andY:self.position.y]]
                   || [self.board isEmpty:[[Position alloc] initWithX:self.position.x+i andY:self.position.y+j]] ){
                    
                    Position* p = [[Position alloc]initWithX: self.position.x +i andY: self.position.y+j];
                    [availables addObject: p];
                }
            }
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
    return [NSString stringWithFormat:@"king_%@", color];
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
    return [NSNumber numberWithInt:5];
}
@end
