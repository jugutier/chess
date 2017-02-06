//
//  GameViewController.m
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 3/12/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import "GameViewController.h"
#import "Position.h"
#import "Tile.h"
#import "Queen.h"
#import "Knight.h"
#import "Tower.h"
#import "Bishop.h"
#import "Board.h"
#import "MenuViewController.h"
#import "Settings.h"
#import <UIKit/UIKit.h>
#define SQUARE_SIZE (_boardView.frame.size.width / 8.0f)

@interface GameViewController (){
    BOOL firstPress;
    Position * lastMove;
    NSArray *availablePositions;
    NSMutableArray *blueCells;
    int row;
    int column;
    BOOL forfeited;
}
@end

@implementation GameViewController
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _game = [Game getInstance];
        firstPress = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[Settings alloc]init].autosaveOnBack){
        self.navigationItem.rightBarButtonItem = nil;
    }
    UIBarButtonItem * forfeit = [[UIBarButtonItem alloc]initWithTitle:@"Forfeit" style:UIBarButtonItemStylePlain target:self action:@selector(alertSurrender)];
    NSMutableArray * buttons = [[NSMutableArray alloc]initWithArray:self.navigationItem.rightBarButtonItems];
    [buttons addObject:forfeit];
    self.navigationItem.rightBarButtonItems = buttons;
    
    _boardState.text = [self turnText];
    if([_game isOnline]){
        //ignoring save button if online
        self.navigationItem.rightBarButtonItem = nil;        
    }
    
    firstPress = YES;
    float squareSize = SQUARE_SIZE;
    Board *board = _game.board;
    
    for(int i = 0; i < 64; i++) {
        int x = (i%8);
        int y = (i/8);
        UIImageView* img = [board getImgOnX:x andY:y withSize:squareSize];
        [_boardView addSubview:img];
    }
    [self configureClock];
    [((UILabel*)[self.view viewWithTag:11])setTextColor:[UIColor whiteColor]];
    [((UILabel*)[self.view viewWithTag:10])setTextColor:[UIColor blueColor]];
    [AppDelegate sharedInstance].socket.delegate = self;
}
-(NSString *)turnText{
    NSString * bw =(_game.turn!=-1?((_game.turn%2 == WHITE)?@"White":@"Blue"):@"White");
    if ([_game isOnline]) {
        return [NSString stringWithFormat:@"%@ turn:%@",((_game.playerColor == (_game.turn%2))?@"Your":@"His"),bw];
    }else{
        return [NSString stringWithFormat:@"%@'s turn:%@",[_game.metadata objectForKey:@"player1"],bw];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([[Settings alloc]init].autosaveOnBack && ! [_game isOnline]){
        [self onTouchDown:nil];
    }
    
}
-(void)toggleCoronation{
    
    UIButton *button1 = (UIButton *)[self.view viewWithTag:3];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:4];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:5];
    UIButton *button4 = (UIButton *)[self.view viewWithTag:6];
    
    
    NSArray* buttons = @[button1,button2,button3,button4];
    BOOL on = YES;
    for (UIButton *button in buttons) {
        if(!button.isHidden){
            on= NO;
            [button setHidden:YES];
        }else{
            _boardCheck.hidden = YES;
            on=YES;
            [button setHidden:NO];
        }
    }
    if(on){
        
        UIImage* img1 =[UIImage imageNamed:[NSString stringWithFormat:@"queen_%@",(((_game.turn%2) ==WHITE)?@"gold":@"blue")]];
        button1.frame = CGRectMake(button1.frame.origin.x,button1.frame.origin.y, img1.size.width, img1.size.height);
        [button1 setImage:img1 forState:UIControlStateNormal];
        
        UIImage* img2 =[UIImage imageNamed:[NSString stringWithFormat:@"bishop_%@",(((_game.turn%2) ==WHITE)?@"gold":@"blue")]];
        button2.frame = CGRectMake(button2.frame.origin.x,button2.frame.origin.y, img2.size.width, img2.size.height);
        [button2 setImage:img2 forState:UIControlStateNormal];
        
        UIImage* img3 =[UIImage imageNamed:[NSString stringWithFormat:@"knight_%@",(((_game.turn%2) ==WHITE)?@"gold":@"blue")]];
        button3.frame = CGRectMake(button3.frame.origin.x,button3.frame.origin.y, img3.size.width, img3.size.height);
        [button3 setImage:img3 forState:UIControlStateNormal];
        
        UIImage* img4 =[UIImage imageNamed:[NSString stringWithFormat:@"tower_%@",(((_game.turn%2) ==WHITE)?@"gold":@"blue")]];
        button4.frame = CGRectMake(button4.frame.origin.x,button4.frame.origin.y, img4.size.width, img4.size.height);
        [button4 setImage:img4 forState:UIControlStateNormal];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)addAvailablePositionsViews{
    for(Position* pos in availablePositions){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(pos.x*SQUARE_SIZE, pos.y*SQUARE_SIZE, 40, 40)];
        [view setBackgroundColor:[UIColor greenColor]];
        [view setAlpha:0.4];
        [blueCells addObject:view];
        [_boardView addSubview:view];
    }
}
-(void)removeAvailablePositionsViews{
    for(UIView* v in blueCells){
        [v removeFromSuperview];
    }
    
}
- (void) checkGameState{
    [_game checkGameState];
    if ([_game isWhiteOnJaque]) {
        if([_game isJaqueMate]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Checkmate"
                                  message:@"White player lost"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }else{
            _boardCheck.text = @"White is in check";
            [_boardCheck performSelector:@selector(setText:) withObject:@"" afterDelay:1];
        }
    }else if ([_game isBlueOnJaque]){
        if([_game isJaqueMate]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Checkmate"
                                  message:@"Blue player lost"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }else{
            _boardCheck.text = @"Blue is in check";
            [_boardCheck performSelector:@selector(setText:) withObject:@"" afterDelay:1];
        }
        
    }
    if(_game.coronation != -1){
        NSLog(@"CORONACION\n");
        [self toggleCoronation];
        _boardCheck.hidden = YES;
    }
}




