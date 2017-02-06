//
//  Queen.m
//  Chess
//
//  Created by Julian Gutierrez Ferrara  on 12/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import "Queen.h"
#import "Tower.h"
#import "Bishop.h"

@implementation Queen
-(BOOL)moveToPosition:(Position *)position{
    if( [[[Bishop alloc]initWith:[[Position alloc]initWithX:self.position.x andY:self.position.y] andBoard:self.board andColor:self.color]moveToPosition:position]||[[[Tower alloc]initWith:[[Position alloc]initWithX:self.position.x andY:self.position.y] andBoard:self.board andColor:self.color]moveToPosition:position]){
        [super moveToPosition:position];
        return YES;
    }
    return NO;
}
-(BOOL)isEmpty{
    return NO;
}

-(NSMutableArray*) getAvailablePositions{
    NSMutableArray *availables  = [[[Bishop alloc]initWith:self.position andBoard:self.board andColor:self.color]getAvailablePositions];
    NSMutableArray * availables2 = [[[Tower alloc]initWith:self.position andBoard:self.board andColor:self.color]getAvailablePositions];
    [availables addObjectsFromArray:availables2];
    return availables;
    
}

-(NSString *)getImgPath{
    NSString *color;
    if(self.color==BLACK){
        color = @"blue";
    }else{
        color = @"gold";
    }
    return [NSString stringWithFormat:@"queen_%@", color];
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
    return [NSNumber numberWithInt:4];
}
@end
