//
//  AlertManager.h
//  ContactsDemo
//
//  Created by xing on 2018/4/18.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertManager : NSObject

+ (AlertManager *)sharedManager;

- (void)showToast:(NSString *)toast;
- (void)showMessage:(NSString *)message;

@end