-(void)alertSurrender{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Surrender"
                                                      message:@"Are you sure you wanna surrender?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Yes, I'm sure", nil];
    [message show];
    
    
}
-(void)alertWonSurrender{
    _game.endGame = YES;
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oponent surrenders"
                                                      message:@"You won!"
                                                     delegate:self
                                            cancelButtonTitle:@"Dismiss"
                                            otherButtonTitles: nil];
    [message show];
    
    
}
-(void)changeTurn{
    _boardCheck.hidden = NO;
    
    if((_game.turn % 2)==WHITE){
        _bClock.hidden=NO;
        _wClock.hidden=YES;
        if([_game isOnline]){
            _boardState.text =  [NSString stringWithFormat:@"%@ turn:%@",((_game.playerColor == (_game.turn%2))?@"His":@"Your"),@"Blue"];
        }else{
            _boardState.text = [NSString stringWithFormat:@"%@'s turn:%@",[_game.metadata objectForKey:@"player2"],@"Blue"];
        }
    }else{
        _bClock.hidden=YES;
        _wClock.hidden=NO;
        if([_game isOnline]){
            _boardState.text =  [NSString stringWithFormat:@"%@ turn:%@",((_game.playerColor == (_game.turn%2))?@"His":@"Your"),@"White"];
        }else{
            _boardState.text = [NSString stringWithFormat:@"%@'s turn:%@",[_game.metadata objectForKey:@"player1"],@"White"];
            
        }
    }
    [_game changeTurn];
}
#pragma mark AlertView - Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(_game.endGame){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if([_game isOnline]){
            [self sendForfeit];
            NSLog(@"You Lost online\n");
        }else{
            //self.navigationController.navigationBar.delegate = nil;
            NSLog(@"You Lost offline\n");
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark SocketRocket - delegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSError* error = nil;
    NSDictionary* messageJSON = [NSJSONSerialization JSONObjectWithData:[(NSString*)message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    NSString* messageId = [messageJSON valueForKey:@"Command"];
    
    if ([messageId isEqualToString:@"Moved"]) {
        //NSMutableDictionary * game = [messageJSON valueForKey: @"Game"];
        [_game setFromJSONString: messageJSON withSize: SQUARE_SIZE];
        [_game updateView: _boardView withSize:SQUARE_SIZE];
        _boardState.text =  [NSString stringWithFormat:@"%@ turn:%@",((_game.playerColor == (_game.turn%2))?@"Your":@"His"),(_game.turn!=-1?((_game.turn%2 == WHITE)?@"White":@"Blue"):@"White")];
        if(_game.turn%2 == _game.playerColor){
            [self checkGameState];
        }
    }else if([messageId isEqualToString:@"Forfeit"]){
        NSLog(@"You won\n");
        forfeited ?nil:[self alertWonSurrender];
        forfeited = NO;
    }
}

- (void) sendRequestForMoveFrom:(Position*)from To:(Position*)to {
    SRWebSocket* socket = [AppDelegate sharedInstance].socket;
    
    NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    NSMutableDictionary* getGameListDict =[[NSMutableDictionary alloc]init];
    [getGameListDict setValue:@"GameMessage" forKey:@"Command"];
    [getGameListDict setValue:@"Move" forKey:@"MessageType"];
    [getGameListDict addEntriesFromDictionary:[_game toJSON]];
    [getGameListDict setValue:udid forKey:@"Id"];
    NSLog(@"%ld\n", [_game getMatchId]);
    [getGameListDict setValue: [NSNumber numberWithLong: [_game getMatchId]] forKey:@"MatchId"];
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:getGameListDict options:0 error:&error];
    NSString * msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [socket send:msg];
}

-(void) sendForfeit{
    SRWebSocket* socket = [AppDelegate sharedInstance].socket;
    
    NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    NSMutableDictionary* forfeitDict =[[NSMutableDictionary alloc]init];
    [forfeitDict setValue:@"GameMessage" forKey:@"Command"];
    [forfeitDict setValue:@"Forfeit" forKey:@"MessageType"];
    [forfeitDict setValue:udid forKey:@"Id"];
    [forfeitDict setValue: [NSNumber numberWithLong: [_game getMatchId]] forKey:@"MatchId"];
    
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:forfeitDict options:0 error:&error];
    NSString * msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [socket send:msg];
    forfeited = YES;
}

