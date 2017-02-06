
//
//  Game.m
//  Chess
//
//  Created by nona on 20/03/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "Game.h"
#include <stdlib.h>
@interface Game(){
}
@end
@implementation Game
+(Game *) getNewInstance{
    return [Game getInstanceFromGame:nil new:YES];
}
+(Game *) getInstance{
    return [Game getInstanceFromGame:nil new:NO];
}
+(Game *) getInstanceFromGame:(Game*)game{
    return [Game getInstanceFromGame:game new:NO];
}
+(Game *) getInstanceFromGame:(Game*)game new:(BOOL)new{
    static  Game *inst = nil;
    @synchronized(self){
        if(game){
            inst = game;
        }else if (new||(!inst && !game)) {
            inst = [[self alloc] init];
        }
    }
    return inst;
}

+(void)saveGame{
    [Game saveGameWithSavedGames:nil];
    
}
+(void)saveGameWithSavedGames:(NSMutableArray *)savedGames{
    [Game saveGameWithSavedGames:savedGames deleting:NO];
}
+(void)saveGameWithSavedGames:(NSMutableArray *)savedGames deleting:(BOOL)deleting{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chessConfig.txt"];
    NSMutableArray * gameArray = nil;
    if(!deleting && [savedGames count]==0){
        gameArray = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
        if(!gameArray){
            gameArray = [NSMutableArray array];//para que no falle el add
        }
    }else{
        gameArray = savedGames;
    }
    if(!deleting){
        //remuevo el juego si existe el id
        Game * saveGame = nil;
        for (Game * game in gameArray) {
            NSLog(@"juego id = %ld",[game getMatchId]);
            if ([game getMatchId] == [[Game getInstance] getMatchId]) {
                
                saveGame = game;
                break;
            }
        }
        if(saveGame){
            NSLog(@"borramos el de id = %ld",[saveGame getMatchId]);
            [gameArray removeObject:saveGame];
        }
        //fin
        
        NSLog(@"agregamos el de id = %ld",[[Game getInstance] getMatchId]);
        [gameArray addObject:[Game getInstance]];
    }
    //[savedGames replaceObjectsInRange:NSMakeRange(0, [gameArray count])  withObjectsFromArray:gameArray];
    [NSKeyedArchiver archiveRootObject:gameArray toFile:appFile];
}
+(void)updateGamePlay:(NSTimeInterval)gamePlay{
    NSNumber *number=[NSNumber numberWithDouble:gamePlay];
    [[Game getInstance].metadata setObject:number forKey:@"timeplayed"];
}
- (id)init
{
    self = [super init];
    if (self) {
        _metadata = [NSMutableDictionary dictionary];
        _board = [[Board alloc]init];
        [self setKings];
        _turn = WHITE;
        _endGame = NO;
        _start = [[NSDate alloc]init];
        _coronation = -1;
        _whiteOnJaque = -1;
        _blueOnJaque = -1;
    }
    return self;
}
-(void)setMatchId:(long)matchId{
    NSNumber * num = [NSNumber numberWithLong:matchId];
    [_metadata setObject:num forKey:@"MATCH_ID"];
    
}
-(long)getMatchId{
    long mid=[[_metadata objectForKey:@"MATCH_ID"]longValue];
    if(mid==-1){
        mid = [self generateRandomMatchId];
        NSNumber * num = [NSNumber numberWithLong:mid];
        [_metadata setObject:num forKey:@"MATCH_ID"];
    }
    return mid;
}
-(long)generateRandomMatchId{
    return  arc4random() % LONG_MAX;
}
-(void)changeTurn{
    _turn++;
    [_board enemiesMovesForTurn:_turn];
    
}

-(void)setKings{
    [self setBlueKing:_board.blueKing];
    [self setWhiteKing:_board.whiteKing];
}

-(BOOL)isBlueOnJaque{
    return _blueOnJaque;
}
-(BOOL)isWhiteOnJaque{
    return _whiteOnJaque;
}
-(BOOL)isJaqueMate{
    return _endGame;
}
-(void)checkGameState{
    _blueOnJaque = [_board checkJaqueForKing:_blueKing];
    _whiteOnJaque = [_board checkJaqueForKing:_whiteKing];
    if(_blueOnJaque == 1){
        if(![_board getTheBulletForKing: WHITE]){
            _blueOnJaque = 0;
        }
    }
    if(_whiteOnJaque == 1){
        if(![_board getTheBulletForKing: BLACK]){
            _whiteOnJaque = 0;
        }
    }
    if(_blueOnJaque == 0 || _whiteOnJaque == 0){
        _endGame = YES;
    }else{
        _endGame = NO;
    }
    
    _coronation = [_board checkCoronation];
}
+(BOOL)isOnline{
    Game * game = [Game getInstance];
    if([game.metadata objectForKey:@"ONLINE"] != NULL && [game.metadata objectForKey:@"ONLINE"]){
        return YES;
    }
    return NO;
}
-(BOOL)isOnline{
    if([_metadata objectForKey:@"ONLINE"] != NULL && [_metadata objectForKey:@"ONLINE"]){
        return YES;
    }
    return NO;
}
-(NSDictionary *)toJSON{
    NSString *nodeKeyWord = @"Game";
    NSMutableDictionary* positionDict =[[NSMutableDictionary alloc]init];
    NSDictionary * board = [_board toJSON];
    [board setValue:[self getServerTurn] forKey:@"turn"];
    [positionDict setValue:board forKey:nodeKeyWord];
    //NSError* error = nil;
    //NSData* data = [NSJSONSerialization dataWithJSONObject:positionDict options:0 error:&error];
    //NSString * ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //return ret;
    return positionDict;
}
-(NSNumber *)getServerTurn{
    return [NSNumber numberWithInt:_turn];
}

