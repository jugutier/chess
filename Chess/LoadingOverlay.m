//
//  LoadingOverlay.m
//  Chess
//
//  Created by Developer on 5/31/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "LoadingOverlay.h"

@implementation LoadingOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) LoadingOverlay:  frame : base (frame)
{
    // configurable bits
    BackgroundColor = UIColor.Black;
    Alpha = 0.75f;
    AutoresizingMask = UIViewAutoresizing.FlexibleDimensions;
    
    float labelHeight = 22;
    float labelWidth = Frame.Width - 20;
    
    // derive the center x and y
    float centerX = Frame.Width / 2;
    float centerY = Frame.Height / 2;
    
    // create the activity spinner, center it horizontall and put it 5 points above center x
    activitySpinner = new UIActivityIndicatorView(UIActivityIndicatorViewStyle.WhiteLarge);
    activitySpinner.Frame = new RectangleF (
                                            centerX - (activitySpinner.Frame.Width / 2) ,
                                            centerY - activitySpinner.Frame.Height - 20 ,
                                            activitySpinner.Frame.Width ,
                                            activitySpinner.Frame.Height);
    activitySpinner.AutoresizingMask = UIViewAutoresizing.FlexibleMargins;
    AddSubview (activitySpinner);
    activitySpinner.StartAnimating ();
    
    // create and configure the "Loading Data" label
    loadingLabel = new UILabel(new RectangleF (
                                               centerX - (labelWidth / 2),
                                               centerY + 20 ,
                                               labelWidth ,
                                               labelHeight
                                               ));
    loadingLabel.BackgroundColor = UIColor.Clear;
    loadingLabel.TextColor = UIColor.White;
    loadingLabel.Text = "Loading Data...";
    loadingLabel.TextAlignment = UITextAlignment.Center;
    loadingLabel.AutoresizingMask = UIViewAutoresizing.FlexibleMargins;
    AddSubview (loadingLabel);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