#pragma mark UIEvents
//para guardar el juego
- (IBAction)onTouchDown:(id)sender{
    _boardCheck.text = @"Saving...";
    [_boardCheck performSelector:@selector(setText:) withObject:@"" afterDelay:1];
    [Game saveGameWithSavedGames:_savedGames];
}
- (IBAction)handleTap:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIView* boardView = sender.view;
        float squareSize = SQUARE_SIZE;
        CGPoint touchLocation = [sender locationInView:boardView];
        row = touchLocation.x / squareSize;
        column = touchLocation.y / squareSize;
        //NSLog(@"tocamos en %d %d", row, column);
        if((_game.coronation == -1)){
            if(firstPress){
                if(_lastmove){
                    [_boardView addSubview:_lastmove];
                    [_lastmove setFrame:CGRectMake(_pFrom.x*SQUARE_SIZE, _pFrom.y*SQUARE_SIZE, 40, 40)];
                    [_lastmove setAlpha:0.5];
                }
                blueCells = [[NSMutableArray alloc]init];
                if((![_game isOnline] && [_game.board getColorOnX:row andY:column] == (_game.turn % 2) )||
                   ((_game.playerColor == (_game.turn % 2)) && (_game.playerColor == [_game.board getColorOnX:row andY:column] ))){
                    
                    availablePositions = [_game saveTheKingWithRow:row andColumn:column];
                    lastMove = [[Position alloc]initWithX:row andY:column];
                    if([availablePositions count]==0){
                        if(_game.whiteOnJaque != -1|| _game.blueOnJaque!= -1){
                            _boardCheck.hidden = NO;
                            _boardCheck.text = @"Protect your king";
                            [_boardCheck performSelector:@selector(setText:) withObject:@"" afterDelay:1];
                        }else{
                            _boardCheck.hidden = NO;
                            _boardCheck.text = @"Can't move that piece";
                            [_boardCheck performSelector:@selector(setText:) withObject:@"" afterDelay:1];
                        }
                        firstPress = YES;
                    }else{
                        firstPress = NO;
                        [self addAvailablePositionsViews];
                    }
                }else{
                    
                }
                
            }else{
                firstPress = YES;
                [self removeAvailablePositionsViews];
                
                
                NSArray * destination = [availablePositions filteredArrayUsingPredicate:[NSPredicate
                                                                                         predicateWithFormat:(@"x == %d AND y == %d"),
                                                                                         row, column]];
                if([destination count]==1){
                    
                    [_lastmove removeFromSuperview];
                    Position* p = [[Position alloc]initWithX:row andY:column];
                    _pFrom = lastMove;
                    _pTo = p;
                    
                    
                    [[_game.board getImgOnX:row andY:column withSize:squareSize]removeFromSuperview];
                    UIImageView* img = [_game.board getImgOnX:lastMove.x andY:lastMove.y withSize:squareSize];
                    
                    
                    _lastmove = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[img accessibilityIdentifier]]];

                    
                    [_game.board  moveFromPostion:lastMove toPosition:p];
                    //animation
                    [UIView beginAnimations:nil context:NULL]; // animate the following:
                    [img setFrame:CGRectMake(p.x*SQUARE_SIZE, p.y*SQUARE_SIZE, 40, 40)]; // move to new location
                    [UIView setAnimationDuration:1.5];
                    [UIView commitAnimations];
                    
                    [self checkGameState];
                    if(_game.coronation == -1){
                        [self changeTurn];
                    }
                    if([_game isOnline]){
                        [self sendRequestForMoveFrom:lastMove To:[[Position alloc] initWithX:row andY:column]];
                    }
                }
            }
        }
    }
}

