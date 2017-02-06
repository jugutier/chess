//
//  MenuViewController.h
//  Chess
//
//  Created by Jorge Lorenzon on 3/12/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketRocket/SRWebSocket.h>
#import "ChessStyledViewController.h"
@interface MenuViewController : ChessStyledViewController<UITableViewDelegate ,UITableViewDataSource, SRWebSocketDelegate>
@property(nonatomic,retain) IBOutlet UITableView * gamesTable;
@property (weak, nonatomic) IBOutlet UIView *spinnerView;
@property(nonatomic,retain) NSMutableArray * savedGames;
@end
