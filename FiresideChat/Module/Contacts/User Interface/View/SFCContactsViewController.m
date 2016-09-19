//
//  SFCContactsViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import CoreData;
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "SFCContactsSearchResultsViewController.h"
#import "SFCContactsViewController.h"
#import "SFCArrayDataSource.h"
#import "SFCContactsTableViewAdapter.h"
#import "SFCFetchedResultsControllerDataSource.h"
#import "SFCContact.h"
#import "SFCContactCell.h"
#import "UIViewController+SHFillWithView.h"

@interface SFCContactsViewController ()<CNContactViewControllerDelegate>
{
	NSManagedObjectContext *_context;
	UIBarButtonItem *_signOutBarButtonItem;
}

@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) SFCContactsTableViewAdapter *tableViewAdapter;
@property (nullable, nonatomic) UISearchController *searchController;

@end

@implementation SFCContactsViewController
@synthesize context = _context;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupViewController];
	[_tableViewAdapter refreshDataInViewWithPredicate:nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Dispose of any resources that can be recreated.
}

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	
	[self setupTableView];
	[self setupTableViewAdapter];
	
	SFCContactsSearchResultsViewController *searchResultsViewController = [self
																		   contactsSearchResultsViewControllerFromDataArray:
																		   [_tableViewAdapter.dataSource fetchedObjects]];

	searchResultsViewController.delegate = self;
	_searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsViewController];
	_searchController.searchResultsUpdater = searchResultsViewController;
	_tableView.tableHeaderView = _searchController.searchBar;
	
	
	[self setupNavigationBar];
	self.definesPresentationContext = YES;
	self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupNavigationBar {
	self.navigationController.navigationBar.topItem.title = @"All Contacts";
	self.navigationItem.leftBarButtonItem = _signOutBarButtonItem ? _signOutBarButtonItem : nil;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithImage:[UIImage imageNamed:@"add"]
											  style:UIBarButtonItemStylePlain
											  target:self action:@selector(addNewContactButtonHandler:)];
}

- (void)setupTableView {
	[_tableView registerClass:SFCContactCell.self forCellReuseIdentifier:kSFCContactCellIdentifier];
	_tableView.tableFooterView = [UIView new];
	
	[self fillWithView:_tableView];
}

- (void)setupTableViewAdapter {
	SFCFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [self fetchedResultsControllerDataSource];
	//Prepopulate data source so we have data to show at start.
	[fetchedResultsControllerDataSource refreshDataInSource];
	_tableViewAdapter = [[SFCContactsTableViewAdapter alloc] initWithTableView:_tableView andDataSource:fetchedResultsControllerDataSource];

	_tableViewAdapter.delegate = self;
}

- (void)addNewContactButtonHandler:(UIBarButtonItem *)sender {
	CNContactViewController *viewController = [CNContactViewController viewControllerForNewContact:nil];
	
	viewController.delegate = self;
	[self.navigationController pushViewController:viewController animated:YES];
}

- (SFCFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
	//MARK: Build FetchedResultsController
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCContactEntityName];
	NSSortDescriptor *firstNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	NSSortDescriptor *lastNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	
	fetchRequest.sortDescriptors = @[firstNameSortDescriptor, lastNameSortDescriptor];
	
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																							   managedObjectContext:_context
																								 sectionNameKeyPath:@"sortLetter" cacheName:nil];
	SFCFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[SFCFetchedResultsControllerDataSource alloc]
																				 initWithFetchedResultsController:fetchedResultsController
																				 andCelllIdentifier:kSFCContactCellIdentifier];
	return fetchedResultsControllerDataSource;
}


- (SFCContactsSearchResultsViewController *)contactsSearchResultsViewControllerFromDataArray:(NSArray *)dataArray {
	SFCArrayDataSource *arrayDataSource = [[SFCArrayDataSource alloc] initWithObjectsArray:dataArray andCelllIdentifier:kSFCContactCellIdentifier];
	
	SFCContactsSearchResultsViewController *contactsSearchResultsViewController = [SFCContactsSearchResultsViewController new];
	contactsSearchResultsViewController.dataSource = arrayDataSource;
	
	return contactsSearchResultsViewController;
}

- (void)selectedContact:(SFCContact *)coreDataContact {
	NSError *contactFetchError;
	CNContactStore *cnContactStore = [CNContactStore new];
	CNContact *cnContact = [cnContactStore
							unifiedContactWithIdentifier:coreDataContact.contactId
							keysToFetch:@[[CNContactViewController descriptorForRequiredKeys]]
							error:&contactFetchError];
	
	if (contactFetchError) {
		NSLog(@"Error fetching cnContact: %@", contactFetchError);
		return;
	}
	CNContactViewController *cnContactViewController = [CNContactViewController viewControllerForContact:cnContact];
	cnContactViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:cnContactViewController animated:YES];
	_searchController.active = NO;

}

//MARK: SFCTableViewAdapter Delegate
- (void)adapter:(id<SFCAdapter>)adapter didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithObject:(id)object {
	SFCContact *coreDataContact = object;
	if (!coreDataContact.contactId) {
		return;
	}
	[self selectedContact:coreDataContact];
}

//CNContactViewController Delegate
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact {
	if (!contact) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end
