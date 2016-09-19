//
//  SFCSelectContactsViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez on 9/15/16.
//  Copyright © 2016 Sean Hernandez. All rights reserved.
//

#import "SFCSelectContactsViewController.h"
#import "SFCSelectContactsTableViewAdapter.h"
#import "SFCContactCell.h"
#import "SFCArrayDataSource.h"
#import "SFCSearchField.h"
#import "SFCContact.h"
#import "UIViewController+SHFillWithView.h"
#import "UIColor+SFCViewColors.h"

@interface SFCSelectContactsViewController ()<UITextFieldDelegate>
{
	NSManagedObjectContext *_context;
}
@property (nonnull, nonatomic) UITextField *searchField;
@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) SFCSelectContactsTableViewAdapter *tableViewAdapter;
@property (nonnull, nonatomic) NSMutableArray<SFCContact *> *selectedContacts;
@property (nonatomic) BOOL isSearchingContactsList;

@end

@implementation SFCSelectContactsViewController
@synthesize context = _context;

- (instancetype)init {
	return [self initWithNumberOfSelectionsRequiredToProceed:0 context:nil
											 searchPredicate:nil dismissBarButtonItemTitle:nil
										 viewControllerTitle:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	return self;
}

- (instancetype)initWithNumberOfSelectionsRequiredToProceed:(NSUInteger)numberOfSelectionsRequiredToProceed context:(NSManagedObjectContext *)context
{
	
	return [self initWithNumberOfSelectionsRequiredToProceed:numberOfSelectionsRequiredToProceed context:context
				 searchPredicate:nil dismissBarButtonItemTitle:nil viewControllerTitle:nil];
}

- (nonnull instancetype)initWithNumberOfSelectionsRequiredToProceed:(NSUInteger)numberOfSelectionsRequiredToProceed context:(NSManagedObjectContext *)context
													searchPredicate:(NSPredicate *)searchPredicate dismissBarButtonItemTitle:(NSString *)dismissBarButtonItemTitle
												viewControllerTitle:(NSString *)viewControllerTitle;
{
	if((self  = [super init]))
	{
		_context = context;
		_numberOfSelectionsRequiredToProceed = numberOfSelectionsRequiredToProceed;
		_dismissBarButtonItemTitle = dismissBarButtonItemTitle ? dismissBarButtonItemTitle : @"Done";
		_searchPredicate = searchPredicate;
		self.title = viewControllerTitle ? viewControllerTitle : @"Select Contacts";
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self setupTableView];
	[self setupDataSource];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_dismissBarButtonItemTitle
																			  style:UIBarButtonItemStylePlain
																			 target:self
																			 action:@selector(dismissButtonHandler:)];

	[self enableDismissBarButtonItem:[self doesMeetSelectionThreshold]];
	self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupTableView {
	[_tableView registerClass:SFCContactCell.self forCellReuseIdentifier:kSFCContactCellIdentifier];
	_tableView.tableFooterView = [UIView new];
	_tableView.tableHeaderView = [self searchField];
	_tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
	
	[self fillWithView:_tableView];
}

- (void)setupDataSource {
	NSArray<SFCContact *> *allContacts = [self fetchContactsInManagedObjectContext:_context];
	_selectedContacts = [[NSMutableArray alloc] init];
	SFCArrayDataSource *dataSource = [[SFCArrayDataSource alloc] initWithObjectsArray:allContacts
																   andCelllIdentifier:kSFCContactCellIdentifier];
	
	
	_tableViewAdapter = [[SFCSelectContactsTableViewAdapter alloc] initWithTableView:_tableView andDataSource:dataSource];
	_tableViewAdapter.delegate = self;
}

- (NSArray<SFCContact *> *)fetchContactsInManagedObjectContext:(NSManagedObjectContext *)context {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCContactEntityName];
	if (_searchPredicate) {
		fetchRequest.predicate = _searchPredicate;
	}
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

//MARK: UITextfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *currentText = textField.text;
	
	if (!currentText) {
		[self endSearchWithString:nil];
		return YES;
	}
	
	NSString *text = [currentText stringByReplacingCharactersInRange:range withString:string];
	
	if (text.length == 0) {
		[self endSearchWithString:nil];
		return YES;
	}
	
	[self endSearchWithString:text];
	
	return YES;
}

- (UITextField *)searchField {
	
	CGRect searchFieldRect = CGRectMake(0, 0, 0, 50);
	SFCSearchField *searchField = [[SFCSearchField alloc] initWithFrame:searchFieldRect];
	searchField.delegate = self;
	return searchField;
}

- (void)endSearchWithString:(NSString *)string
{
	_isSearchingContactsList = NO;
	
	if (!string) {
		[_tableViewAdapter refreshDataInView];
		return;
	}
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[cd] %@", string];
	[_tableViewAdapter refreshDataInViewWithPredicate:predicate];
}

//MARK: Helper Methods
- (void)enableDismissBarButtonItem:(BOOL)show {
	if (show) {
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor navigationBarItemTintColor];
		self.navigationItem.rightBarButtonItem.enabled = YES;
		
	} else {
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
}

- (void)dismissButtonHandler:(UIBarButtonItem *)sender
{
	if(_delegate) {
		[_delegate controller:self didSelectContacts:_selectedContacts];
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}


//MARK: SFCAdapter Delegate
- (void)adapter:(id<SFCAdapter>)adapter didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithObject:(id)object {
	if(![_selectedContacts containsObject:object]) {
		[_selectedContacts addObject:(SFCContact *)object];
		[self enableDismissBarButtonItem:[self doesMeetSelectionThreshold]];
	}
}

- (BOOL)doesMeetSelectionThreshold {
	return _selectedContacts.count >= _numberOfSelectionsRequiredToProceed;
}

@end
