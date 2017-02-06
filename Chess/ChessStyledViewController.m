//
//  ChessStyledViewController.m
//  Chess
//
//  Created by Julian Gutierrez Ferrara on 25/05/13.
//  Copyright (c) 2013 Julian Gutierrez Ferrara & Facundo Menzella. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "ChessStyledViewController.h"
#import "Settings.h"
@interface ChessStyledViewController ()

@end

@implementation ChessStyledViewController
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    UIImage *img =[UIImage imageNamed:@"menubar"];
    CGSize size = [self navigationController].navigationBar.frame.size;
    UIImage * imgResized = [self imageWithImage:img scaledToSize:size];
    
    [[self navigationController].navigationBar  setBackgroundImage:imgResized forBarMetrics:UIBarMetricsDefault];
    //[self setFonts];
    [self changeLabelFonts];
}
-(void) changeLabelFonts{
    for (UIView *view in self.view.subviews) {
        if([view respondsToSelector:@selector(setFont:)]){
            [view performSelector:@selector(setFont:) withObject:[Settings appfontMain]];
            if([view isKindOfClass:[UILabel class] ] &&[view respondsToSelector:@selector(setTextColor:)]){
                [view performSelector:@selector(setTextColor:) withObject:[UIColor yellowColor]];
            }
        }
//        if ([view isKindOfClass:[UILabel class]]||[view isKindOfClass:[UITextView class]]) {
//            UILabel* lb = (UILabel*) view;
//            [lb setFont:[Settings appfontMain]];
//        }
    }
    
}
//for the UITextView or UILabel variables (IBOutlets)
-(void)setFonts{
    @autoreleasepool {
        unsigned int numberOfProperties = 0;
        objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
        
        for (NSUInteger i = 0; i < numberOfProperties; i++)
        {
            objc_property_t property = propertyArray[i];
            
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
            BOOL fontEditable = [self isFontEditable:attributesString];
        #ifdef DEBUG
            NSLog(@"Property %@ fontEditable: %s", name,fontEditable? "true" : "false");
        #endif
            if(fontEditable){
                id editable = [self valueForKey:name];
                [editable performSelector:@selector(setFont:) withObject:[Settings appfontMain]];
                //[self setValue:[Settings appfontMain] forKey:name/*[NSString stringWithFormat:@"_%@.font",name]*/];
            }
        }
        free(propertyArray);
    }
}
-(BOOL)isFontEditable:(NSString *)attributesString{
    NSArray * fontEditableClasses = @[@"UITextView",@"UILabel"];
    return [self myAttribute:attributesString isKindOfClass:fontEditableClasses];
}
- (BOOL) myAttribute:(NSString*)attributesString isKindOfClass: (NSArray*) classesStrings
{
    for(NSString * class in classesStrings){
        NSRange range = [attributesString rangeOfString : class];
        BOOL found = ( range.location != NSNotFound );
        if(found){
            return found;
        }
    }
    return NO;
}
@end
