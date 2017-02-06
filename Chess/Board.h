//
//  Board.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 12/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Position.h"
@class King;
@class Tile;
@interface Board : NSObject<NSCoding, NSCopying>

@property(nonatomic, retain) King* blueKing;
@property(nonatomic, retain) King* whiteKing;

-(BOOL)isEmpty:(Position *)pos;
-(NSMutableArray *)getAvailablePositionsForRow:(int)row andColumn:(int)column;
-(BOOL)moveFromPostion:(Position *)lastPosition toPosition:(Position *)destination;
-(void)setImages;
-(UIImageView*)getImgOnX:(int)x andY:(int)y withSize:(int)size;
-(int)getColorOnX:(int)x andY:(int)y;
-(bool)checkIfEnemiesFor:(Position*)attack And:(Position*)defense;
-(int)checkJaqueForKing:(King*)king; // 0 jaquemate | 1 jaque | 2 its safe
-(NSMutableArray*) enemiesForColor:(int)color;
-(int)indexForRow:(int)row column:(int)column;
-(NSDictionary *)toJSON;
-(void) setFromJSONString:(NSArray *) array withSize:(int) size;
-(Tile *) getTileFromServerType:(NSNumber *) type withPosition:(Position *) pos andColor:(NSNumber *)nColor;
-(void) updateView:(UIView*) view withSize:(int)size;
-(int)checkCoronation;
-(void)coronate:(Tile*) tile into:(int)pos;
-(id)copyWithZone:(NSZone *)zone;
-(NSMutableArray*)enemiesMoves:(NSMutableArray*)enemies;
-(BOOL)saveTheKing:(int)color withMove:(Position*)pFrom to:(Position*)pTo;
-(void)enemiesMovesForTurn:(int)turn;
-(BOOL)getTheBulletForKing:(int)turn;
@end
