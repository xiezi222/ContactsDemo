//
//  ContactCell.h
//  ContactsDemo
//
//  Created by xing on 2018/4/18.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

- (void)updateWithContact:(CNContact *)contact;

@end
