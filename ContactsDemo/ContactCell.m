//
//  ContactCell.m
//  ContactsDemo
//
//  Created by xing on 2018/4/18.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithContact:(CNContact *)contact
{
    UIImage *image = [[UIImage alloc] initWithData:contact.thumbnailImageData];
    if (image == nil) {
        image = [UIImage imageNamed:@"avatar"];
    }
    
    self.imageView.image = image;
    self.textLabel.text = contact.givenName;
    
    CNLabeledValue *labelValue = [contact.phoneNumbers firstObject];
    CNPhoneNumber *number = labelValue.value;
    self.detailTextLabel.text = number.stringValue;
}

@end
