//
//  MBProgressHUD+Extension.h
//  MBOC
//
//  Created by silence on 2017/6/15.
//  Copyright © 2017年 silence. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extension)

+ (void)showLoadingTo:(UIView *)view text:(NSString *)text;

+ (void)showMessage:(NSString *)text;
+ (void)showMessage:(NSString *)text location:(NSInteger)location;
+ (void)showMessage:(NSString *)text afterDelay:(NSTimeInterval)delay;
+ (void)showMessage:(NSString *)text location:(NSInteger)location afterDelay:(NSTimeInterval)delay;

+ (void)dismiss:(UIView *)view;

+ (void)showError:(NSString *)text;
+ (void)showSuccess:(NSString *)text;

extern const NSInteger MBProgressHUDMessageLocationCenter;
extern const NSInteger MBProgressHUDMessageLocationTop;
extern const NSInteger MBProgressHUDMessageLocationBottom;
@end
