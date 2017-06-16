//
//  MBProgressHUD+Extension.m
//  MBOC
//
//  Created by silence on 2017/6/15.
//  Copyright © 2017年 silence. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

/// this code.
/// background view color is black
/// content Color is white

const NSInteger MBProgressHUDMessageLocationCenter = 0;
const NSInteger MBProgressHUDMessageLocationTop = -1000000;
const NSInteger MBProgressHUDMessageLocationBottom = 1000000;

@implementation MBProgressHUD (Extension)

/**
 Show Loading and Text

 @param view : is `nil` return `window`
 @param text : is `nil` -> only show loading
 */
+ (void)showLoadingTo:(UIView *)view text:(NSString *)text {
    [self showText:text icon:nil toView:view];
}

#pragma mark - message
/**
 * Shows only text.
 * Location. Defaults to Center.
 * Delay. Defaults to 3.
 */
+ (void)showMessage:(NSString *)text {
    [self showMessage:text location:MBProgressHUDMessageLocationCenter afterDelay:3];
}

+ (void)showMessage:(NSString *)text location:(NSInteger)location {
    [self showMessage:text location:location afterDelay:3];
}

+ (void)showMessage:(NSString *)text afterDelay:(NSTimeInterval)delay {
    [self showMessage:text location:MBProgressHUDMessageLocationCenter afterDelay:delay];
}

+ (void)showMessage:(NSString *)text location:(NSInteger)location afterDelay:(NSTimeInterval)delay {
    UIView *showView = [self currentlyWithShow:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.offset = CGPointMake(0, location);
    hud.bezelView.backgroundColor = [self rgbaColorFromHex:0x000000 alpha:0.8];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:delay];
    });
}

/**
 Success
 
 @param text : text is `nil` -> show `image`
 */
+ (void)showSuccess:(NSString *)text {
    UIView *showView = [self currentlyWithShow:nil];
    [self showText:text icon:@"Checkmark" toView:showView];
}

/**
 Error
 
 @param text : text is `nil` -> show `image`
 */
+ (void)showError:(NSString *)text {
    UIView *showView = [self currentlyWithShow:nil];
    [self showText:text icon:@"Error" toView:showView];
}

/**
 Dismiss
 
 @param view : is `nil` -> window
 */
+ (void)dismiss:(UIView *)view {
    UIView *showView = [self currentlyWithShow:view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:showView animated:YES];
    });
}

+ (void)showText:(NSString *)text icon:(NSString *)icon toView:(UIView *)view {
    UIView *showView = [self currentlyWithShow:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.bezelView.backgroundColor = [self rgbaColorFromHex:0x000000 alpha:0.8];
    hud.contentColor = [UIColor whiteColor];
    if (icon && icon.length > 0) {
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@",icon]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.square = YES;
        hud.removeFromSuperViewOnHide = NO;
    }
    
    if (text) {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:3];
    });
}

+ (UIView *)currentlyWithShow:(UIView *)view {
    if (!view) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windowArray = [UIApplication sharedApplication].windows;
            for (UIWindow *tempWin in windowArray) {
                if (tempWin.windowLevel == UIWindowLevelNormal) {
                    window = tempWin;
                    break;
                }
            }
        }
        return window;
    }
    return view;
}

+ (UIColor *)rgbaColorFromHex:(NSInteger)rgb alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0 green:((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0 blue:((CGFloat)(rgb & 0xFF)) / 255.0 alpha:alpha];
}
@end
