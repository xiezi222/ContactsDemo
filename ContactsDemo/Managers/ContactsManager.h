//
//  ContactsManager.h
//  ContactsDemo
//
//  Created by xing on 2018/4/18.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsManager : NSObject

+ (ContactsManager *)sharedManager;
- (void)checkAuthorizationStatus;


/**
 cpntatct only content identifer、 name、 phonenumbers, thumbData
 */
- (NSArray<CNContact *> *)allSimpleContacts;
- (BOOL)deleteContacts:(NSArray *)contacts;


@end