- (IBAction)coronate:(id)sender {
    NSInteger tag = ((UIButton*)sender).tag;
    [[_game.board getImgOnX:_game.coronation%8 andY:_game.coronation/\
      8 withSize:SQUARE_SIZE]removeFromSuperview];
    if(tag==3){
        Queen* piece = [[Queen alloc]initWith:[[Position alloc]initWithIndex:_game.coronation] andBoard:_game.board andColor:(_game.turn%2)];
        [_game coronate: piece into: _game.coronation];
    }else if(tag==4){
        Bishop* piece = [[Bishop alloc]initWith:[[Position alloc]initWithIndex:_game.coronation] andBoard:_game.board andColor:(_game.turn%2)];
        [_game coronate: piece into: _game.coronation];
    }else if(tag==5){
        Knight* piece = [[Knight alloc]initWith:[[Position alloc]initWithIndex:_game.coronation] andBoard:_game.board andColor:(_game.turn%2)];
        [_game coronate: piece into: _game.coronation];
    }else if(tag==6){
        Tower* piece = [[Tower alloc]initWith:[[Position alloc]initWithIndex:_game.coronation] andBoard:_game.board andColor:(_game.turn%2)];
        [_game coronate: piece into: _game.coronation];
    }
    [_boardView addSubview:[_game.board getImgOnX:_game.coronation%8 andY:_game.coronation/8 withSize:SQUARE_SIZE]];
    
    [self resetCoronation];
    [self checkGameState];
    [self changeTurn];
    if([_game isOnline]){
        [self sendRequestForMoveFrom:lastMove To:[[Position alloc] initWithX:row andY:column]];
    }
    [self toggleCoronation];
}

-(void)resetCoronation{
    [_game resetCoronation];
}

#pragma mark clock
-(void)configureClock{
    if(![_game isOnline]){
        if ((_game.turn%2==WHITE)) {
            _wClock.hidden=NO;
            _bClock.hidden=YES;
        }else{
            _bClock.hidden=NO;
            _wClock.hidden=YES;
        }
        _bSeconds = 0;
        _wSeconds = 0;
        _bClock.text = [NSString stringWithFormat:@"%d:%d", (_bSeconds/60)%60, _bSeconds%60];
        _wClock.text = [NSString stringWithFormat:@"%d:%d", (_wSeconds/60)%60, _wSeconds%60];

        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateTime:)
                                       userInfo:nil
                                        repeats:YES];
    }
    
}

-(void)updateTime:(id)sender
{
    if ((_game.turn%2==WHITE)) {
       _wSeconds++;
        
    }else{
        _bSeconds++;
    }
    _bClock.text = [NSString stringWithFormat:@"%d:%d", (_bSeconds/60)%60, _bSeconds%60];
    _wClock.text = [NSString stringWithFormat:@"%d:%d", (_wSeconds/60)%60, _wSeconds%60];
}
@end
