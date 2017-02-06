//
//  Bishop.m
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 12/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import "Bishop.h"
#import "Math.h"

@implementation Bishop
-(BOOL)moveToPosition:(Position *)position{
    Position *starting = [[Position alloc]initWithX:self.position.x andY:self.position.y];
    if(abs(self.position.x -position.x)==abs(self.position.y -position.y) && [self.board checkIfEnemiesFor:self.position And:position]){
        if([self validateTrayectoryFrom:starting To:position]){
            [super moveToPosition:position];
            return YES;
        }
    }
    return NO;
}

-(BOOL)isEmpty{
    return NO;
}


-(NSMutableArray*) getAvailablePositions{
    NSMutableArray *availables = [[NSMutableArray alloc]init];
    Position* pos = [[Position alloc]initWithX:self.position.x andY:self.position.y];
    [self getAvailablePositionWrap:availables beginning:pos withX:1 andY:1];
    [self getAvailablePositionWrap:availables beginning:pos withX:1 andY:-1];
    [self getAvailablePositionWrap:availables beginning:pos withX:-1 andY:1];
    [self getAvailablePositionWrap:availables beginning:pos withX:-1 andY:-1];
    return availables;
    
}

-(void)getAvailablePositionWrap: (NSMutableArray*)availables beginning:(Position *) pos withX:(int)x andY:(int)y{
    Position* avPos = [[Position alloc]initWithX:pos.x+x andY:pos.y+y];
    if( pos.x+x < 0 || pos.x+x > 7 || pos.y+y < 0 || pos.y+y >7 ){
        return;
    }
    if([self.board checkIfEnemiesFor:[[Position alloc]initWithX:self.position.x andY:self.position.y] And:avPos]){
        [availables addObject:avPos];
        if([self.board isEmpty:avPos]){
            [self getAvailablePositionWrap:availables beginning: avPos withX:x andY:y];
        }
    }
    
    return;
}

-(NSString *)getImgPath{
    NSString *color;
    if(self.color==BLACK){
        color = @"blue";
    }else{
        color = @"gold";
    }
    return [NSString stringWithFormat:@"bishop_%@", color];
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
    return [NSNumber numberWithInt:2];
}
@end
