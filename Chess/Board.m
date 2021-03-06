//
//  Board.m
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 12/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import "Board.h"
#import "Tower.h"
#import "Knight.h"
#import "Queen.h"
#import "King.h"
#import "Bishop.h"
#import "Pawn.h"

#define BOARD_X 8
#define BOARD_Y 8
@interface Board(){
    NSMutableArray * board;
    NSMutableArray * enemiesMoves;
    NSMutableArray * partnersMoves;
}
@end
@implementation Board

- (id)init
{
    self = [super init];
    if (self) {
        board = [self createBoard];
        [self enemiesMovesForTurn:WHITE];
    }
    return self;
}

-(id)initWithBoard:(NSMutableArray *)oldBoard andEnemiesMoves:(NSMutableArray*) enemies{
    self = [super init];
    if(self){
        board = [[NSMutableArray alloc] init];
        //TODO MODIFICAR ENEMIESMOVES
        for (Tile* t in oldBoard) {
            if([t isKindOfClass:[King class]]){
                if(t.color == WHITE){
                    _whiteKing =[[King alloc]initWith:t.position andBoard:self andColor:WHITE];
                    [board addObject:_whiteKing];
                }else{
                    _blueKing = [[King alloc]initWith:t.position andBoard:self andColor:BLACK];
                    [board addObject:_blueKing];
                }
            }else if([t isKindOfClass:[Queen class]]){
                if(t.color == WHITE){
                    [board addObject:[[Queen alloc]initWith:t.position andBoard:self andColor:WHITE]];
                }else{
                    [board addObject:[[Queen alloc]initWith:t.position andBoard:self andColor:BLACK]];
                }
            }else if([t isKindOfClass:[Knight class]]){
                if(t.color == WHITE){
                    [board addObject:[[Knight alloc]initWith:t.position andBoard:self andColor:WHITE]];
                }else{
                    [board addObject:[[Knight alloc]initWith:t.position andBoard:self andColor:BLACK]];
                }
            }else if([t isKindOfClass:[Bishop class]]){
                if(t.color == WHITE){
                    [board addObject:[[Bishop alloc]initWith:t.position andBoard:self andColor:WHITE]];
                }else{
                    [board addObject:[[Bishop alloc]initWith:t.position andBoard:self andColor:BLACK]];
                }
            }else if([t isKindOfClass:[Pawn class]]){
                if(t.color == WHITE){
                    Pawn* pawn = [[Pawn alloc]initWith:t.position andBoard:self andColor:WHITE];
                    [pawn setMoved:((Pawn*)t).firstMove];
                    [board addObject:pawn];
                }else{
                    Pawn* pawn = [[Pawn alloc]initWith:t.position andBoard:self andColor:BLACK];
                    [pawn setMoved:((Pawn*)t).firstMove];
                    [board addObject:pawn];
                }
            }else if([t isKindOfClass:[Tower class]]){
                if(t.color == WHITE){
                    [board addObject:[[Tower alloc]initWith:t.position andBoard:self andColor:WHITE]];
                }else{
                    [board addObject:[[Tower alloc]initWith:t.position andBoard:self andColor:BLACK]];
                }
            }else{
                [board addObject:[[Tile alloc]initWith:t.position andBoard:self andColor:BLANK]];
            }
        }
    }
    return self;
}

