//
//  SFCContactsSearchResultsViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCContactsSearchResultsViewController.h"
#import "SFCArrayDataSource.h"
#import "SFCTableViewAdapter.h"
#import "SFCContact.h"
#import "SFCContactCell.h"
#import "UIViewController+SHFillWithView.h"

@interface SFCContactsSearchResultsViewController ()

@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) SFCTableViewAdapter *tableViewAdapter;
@property (nonnull, nonatomic) UITextField *searchField;
@property (nonnull, nonatomic) NSMutableArray<SFCContact *> *selectedContacts;
@property (nonatomic) BOOL isSearchingParticipants;

@end

@implementation SFCContactsSearchResultsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setupViewController];
	
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self setupTableView];
	[self setupTableViewAdapter];
	[self fillWithView:_tableView];

	
	self.title = @"Add Participants";
}

- (void)setupTableView {
	[_tableView registerClass:SFCContactCell.self forCellReuseIdentifier:kSFCContactCellIdentifier];
	_tableView.tableFooterView = [UIView new];
}

- (void)setupTableViewAdapter {
	_tableViewAdapter = [[SFCTableViewAdapter alloc] initWithTableView:_tableView andDataSource:_dataSource];
	_tableViewAdapter.delegate = _delegate ? _delegate : self;
}

- (NSArray<SFCContact *> *)fetchContactsInManagedObjectContext:(NSManagedObjectContext *)context {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCContactEntityName];
	NSSortDescriptor *lastNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
	NSSortDescriptor *firstNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
	fetchRequest.sortDescriptors = @[lastNameSortDescriptor, firstNameSortDescriptor];
	
	NSError *error;
	NSArray *contacts = [context executeFetchRequest:fetchRequest error:&error];
	
	if (error) {
		NSLog(@"Error Fetching contacts: %@", error);
		return @[];
	}
	
	return contacts;
}

//MARK: SFCAdapter Delegate
- (void)adapter:(id<SFCAdapter>)adapter didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithObject:(id)object {
	if(![_selectedContacts containsObject:object]) {
		[_selectedContacts addObject:(SFCContact *)object];
	}
	
}

//MARK: UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	NSString *searchText = searchController.searchBar.text;
	if (!searchText) {
		return;
	}
	
	if (searchText.length > 0) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[cd] %@", searchText];
		[_tableViewAdapter refreshDataInViewWithPredicate:predicate];
	} else {
		[_tableViewAdapter refreshDataInViewWithPredicate:nil];
	}
}

@end
