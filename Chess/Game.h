//
//  Game.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 20/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "Tile.h"
@interface Game : NSObject<NSCoding>
@property (nonatomic) int turn; //1=black, 2=white
@property (nonatomic,retain) Board* board;
@property(nonatomic,retain) NSMutableDictionary * metadata;
@property(nonatomic) BOOL endGame;
@property(nonatomic) int blueOnJaque;
@property(nonatomic) int whiteOnJaque;
@property(nonatomic, retain) King* blueKing;
@property(nonatomic, retain) King* whiteKing;
@property(nonatomic) int playerColor;
@property(nonatomic, retain) NSDate* start;
@property(nonatomic) int coronation;

+(Game *) getNewInstance;
+(Game * )getInstance;
+(Game *) getInstanceFromGame:(Game*)game;
+(BOOL)isOnline;
+(void)saveGame;
+(void)saveGameWithSavedGames:(NSMutableArray *)savedGames;
+(void)saveGameWithSavedGames:(NSMutableArray *)savedGames deleting:(BOOL)deleting;
+(void)updateGamePlay:(NSTimeInterval)gamePlay;
-(void)changeTurn;
//-(void)checkJaque;
-(BOOL)isOnline;
-(BOOL)isBlueOnJaque;
-(BOOL)isWhiteOnJaque;
-(BOOL)isJaqueMate;
-(void)setKings;
-(NSDictionary *)toJSON;
-(void) setFromJSONString: (NSDictionary*) game withSize:(int)size;
-(void) updateView:(UIView*)view withSize:(int)size;
//-(void)playedTime;
-(void)checkGameState;
-(void)coronate: (Tile*) tile into:(int)pos;
-(void)resetCoronation;
-(void)setMatchId:(long)matchId;
-(long)getMatchId;
-(NSMutableArray * )saveTheKingWithRow:(int)row andColumn:(int)column;
-(BOOL)saveTheKingWithMove:(Position*)pFrom to:(Position*)pTo;
@end
