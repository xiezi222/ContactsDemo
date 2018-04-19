//
//  AlertManager.m
//  ContactsDemo
//
//  Created by xing on 2018/4/18.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "AlertManager.h"

@interface AlertManager ()

@property (nonatomic, strong) UIAlertController *controller;

@end

@implementation AlertManager

+ (AlertManager *)sharedManager
{
    static AlertManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[AlertManager alloc] init];
    });
    return _manager;
}

- (BOOL)isShowed
{
    return self.controller && self.controller.presentingViewController && self.controller.preferredStyle == UIAlertControllerStyleAlert;
}

- (void)dismissToast:(NSInteger)delay
{
    NSLog(@"timeinterval:%td",delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self isShowed]) {
            NSLog(@"alert dismiss");
            [self.controller dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    });
}

- (void)showToast:(NSString *)toast
{
    self.controller = [UIAlertController alertControllerWithTitle:nil message:toast preferredStyle:UIAlertControllerStyleAlert];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.controller animated:YES completion:^{
        [self dismissToast:3];
    }];
}

- (void)showMessage:(NSString *)message
{
    self.controller = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.controller animated:YES completion:^{
    }];
}

@end
