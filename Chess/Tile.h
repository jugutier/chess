//
//  Tile.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 12/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Position.h"
#import "Board.h"
#define BLANK 2
#define BLACK 0
#define WHITE 1
@interface Tile : NSObject<NSCoding, NSCopying>

@property(nonatomic,retain,getter = getImg) UIImageView * img;
@property(nonatomic,weak) Board* board;
@property(nonatomic, retain, getter = getPosition)Position * position;
@property(nonatomic, getter = getColor) int color; //0=blank, 1=black, 2=white;
-(BOOL)moveToPosition:(Position *)pos;
-(BOOL) validateTrayectoryFrom:(Position *)from To:(Position*)to;
-(BOOL) isEmpty;
-(id)initWith:(Position*)pos andBoard:(Board*)board andColor:(int) color;
-(NSMutableArray*) getAvailablePositions;
-(UIImageView *) getImgSized:(int)size;
-(NSString *)getImgPath;
-(NSNumber *)getServerColor;
-(NSNumber *)getServerType;
-(BOOL)isCoronated;
@end
