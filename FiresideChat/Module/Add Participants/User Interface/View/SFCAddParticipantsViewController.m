//
//  SFCAddParticipantsViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCAddParticipantsViewController.h"
#import "SFCFetchedResultsControllerDataSource.h"
#import "SFCContact.h"
#import "SFCContactCell.h"
#import "SFCChat.h"
#import "SFCSearchField.h"
#import "SFCArrayDataSource.h"
#import "SFCAddParticipantsTableViewAdapter.h"
#import "UIViewController+SHFillWithView.h"
#import "UIColor+SFCViewColors.h"

@interface SFCAddParticipantsViewController()<UITextFieldDelegate, SFCAdapterDelegate>

@property (nonnull, nonatomic) UITextField *searchField;
@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) SFCTableViewAdapter *tableViewAdapter;
@property (nonnull, nonatomic) NSMutableArray<SFCContact *> *selectedContacts;
@property (nonatomic) BOOL isSearchingParticipants;
@end

@implementation SFCAddParticipantsViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setupViewController];
	
	// [_tableViewAdapter reloadDataWithPredicate:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self setupTableView];
	[self setupDataSource];
	
	
	self.title = @"Add Participants";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createChat)];
	[self showCreateButton:NO];
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
	NSArray<SFCContact *> *allContacts = [self fetchContactsInManagedObjectContext:_composeChatContext];
	_selectedContacts = [[NSMutableArray alloc] init];
	SFCArrayDataSource *dataSource = [[SFCArrayDataSource alloc] initWithObjectsArray:allContacts
																   andCelllIdentifier:kSFCContactCellIdentifier];
	
	
	_tableViewAdapter = [[SFCAddParticipantsTableViewAdapter alloc] initWithTableView:_tableView andDataSource:dataSource];
	_tableViewAdapter.delegate = self;
}

- (NSArray<SFCContact *> *)fetchContactsInManagedObjectContext:(NSManagedObjectContext *)context {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCContactEntityName];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"storageId != nil"];
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
		if(_selectedContacts.count > 1) {
			[self showCreateButton:YES];
		}
	}
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


//MARK: Helper Methods
- (void)showCreateButton:(BOOL)show {
	if (show) {
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor navigationBarItemTintColor];
		self.navigationItem.rightBarButtonItem.enabled = YES;
		
	} else {
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
}

- (UITextField *)searchField {
	
	CGRect searchFieldRect = CGRectMake(0, 0, 0, 50);
	SFCSearchField *searchField = [[SFCSearchField alloc] initWithFrame:searchFieldRect];
	searchField.delegate = self;
	return searchField;
}

- (void)endSearchWithString:(NSString *)string
{
	_isSearchingParticipants = NO;

	if (!string) {
		[_tableViewAdapter refreshDataInViewWithPredicate:nil];
		return;
	}
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullName CONTAINS[cd] %@", string];
	[_tableViewAdapter refreshDataInViewWithPredicate:predicate];
}

- (void)createChat {
	if (!self.chat || !self.composeChatContext) {
		return;
	}
	
	self.chat.participants = [[NSSet alloc] initWithArray:self.selectedContacts];
	
	if (self.delegate) {
		[self.delegate composeChatViewController:self didComposeChat:_chat inManagedObjectContext:_composeChatContext];
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
