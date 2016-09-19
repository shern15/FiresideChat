//
//  GroupChatDetailsViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez on 9/14/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import <ContactsUI/ContactsUI.h>
#import "SFCGroupDetailsViewController.h"
#import "SFCTableViewAdapter.h"
#import "SFCArrayDataSource.h"
#import "SFCGroupDetailsCell.h"
#import "SFCContact.h"
#import "UIViewController+SHFillWithView.h"

@interface SFCGroupDetailsViewController ()

@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) SFCTableViewAdapter *tableViewAdapter;
@property (nonnull, nonatomic) CNContactStore *contactStore;


@end

@implementation SFCGroupDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupViewController];
	[self.tableViewAdapter refreshDataInView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:SFCAdapter Delegate

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_contactStore = [CNContactStore new];
	
	[self setupTableView];
	[self setupTableViewAdapter];
	
	[self setupNavigationBar];
	
	self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupTableView {
	[_tableView registerClass:SFCGroupDetailsCell.self forCellReuseIdentifier:kSFCGroupDetailsCellIdentifier];
	_tableView.tableFooterView = [UIView new];
	
	[self fillWithView:_tableView];
	_tableView.backgroundColor = [UIColor whiteColor];
}

- (void)setupNavigationBar {
	self.title = @"Details";
	
}

- (void)setupTableViewAdapter {
	SFCArrayDataSource *arrayDataSource = [[SFCArrayDataSource alloc] initWithObjectsArray:_participantsArray
																		andCelllIdentifier:kSFCGroupDetailsCellIdentifier];
	_tableViewAdapter = [[SFCTableViewAdapter alloc] initWithTableView:_tableView andDataSource:arrayDataSource];
	
	_tableViewAdapter.delegate = self;
}


//MARK: SFCAdapterDelegate
- (void)adapter:(id<SFCAdapter>)adapter accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
	NSError *fetchError;
	SFCContact *coreDataContact = object;
	CNContact *cnContact = [_contactStore unifiedContactWithIdentifier:coreDataContact.contactId
														   keysToFetch:@[[CNContactViewController descriptorForRequiredKeys]]
																 error:&fetchError];
	
	if (fetchError) {
		NSLog(@"\nDelegate failed to fetch CNContact:\n%@\n",fetchError.description);
		return;
	}
	
	CNContactViewController *contactViewController = [CNContactViewController viewControllerForContact:cnContact];
	contactViewController.hidesBottomBarWhenPushed = YES;
	[contactViewController setTitle:[NSString stringWithFormat:@"%@",coreDataContact.fullName]];
	[self.navigationController pushViewController:contactViewController animated:YES];
}

@end
