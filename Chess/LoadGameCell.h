//
//  LoadGameCell.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 19/03/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
@interface LoadGameCell : UITableViewCell
@property(nonatomic,retain) IBOutlet UILabel * timePlayed;
@property(nonatomic,retain) IBOutlet UILabel * player1;
@property(nonatomic,retain) IBOutlet UILabel * player2;

-(void)loadFromGame:(Game *)game;
@end