-(NSMutableArray * )createBoard{
   NSMutableArray* ret = [[NSMutableArray alloc] init];
    //agrego fichas negras
    [ret addObject:[[Tower alloc]initWith: [[Position alloc]initWithX:0 andY:0] andBoard:self andColor: BLACK] ];
    [ret addObject:[[Knight alloc]initWith: [[Position alloc]initWithX:1 andY:0] andBoard:self andColor: BLACK] ];
    [ret addObject:[[Bishop alloc]initWith: [[Position alloc]initWithX:2 andY:0] andBoard:self andColor: BLACK] ];
    [ret addObject:[[King alloc]initWith: [[Position alloc]initWithX:3 andY:0] andBoard:self andColor: BLACK] ];
    [ret addObject:[[Queen alloc]initWith: [[Position alloc]initWithX:4 andY:0] andBoard:self andColor: BLACK] ];
    [ret addObject:[[Bishop alloc]initWith: [[Position alloc]initWithX:5 andY:0] andBoard:self andColor: BLACK] ];
    [ret addObject:[[Knight alloc]initWith: [[Position alloc]initWithX:6 andY:0] andBoard:self andColor: BLACK] ];
    [ret addObject:[[Tower alloc]initWith: [[Position alloc]initWithX:7 andY:0] andBoard:self andColor: BLACK] ];
    _blueKing = [ret objectAtIndex:[self indexForRow:3 column:0]];
    for (int i=8; i<16 ; i++) {
        [ret addObject:[[Pawn alloc]initWith: [[Position alloc]initWithX:i%8 andY:i/8] andBoard:self andColor: BLACK] ];
    }
    for (int k=16; k<48 ; k++) {
        [ret addObject:[[Tile alloc]initWith: [[Position alloc]initWithX:k%8 andY:k/8] andBoard:self andColor: BLANK] ];
    }
    //agrego fichas blancas
    for (int j=48; j<56 ; j++) {
        [ret addObject:[[Pawn alloc]initWith: [[Position alloc]initWithX:j%8 andY:j/8] andBoard:self andColor: WHITE] ];
    }
    [ret addObject:[[Tower alloc]initWith: [[Position alloc]initWithX:0 andY:7] andBoard:self andColor: WHITE] ];
    [ret addObject:[[Knight alloc]initWith: [[Position alloc]initWithX:1 andY:7] andBoard:self andColor: WHITE] ];
    [ret addObject:[[Bishop alloc]initWith: [[Position alloc]initWithX:2 andY:7] andBoard:self andColor: WHITE] ];
    [ret addObject:[[King alloc]initWith: [[Position alloc]initWithX:3 andY:7] andBoard:self andColor: WHITE] ];
    [ret addObject:[[Queen alloc]initWith: [[Position alloc]initWithX:4 andY:7] andBoard:self andColor: WHITE] ];
    [ret addObject:[[Bishop alloc]initWith: [[Position alloc]initWithX:5 andY:7] andBoard:self andColor: WHITE] ];
    [ret addObject:[[Knight alloc]initWith: [[Position alloc]initWithX:6 andY:7] andBoard:self andColor: WHITE] ];
    [ret addObject:[[Tower alloc]initWith: [[Position alloc]initWithX:7 andY:7] andBoard:self andColor: WHITE] ];
    _whiteKing = [ret objectAtIndex:[self indexForRow:3 column:7]];
    return ret;
}

-(BOOL)isEmpty:(Position *)pos{
    return [[board objectAtIndex:[self indexForRow:pos.x column:pos.y]] isEmpty];
}

-(int)indexForRow:(int)row column:(int)column{
    return (column * 8)+row;
}

-(NSMutableArray *)getAvailablePositionsForRow:(int)row andColumn:(int)column{
    int index= [self indexForRow:row column:column];
    return [[board objectAtIndex:index] getAvailablePositions];
}

-(BOOL)moveFromPostion:(Position *)lastPosition toPosition:(Position *)destination{
    int index= [self indexForRow:lastPosition.x column:lastPosition.y];
    int index2= [self indexForRow:destination.x column:destination.y];
    bool moved = [[board objectAtIndex:index]moveToPosition:destination];
    bool vs = [self checkIfEnemiesFor:lastPosition And:destination];
    int turn = [[board objectAtIndex:index]getColor];
    if(vs){
        [self killTile:destination];
    }
    [board exchangeObjectAtIndex:index withObjectAtIndex:index2];
    [self enemiesMovesForTurn:turn];
    return moved;
}

-(void)killTile:(Position*)pos{
    [board replaceObjectAtIndex:[self indexForRow:pos.x column:pos.y] withObject:[[Tile alloc]initWith:pos andBoard:self andColor:BLANK]];
    
}

