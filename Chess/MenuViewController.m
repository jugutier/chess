//
//  MenuViewController.m
//  Chess
//
//  Created by Jorge Lorenzon on 3/12/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "MenuViewController.h"
#import "LoadGameCell.h"
#import "GameViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"

#define STATIC_ROWS_NO (_connected?2:1)
@interface MenuViewController (){
    int matchId;
    int myColor;
}
@property (nonatomic) BOOL connected;
@property (nonatomic) BOOL waitingForOnline;
- (void) sendRequestForNewMatch;
@end


@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        _savedGames = [self loadGames];
//    }
//    return self;
//}
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _savedGames = [self loadGames];
        matchId = -1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppDelegate sharedInstance].socket.delegate = self;
    
    
    @try {
        [[AppDelegate sharedInstance].socket open];
    }
    @catch (NSException *exception) {
        //vale por una rosquilla
    };
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    _savedGames = [self loadGames];//actualizo los juegos guardados!!
    //NSLog(@"viewDidAppear %@",[self class]);
    [_gamesTable reloadData];
    if(!self.connected){
        [AppDelegate sharedInstance].socket.delegate = self;
        @try {
            [[AppDelegate sharedInstance].socket open];
        }
        @catch (NSException *exception) {
            //vale por una rosquilla
        };
    }
}
-(NSMutableArray *)loadGames{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"chessConfig.txt"];
    NSMutableArray *savedGame = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    return savedGame;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table delegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    if (row >= STATIC_ROWS_NO) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    [_savedGames removeObjectAtIndex:row-(STATIC_ROWS_NO)];//en memoria
    [Game saveGameWithSavedGames:_savedGames deleting:YES];//en disco
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    
    if (row >= STATIC_ROWS_NO) {
        return YES;
    } else {
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_savedGames count]+STATIC_ROWS_NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return [tableView dequeueReusableCellWithIdentifier:@"NEWGAME_CELL"];
    }else if(indexPath.row==1 && _connected){
        return [tableView dequeueReusableCellWithIdentifier:@"NEWONLINEGAME_CELL"];
    }else{
        LoadGameCell* cell =[tableView dequeueReusableCellWithIdentifier:@"LOADGAME_CELL"];
        if(cell) {
            
            Game * game =[_savedGames objectAtIndex:indexPath.row-STATIC_ROWS_NO];
            [cell loadFromGame:game];
        }
        return  cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==1 &&_connected){
        _waitingForOnline = YES;
        _spinnerView.hidden = NO;
        [self sendRequestForNewMatch];
        
    }
}
#pragma mark prepare for segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"GOTO_GAME"]){//goto saved game
        GameViewController* gvc= (GameViewController *)segue.destinationViewController;
        gvc.savedGames=_savedGames;
        //match id vale lo que tenia antes
        gvc.game = [Game getInstanceFromGame:((Game*)[_savedGames objectAtIndex:[_gamesTable indexPathForSelectedRow].row-STATIC_ROWS_NO ])];
        
    }else if([segue.identifier isEqualToString:@"NEWGAME_SEGUE"]){
        GameViewController * gvc = (GameViewController *)segue.destinationViewController;
        gvc.savedGames=_savedGames;
        gvc.game = [Game getNewInstance];
        gvc.game.playerColor = myColor;
        [gvc.game setMatchId: matchId];//matchId esta en -1 si es un nuevo juego y sino lo que me devolvio el server
        matchId = -1; // lo reseteo para el proximo juego
        if (_waitingForOnline){
            //le aviso al game que estamos en modo online
            [gvc.game.metadata setValue:[NSNumber numberWithBool:YES] forKey:@"ONLINE"];
            _waitingForOnline = NO;
        }else{
            SettingsViewController * svc =(SettingsViewController*)sender ;
            NSString * p1=[svc.player1TextField text];
            NSString * p2=[svc.player2TextField text];
            
            [gvc.game.metadata setValue:p1 forKey:@"player1"];
            [gvc.game.metadata setValue:p2 forKey:@"player2"];
        }
    } else if ([segue.identifier isEqualToString:@"GOTO_SETTINGS"]) {
        [(SettingsViewController*)segue.destinationViewController setMvc:self];
    }
}

#pragma mark socket rocket
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSError* error;
    NSDictionary* messageJSON = [NSJSONSerialization JSONObjectWithData:[(NSString*)message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    NSString* messageId = [messageJSON valueForKey:@"Command"];
    
    if ([messageId isEqualToString:@"Connected"]) {
        self.connected = YES;
        [self.gamesTable reloadData];
    } else if ([messageId isEqualToString:@"StartMatch"]) {
        _spinnerView.hidden = YES;
        matchId = [[messageJSON valueForKey:@"MatchId"]intValue];
        NSLog(@"online matchId = %d\n", matchId);
        NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        myColor = [[messageJSON valueForKey:udid]intValue];
        [self performSegueWithIdentifier:@"NEWGAME_SEGUE" sender:self];
        
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    SRWebSocket* socket = [AppDelegate sharedInstance].socket;
    
    NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    NSDictionary* connectDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Connect", @"Command", udid, @"Id", nil];
    
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:connectDict options:0 error:&error];
    
    [socket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    //NSLog(@"HUBO UN ERROR CON EL SOCKET \n %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"socket closed");
}

#pragma mark - Messages

- (void) sendRequestForNewMatch {
    SRWebSocket* socket = [AppDelegate sharedInstance].socket;
    
    NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    NSDictionary* getGameListDict =@{@"Command":@"FindMatch",
                                     @"Id":udid};
    
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:getGameListDict options:0 error:&error];
    
    [socket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}



@end
