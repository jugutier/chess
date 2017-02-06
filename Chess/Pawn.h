//
//  Pawn.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 12/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Pawn : Tile

@property BOOL firstMove;
-(void)setMoved:(BOOL)moved;
@end
