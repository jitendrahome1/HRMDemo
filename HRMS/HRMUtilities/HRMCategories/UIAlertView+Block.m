//
//  UIAlertView+Block.m
//  PmapMe
//
//  Created by Rupam Mitra on 17/06/15.
//  Copyright (c) 2014 Indusnet Technologies. All rights reserved.
//

#import <objc/runtime.h>
#import "UIAlertView+Block.h"

static char *PropertyKey;
@interface UIAlertView ()<UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation UIAlertView (Block)

+(instancetype)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray withCompletion:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))completion
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
    [otherButtonTitlesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [alertView addButtonWithTitle:obj];
    }];
    alertView.tapHandler = completion;
    alertView.delegate = alertView;
    [alertView show];
    return alertView;
}

+(instancetype)showWithTextFieldAndTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray withCompletion:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))completion
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
    
    
    [otherButtonTitlesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [alertView addButtonWithTitle:obj];
    }];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertView.tapHandler = completion;
    alertView.delegate = alertView;
    
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
   alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"Please enter pin";
    alertTextField.delegate = (id)self;
    [alertView show];
    return alertView;
    
    
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
}




//+(instancetype)showWithSimpleTextField:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray withCompletion:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))completion
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
//    [otherButtonTitlesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [alertView addButtonWithTitle:obj];
//    }];
//    alertView.tapHandler = completion;
//    alertView.delegate = alertView;
//    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
//    UITextField * alertTextField = [alertView textFieldAtIndex:0];
//      alertView.delegate = self;
//    alertTextField.placeholder = @"Please enter pin";
//    [alertView show];
//    return alertView;
//
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.tapHandler != nil) {
        self.tapHandler(alertView, buttonIndex);
        
    }
    
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    
    alertTextField.placeholder = @"Please enter pin";
    
}

-(void (^)(UIAlertView *alertView, NSInteger buttonIndex))tapHandler
{
    
    return objc_getAssociatedObject(self, &PropertyKey);
    
    
    
    
    
}

-(void)setTapHandler:(void (^)(UIAlertView *, NSInteger))tapHandler
{
    objc_setAssociatedObject(self, &PropertyKey, tapHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end