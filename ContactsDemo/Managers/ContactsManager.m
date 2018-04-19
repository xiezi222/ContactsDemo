//
//  ContactsManager.m
//  ContactsDemo
//
//  Created by xing on 2018/4/18.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "ContactsManager.h"

@interface ContactsManager ()

@property (nonatomic, strong) CNContactStore *contactStore;
@property (nonatomic, strong) NSMutableArray *simpleContacts;

@end

@implementation ContactsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contactStore = [[CNContactStore alloc] init];
        _simpleContacts = [NSMutableArray array];
    }
    return self;
}

+ (ContactsManager *)sharedManager
{
    static ContactsManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ContactsManager alloc] init];
    });
    return _manager;
}

- (void)checkAuthorizationStatus
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
            //存在权限
        case CNAuthorizationStatusAuthorized:
            //获取通讯录
            [self fetchAllSimpleContacts];
            break;
            
            //权限未知
        case CNAuthorizationStatusNotDetermined:
            //请求权限
            [self requestAuthorization];
            break;
            
            //如果没有权限
        case CNAuthorizationStatusRestricted:
        case CNAuthorizationStatusDenied://需要提示
            [[AlertManager sharedManager] showToast:@"没权限啊"];
            break;
    }
}

- (void)requestAuthorization
{
    [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [self fetchAllSimpleContacts];
        }
    }];
}

- (BOOL)fetchAllSimpleContacts
{
    NSArray *keys = @[CNContactIdentifierKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    NSError *error = nil;
    
    
    return [self.contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        if (contact) {
            [self.simpleContacts addObject:contact];
        }
    }];
}

- (NSArray<CNContact *> *)allSimpleContacts;
{
    return self.simpleContacts;
}

- (BOOL)deleteContacts:(NSArray *)contacts
{
    CNSaveRequest *request = [[CNSaveRequest alloc] init];
    
    for (CNContact *contact in contacts) {
        
        CNMutableContact *mutableContact = [contact mutableCopy];
        [request deleteContact:mutableContact];
    }
    NSError *error = nil;
    return [self.contactStore executeSaveRequest:request error:&error];
}

@end