-(void)setImages{
    for(int i = 0; i<[board count]; i++){
        [[board objectAtIndex:i]getImg];
    }
    
}

-(UIImageView*)getImgOnX:(int)x andY:(int)y withSize:(int)size{
    int index= [self indexForRow:x column:y];
    return [[board objectAtIndex:index]getImgSized:size];
}

-(NSMutableArray *) enemiesForColor:(int)color{
    NSMutableArray* enemies = [[NSMutableArray alloc]init];
    for (int i = 0; i<64; i++) {
        if([[board objectAtIndex:i]getColor] != color){
            [enemies addObject: [board objectAtIndex:i]];
        }
    }
    return enemies;
}

-(int)checkJaqueForKing:(King*)king{
    int jaque = -1;
    NSMutableArray * kingMovs = [self getAvailablePositionsForRow:[king getPosition].x  andColumn: [king getPosition].y];
    
    [self enemiesMovesForTurn:king.getColor];
    
    NSArray * destination = [enemiesMoves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:(@"x == %d AND y == %d"),
                                                                    [king getPosition].x, [king getPosition].y]];
    if([destination count] != 0){
        jaque = 1;
    }
    for(Position * p in enemiesMoves){
        [kingMovs removeObject:p];
    }
    return jaque;
}

-(BOOL)getTheBulletForKing:(int)turn{
    NSMutableArray * buddies = [self enemiesForColor:turn];
    BOOL flag = NO;
    for (int i = 0; i < [buddies count] && !flag; i++) {
        NSMutableArray * moves = [[buddies objectAtIndex:i]getAvailablePositions];
        for(int j = 0; j  < [moves count] && !flag; j++){
            if([self saveTheKing:(turn==WHITE)?BLACK:WHITE withMove: [[buddies objectAtIndex:i]getPosition] to:[moves objectAtIndex:j]]){
                flag = YES;
            }
        }
    }
    return flag;
}

-(void)enemiesMovesForTurn:(int)turn{
    NSMutableArray * enemies = [self enemiesForColor:turn];
    enemiesMoves = [self enemiesMoves:enemies];
}

-(NSMutableArray*)enemiesMoves:(NSMutableArray*)enemies{
    NSMutableArray * enemiesMovs = [[NSMutableArray alloc]init];
    //int arrCount = [enemies count];
    for(Tile* t in enemies){
        NSArray * arr =[t getAvailablePositions];
        [enemiesMovs addObjectsFromArray:arr];
    }
    return enemiesMovs;
}

-(int)getColorOnX:(int)x andY:(int)y{
    return [[board objectAtIndex:[self indexForRow:x column:y
                                  ]]getColor];
}

-(bool)checkIfEnemiesFor:(Position*)attack And:(Position*)defense{
    return ([[board objectAtIndex:[self indexForRow:attack.x column:attack.y]]getColor] == WHITE && [[board objectAtIndex:[self indexForRow:defense.x column:defense.y]]getColor] != WHITE)
            || ([[board objectAtIndex:[self indexForRow:attack.x column:attack.y]]getColor] == BLACK && [[board objectAtIndex:[self indexForRow:defense.x column:defense.y]]getColor] != BLACK);
}

-(BOOL)saveTheKing:(int)color withMove:(Position*)pFrom to:(Position*)pTo{
    Board * newBoard = [self copy];
    King* king = (color==WHITE)?newBoard.whiteKing:newBoard.blueKing;
    [newBoard moveFromPostion:pFrom toPosition:pTo];
    int check = [newBoard checkJaqueForKing:king];
    if(check == -1){
        return YES;
    }
    return NO;
}


