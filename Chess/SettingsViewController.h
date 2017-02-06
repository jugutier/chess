//
//  SettingsViewController.h
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 02/04/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessStyledViewController.h"
@class MenuViewController;

@interface SettingsViewController : ChessStyledViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *player1TextField;
@property (weak, nonatomic) IBOutlet UITextField *player2TextField;
@property (nonatomic, weak) MenuViewController* mvc;

- (IBAction)onTouchDown:(id)sender;

- (IBAction)onTouchBack:(id)sender;
//- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
