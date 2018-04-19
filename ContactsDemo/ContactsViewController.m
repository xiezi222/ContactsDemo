//
//  ContactsViewController.m
//  ContactsDemo
//
//  Created by xing on 2018/4/18.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactCell.h"

static NSString *kContactCell = @"ContactCell";

@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource, CNContactViewControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem *addItem;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINib *cellNib;

@property (nonatomic, strong) NSMutableArray<CNContact *> *items;
@property (nonatomic, strong) NSMutableArray<CNContact *> *selectedItems;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigation];
    
    _cellNib = [UINib nibWithNibName:@"ContactCell" bundle:nil];
    [self.tableView registerNib:_cellNib forCellReuseIdentifier:kContactCell];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)initData
{
    NSArray *contacts = [[ContactsManager sharedManager] allSimpleContacts];
    _items = [NSMutableArray arrayWithArray:contacts];
    _selectedItems = [NSMutableArray array];
}

- (void)initNavigation
{
    _addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                             target:self
                                                             action:@selector(addItemClicked:)];
    self.navigationItem.leftBarButtonItem = _addItem;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - method

- (void)addItemClicked:(id)sender
{
    CNContact *contact = [[CNContact alloc] init];
    CNContactViewController *vc = [CNContactViewController viewControllerForNewContact:contact];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
    
    if (editing) {
        [_selectedItems removeAllObjects];
    } else {
        if (_selectedItems.count) {
            if ([[ContactsManager sharedManager] deleteContacts:_selectedItems]) {
                NSArray *contacts = [[ContactsManager sharedManager] allSimpleContacts];
                _items = [NSMutableArray arrayWithArray:contacts];
                [_tableView reloadData];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactCell];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    CNContact *contact = [self.items objectAtIndex:indexPath.row];
    [cell updateWithContact:contact];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CNContact *contact = [self.items objectAtIndex:indexPath.row];
    
    if (tableView.isEditing) {
        if ([_selectedItems containsObject:contact]) {
            [_selectedItems removeObject:contact];
        } else {
            [_selectedItems addObject:contact];
        }
    } else {
     
        CNContactViewController *vc = [CNContactViewController viewControllerForContact:contact];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - CNContactViewControllerDelegate

- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property
{
    return YES;
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    if (contact == nil) {
        [viewController.navigationController popViewControllerAnimated:YES];
    } else {
        
    }
}


@end
