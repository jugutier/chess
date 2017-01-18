//
//  SettingsViewController.m
//  Chess
//
//  Created by julian Gutierrez on 02/04/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "SettingsViewController.h"
#import "MenuViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.player1TextField.returnKeyType = UIReturnKeyDone;
    self.player2TextField.returnKeyType = UIReturnKeyDone;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onTouchDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mvc performSegueWithIdentifier:@"NEWGAME_SEGUE" sender:self];
    }];
}

-(IBAction)onTouchBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
    return YES;
}
@end
