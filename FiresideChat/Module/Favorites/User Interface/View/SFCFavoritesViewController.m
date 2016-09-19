//
//  SFCFavoritesViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "SFCFavoritesViewController.h"
#import "SFCMessagesViewController.h"
#import "SFCSelectContactsViewController.h"
#import "SFCFavoriteContactCell.h"
#import "SFCFavoritesTableViewAdapter.h"
#import "SFCFetchedResultsControllerDataSource.h"
#import "SFCContact.h"
#import "SFCChat.h"
#import "SFCContactImporter.h"
#import "UIViewController+SHFillWithView.h"
#import "NSManagedObjectContext+SHSaveContext.h"


@interface SFCFavoritesViewController ()<SFCAdapterDelegate>
{
	NSManagedObjectContext * _context;

}

@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) SFCFavoritesTableViewAdapter *tableViewAdapter;
@property (nonnull, nonatomic) CNContactStore *contactStore;
@property (nonnull, nonatomic) UIImage *settingsCogImage;

@end

@implementation SFCFavoritesViewController
@synthesize context = _context;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupViewController];
	[_tableViewAdapter refreshDataInView];
	
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	[_tableView setEditing:editing animated:animated];
	
	if (editing) {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
												  initWithTitle:@"Delete All"
												  style:UIBarButtonItemStylePlain
												  target:self
												  action:@selector(deleteAllBarButtonItemHandler:)];
	} else {
		self.navigationItem.leftBarButtonItem = [self addFavoriteBarButtonItem];
	}
}

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_contactStore = [CNContactStore new];
	
	[self setupTableView];
	[self setupTableViewAdapter];
	
	[self setupNavigationBar];
	
	self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupTableView {
	[_tableView registerClass:SFCFavoriteContactCell.self forCellReuseIdentifier:kSFCFavoriteContactCellIdentifier];
	_tableView.tableFooterView = [UIView new];

	[self fillWithView:_tableView];
	_tableView.backgroundColor = [UIColor whiteColor];
}

- (void)setupNavigationBar {
	self.navigationItem.rightBarButtonItem = [self editButtonItem];
	self.navigationItem.leftBarButtonItem = [self addFavoriteBarButtonItem];
	self.title = @"Favorites";

}

- (void)setupTableViewAdapter {
	SFCFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [self fetchedResultsControllerDataSource];
	_tableViewAdapter = [[SFCFavoritesTableViewAdapter alloc] initWithTableView:_tableView andDataSource:fetchedResultsControllerDataSource];
	
	_tableViewAdapter.delegate = self;
}

- (SFCFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
	//MARK: Build FetchedResultsController
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCContactEntityName];
	NSSortDescriptor *lastNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
	NSSortDescriptor *firstNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storageId != nil AND isFavorite == YES"];
	fetchRequest.predicate = predicate;
	
	fetchRequest.sortDescriptors = @[lastNameSortDescriptor, firstNameSortDescriptor];
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController
															 alloc] initWithFetchRequest:fetchRequest
															managedObjectContext:_context
															sectionNameKeyPath:nil cacheName:nil];
	
		
	SFCFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[SFCFetchedResultsControllerDataSource alloc]
																				 initWithFetchedResultsController:fetchedResultsController
																				 andCelllIdentifier:kSFCFavoriteContactCellIdentifier];
	return fetchedResultsControllerDataSource;
}

- (UIBarButtonItem *)addFavoriteBarButtonItem {
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
														 target:self
														 action:@selector(addFavoriteBarButtonItemHandler:)];
}

//MARK: Handler Functions
- (void)addFavoriteBarButtonItemHandler:(UIBarButtonItem *)sender {
	if (_context) {
		SFCSelectContactsViewController *selectContactsViewController = [[SFCSelectContactsViewController alloc]
																		 initWithNumberOfSelectionsRequiredToProceed:0 context:_context
																		 searchPredicate:[NSPredicate predicateWithFormat:@"storageId != nil && isFavorite == NO"]
																		 dismissBarButtonItemTitle:@"Done"
																		 viewControllerTitle:@"Add Favorites"];
		selectContactsViewController.delegate = self;
		
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectContactsViewController];
		[self presentViewController:navigationController animated:YES completion:nil];
	}
}
- (void)deleteAllBarButtonItemHandler:(UIBarButtonItem *)barButtonItem
{
	NSArray<SFCContact *> *contactsArray = [_tableViewAdapter.dataSource fetchedObjects];
	if (contactsArray) {
		[_context performBlockAndWait:
		 ^{
			 [contactsArray enumerateObjectsUsingBlock:
			  ^(SFCContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				  obj.isFavorite = NO;
			  }];
			 NSError *error;
			 BOOL saveSuccessful = [_context saveContext:&error];
			 
			 if (!saveSuccessful) {
				 NSLog(@"\n\nError saving context after unfavoriting all users:\n%@\n\n", error);
			 }
		 }];
	}
}

//MARK: SFCSelectContactsDelegate
- (void)controller:(SFCSelectContactsViewController *)controller didSelectContacts:(NSArray<SFCContact *> *)selectedContacts
{
	[_context performBlock:^{
		for (SFCContact *contact in selectedContacts) {
			contact.isFavorite = YES;
		}
		NSError *error;
		BOOL saveSuccessful = [_context saveContext:&error];
		if(!saveSuccessful) {
			NSLog(@"Error while adding contact to Favorites");
		}
	}];
}

//MARK:SFCAdapter Delegate
- (void)adapter:(id<SFCAdapter>)adapter didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithObject:(id)object
{
	[_context performBlockAndWait:
	 ^{
		 SFCContact *contact = object;
		 SFCChat *chat;
		 NSManagedObjectContext *chatContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		 chatContext.parentContext = _context;
		 
		 chat = [SFCChat existingChatWithContact:contact inManagedObjectContext:chatContext];
		 
		 if(!chat) {
			 chat = [SFCChat chatWithContact:contact inManagedObjectContext:chatContext];
		 }
		 
		 SFCMessagesViewController *messagesViewController = [[SFCMessagesViewController alloc] init];
		 messagesViewController.context = chatContext;
		 messagesViewController.parentChat = chat;
		 
		 messagesViewController.hidesBottomBarWhenPushed = YES;
		 
		 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
			 [self.navigationController pushViewController:messagesViewController animated:YES];
		 }];
	 }];
}

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

- (void)adapter:(id<SFCAdapter>)adapter didRemoveRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
	[_context performBlock:^{
		NSError *error;
		BOOL saveSuccessful = [_context saveContext:&error];
		if(!saveSuccessful) {
			NSLog(@"\nError saving context after removing favorite:\n%@\n",error);
		}
	}];
}
@end
