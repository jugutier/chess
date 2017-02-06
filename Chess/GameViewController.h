//
//  GameViewController.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 3/12/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketRocket/SRWebSocket.h>
#import "AppDelegate.h"
#import "Game.h"
#import "ChessStyledViewController.h"

@interface GameViewController : ChessStyledViewController<SRWebSocketDelegate, UIAlertViewDelegate,UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *boardView;
@property (weak, nonatomic) IBOutlet UILabel *boardState;
@property (weak, nonatomic) IBOutlet UILabel *boardCheck;
@property(weak,nonatomic) NSMutableArray * savedGames;
@property (nonatomic, weak) Game * game;
@property (nonatomic,strong)UIImageView* lastmove;
@property (nonatomic,strong)Position* pFrom;
@property (nonatomic,strong)Position* pTo;
@property (weak, nonatomic) IBOutlet UILabel *wClock;
@property (weak, nonatomic) IBOutlet UILabel *bClock;
@property (nonatomic) int bSeconds;
@property (nonatomic) int wSeconds;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (IBAction)coronate:(id)sender;
- (IBAction)handleTap:(UITapGestureRecognizer*)sender;
- (IBAction)onTouchDown:(id)sender;

- (void) checkGameState;
-(void)changeTurn;
-(void)resetCoronation;
@end
