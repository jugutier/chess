//
//  Pawn.h
//  Chess
//
//  Created by julian Gutierrez on 12/03/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Pawn : Tile

@property BOOL firstMove;
-(void)setMoved:(BOOL)moved;
@end
