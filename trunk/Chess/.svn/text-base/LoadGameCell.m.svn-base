//
//  LoadGameCell.m
//  Chess
//
//  Created by julian Gutierrez on 19/03/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "LoadGameCell.h"

@implementation LoadGameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)loadFromGame:(Game*)game{
    NSDictionary * metadata = game.metadata;
    NSString * timePlayed = [metadata objectForKey:@"timeplayed"];
    [_timePlayed setText:timePlayed];
    NSString * player1 = [metadata objectForKey:@"player1"];
    [_player1 setText:player1];
    NSString * player2 = [metadata objectForKey:@"player2"];
    [_player2 setText:player2];
}

@end
