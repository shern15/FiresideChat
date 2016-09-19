//
//  SFCComposeChatViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCComposeChatViewController.h"
#import "SFCFetchedResultsControllerDataSource.h"
#import "SFCComposeChatTableViewAdapter.h"
#import "SFCContactCell.h"
#import "SFCContact.h"
#import "SFCChat.h"
#import "UIViewController+SHFillWithView.h"

@interface SFCComposeChatViewController()<SFCAdapterDelegate>
{
	NSManagedObjectContext *_context;
}

@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) SFCComposeChatTableViewAdapter *tableViewAdapter;

@end

@implementation SFCComposeChatViewController
@synthesize context = _context;
static NSString *kComposeChatCacheName = @"ComposeChatCache";

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

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
	[self setupTableView];
	
	_tableViewAdapter = [[SFCComposeChatTableViewAdapter alloc]
						 initWithTableView:_tableView
						 andDataSource:[self fetchedResultsControllerDataSource]];
	
	_tableViewAdapter.delegate = self;
	
	self.title = @"New Chat";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithTitle:@"Cancel"
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(cancelButtonHandler:)];
	
	self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupTableView {
	[_tableView registerClass:SFCContactCell.self forCellReuseIdentifier:kSFCContactCellIdentifier];
	[self fillWithView:_tableView];
	
	_tableView.backgroundColor = [UIColor whiteColor];
}

- (SFCFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
	//MARK: Build FetchedResultsController
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCContactEntityName];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"storageId != nil"];
	NSSortDescriptor *lastNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
	NSSortDescriptor *firstNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
	fetchRequest.sortDescriptors = @[firstNameSortDescriptor, lastNameSortDescriptor];
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																							   managedObjectContext:_context
																								 sectionNameKeyPath:@"sortLetter" cacheName:nil];
	[fetchedResultsController performFetch:nil];
	
	SFCFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[SFCFetchedResultsControllerDataSource alloc]
																				 initWithFetchedResultsController:fetchedResultsController
																				 andCelllIdentifier:kSFCContactCellIdentifier];
	return fetchedResultsControllerDataSource;
}

- (void)cancelButtonHandler:(UIButton *)sender
{
	if ([self.delegate respondsToSelector:@selector(composeChatViewControllerDidCancelChatComposition:)]) {
		[self.delegate composeChatViewControllerDidCancelChatComposition:self];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: SFCAdapterDelegate
- (void)adapter:(id<SFCAdapter>)adapter didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithObject:(id)object
{
	
	SFCContact *contact = (SFCContact *)object;
	SFCChat *chat = [SFCChat existingChatWithContact:contact inManagedObjectContext:_context];
	if (!chat) {
		chat = [SFCChat chatWithContact:contact inManagedObjectContext:_context];
	}
	
	if (self.delegate) {
		[self.delegate composeChatViewController:self didComposeChat:chat inManagedObjectContext:_context];
	}
	
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