-(NSDictionary *)toJSON{
    NSString *nodeKeyWord = @"array";
    NSMutableDictionary* positionDict =[[NSMutableDictionary alloc]init];
    [positionDict setValue:[self boardToJSON] forKey:nodeKeyWord];
    //NSError* error = nil;
    //NSData* data = [NSJSONSerialization dataWithJSONObject:positionDict options:0 error:&error];
    //NSString * ret =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //return ret;
    return positionDict;
}
-(NSArray*)boardToJSON{
    NSMutableArray * arr = [[NSMutableArray alloc]init];    
    for (Tile * t in board) {
        NSMutableDictionary * entry = [[NSMutableDictionary alloc]init];
        NSNumber * serverType =[t getServerType];
        if(serverType){ //era si es null
            [entry setValue:serverType forKey:@"type"];
            [entry setValue:[t getServerColor] forKey:@"white"];
            [arr addObject:entry];
        }else{
            [arr addObject:[NSNull null]];
            //[entry setValue:[NSNull null] forKey:@"type"];
            //[entry setValue:[NSNull null] forKey:@"white"];
        }
        
    }
    return arr;
}
-(Tile *) getTileFromServerType:(NSNumber *) type withPosition:(Position *) pos andColor:(NSNumber *)nColor{
    if(!type || [type isEqual:[NSNull null]] || [type isKindOfClass:[NSNull class]]){
        return [[Tile alloc]initWith:pos andBoard:self andColor:BLANK];
    }
    int typeInt = [type intValue];
    int color = [nColor intValue];
    switch (typeInt) {
        case 0:
        {
            Pawn * pawn = [[Pawn alloc]initWith:pos andBoard:self andColor: color];
            if (!(pos.y == 6 || pos.y == 1)) {
                pawn.firstMove = NO;
            }
            return pawn;
        }
            break;
        case 1:
            return [[Knight alloc]initWith: pos andBoard:self andColor:color];
            break;
        case 2:
            return [[Bishop alloc]initWith:pos andBoard:self andColor:color];
            break;
        case 3:
            return [[Tower alloc]initWith:pos andBoard:self andColor:color];
            break;
        case 4:
            return [[Queen alloc]initWith:pos andBoard:self andColor:color];
            break;
        case 5:
            return [[King alloc]initWith:pos andBoard:self andColor:color];
            break;
        default:
            break;
    }
    NSLog(@"Esto nunca deberia pasar");
    return nil;
}
-(void) setFromJSONString:(NSArray *) array withSize:(int) size{
    NSMutableArray * newBoard = [[NSMutableArray alloc]init];
    for(int i = 0; i < [array count]; i++){
        NSDictionary* node = [array objectAtIndex:i];
        NSNumber * type = [node valueForKey:@"type"];
        Position * p = [[Position alloc]initWithIndex:i];
        NSNumber *  color = [node valueForKey: @"white"];
        
        Tile * t = [self getTileFromServerType:type withPosition:p andColor:color];
        
        [newBoard addObject:t];
        
        Tile * old = [board objectAtIndex:i];
        [old.img removeFromSuperview];
    }
    board = newBoard;
}
-(void) updateView: (UIView*) view withSize:(int)size{
    for (int i = 0 ; i < [board count]; i++) {
        Position *p = [[Position alloc]initWithIndex:i];
        [view addSubview:[self getImgOnX:p.x andY:p.y withSize:size]];
    }
}

-(int)checkCoronation{
    for(int i = 0; i < 8; i ++){
        if([[board objectAtIndex:i]isCoronated]){
            return i;
        };
    }
    for(int i = 56; i < 64; i ++){
        if([[board objectAtIndex:i]isCoronated]){
            return i;
        };
    }
    return -1;
}



-(void)coronate:(Tile*) tile into:(int)pos{
    [board replaceObjectAtIndex:pos withObject:tile];
}
#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_blueKing forKey:@"board_BLUEKING"];
    [encoder encodeObject:_whiteKing forKey:@"board_WHITEKING"];
    [encoder encodeObject:board forKey:@"board"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        board = [decoder decodeObjectForKey:@"board"];
        _blueKing = [decoder decodeObjectForKey:@"board_BLUEKING"];
        _whiteKing = [decoder decodeObjectForKey:@"board_WHITEKING"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone{
    id newBoard = [[[self class]allocWithZone:zone]initWithBoard:board andEnemiesMoves:enemiesMoves];
    return newBoard;
}


@end