-(void) setFromJSONString: (NSDictionary*) messageJSON withSize:(int)size{
    _turn = [[messageJSON valueForKey:@"turn"]intValue];
    [_board setFromJSONString: [messageJSON valueForKey: @"Game"] withSize: size];
    //_turn = [[game valueForKey:@"turn"]integerValue];
    //[_board setFromJSONString: [game valueForKey: @"array"]];
}

-(void) updateView: (UIView*) view withSize:(int) size{
    [_board updateView: view withSize:size];
}

//-(void)playedTime{
//    NSTimeInterval playedTime = [[[NSDate alloc]init] timeIntervalSinceDate:_start];
//    int minutes = floor(playedTime/60);
//    int seconds = round(playedTime - (minutes * 60));
//    
//}

-(void)coronate: (Tile*) tile into:(int)pos{
    [_board coronate: tile into: pos];
}

-(void)resetCoronation{
    _coronation = -1;
}

-(NSMutableArray * )saveTheKingWithRow:(int)row andColumn:(int)column{
    Position* pFrom = [[Position alloc]initWithX:row andY:column];
    NSMutableArray * moves = [_board getAvailablePositionsForRow:row andColumn:column];
    NSMutableArray * goodMoves = [[NSMutableArray alloc]init];
    for (int i = 0; i < [moves count]; i++) {
        Position* pTo = [moves objectAtIndex:i];
        if([self saveTheKingWithMove:pFrom to:pTo]){
            [goodMoves addObject:pTo];
        }
    }
    return goodMoves;
}

-(BOOL)saveTheKingWithMove:(Position*)pFrom to:(Position*)pTo{
    int king;
    if((_turn % 2) == WHITE){
        king = WHITE;
    }else{
        king = BLACK;
    }
    
    if([_board saveTheKing:king
                  withMove:pFrom to:pTo]){
        return YES;
    }
    return NO;
}

#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)encoder{
    [self.metadata setObject:[NSNumber numberWithInt:_turn] forKey:@"TURN"];
    [self.metadata setObject:[NSNumber numberWithBool:_endGame] forKey:@"ENDGAME"];
    [self.metadata setObject:[NSNumber numberWithInt:_blueOnJaque] forKey:@"BLUEONJAQUE"];
    [self.metadata setObject:[NSNumber numberWithInt:_whiteOnJaque] forKey:@"WHITEONJAQUE"];
    [self.metadata setObject:_blueKing forKey:@"BLUEKING"];
    [self.metadata setObject:_whiteKing forKey:@"WHITEKING"];
    [self.metadata setObject:[NSNumber numberWithInt:_playerColor] forKey:@"PLAYERCOLOR"];
    [self.metadata setObject:_start forKey:@"START"];
    [self.metadata setObject:[NSNumber numberWithInt:_coronation] forKey:@"CORONATION"];
    
    
    [encoder encodeObject:self.metadata forKey:@"metadata"];
    [encoder encodeObject:self.board forKey:@"board"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.metadata = [decoder decodeObjectForKey:@"metadata"];
        self.board = [decoder decodeObjectForKey:@"board"];
        
        self.turn = [[self.metadata objectForKey:@"TURN"]intValue];
        self.endGame =[[self.metadata objectForKey:@"ENDGAME"]boolValue];
        self.blueOnJaque = [[self.metadata objectForKey:@"BLUEONJAQUE"]intValue];
        self.whiteOnJaque =[[self.metadata objectForKey:@"WHITEONJAQUE"]intValue];
        self.blueKing = [self.metadata objectForKey:@"BLUEKING"];
        self.whiteKing = [self.metadata objectForKey:@"WHITEKING"];
        self.playerColor = [[self.metadata objectForKey:@"PLAYERCOLOR"]intValue];
        self.start = [self.metadata objectForKey:@"START"];
        self.coronation = [[self.metadata objectForKey:@"CORONATION"]intValue];
        
    }
    return self;
}
@end
