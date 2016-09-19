//
//  SFCChatViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//
#import "SFCChatViewController.h"
#import "SFCMessagesViewController.h"
#import "SFCComposeGroupViewController.h"
#import "SFCFetchedResultsControllerDataSource.h"
#import "SFCComposeChatViewController.h"
#import "SFCChatTableViewAdapter.h"
#import "SFCChatTableViewCell.h"
#import "SFCChatTableViewHeader.h"
#import "SFCChat.h"
#import "UIViewController+SHFillWithView.h"
#import "NSManagedObjectContext+SHSaveContext.h"

@interface SFCChatViewController ()<SFCAdapterDelegate>
{
	NSManagedObjectContext * _context;
//	UIBarButtonItem * _signOutBarButtonItem;
}

@property (nonnull, nonatomic) SFCChatTableViewAdapter *chatTableViewAdapter;
@property (nonnull, nonatomic) UITableView *tableView;

@end

@implementation SFCChatViewController
@synthesize context = _context;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupViewController];
	[_chatTableViewAdapter refreshDataInView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[_context performBlock:^{
		NSError *error;
		[_context saveContext:&error];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
	[self setupTableView];
	
	_chatTableViewAdapter = [[SFCChatTableViewAdapter alloc] initWithTableView:_tableView
																 andDataSource:[self fetchedResultsControllerDataSource]];
	_chatTableViewAdapter.delegate = self;
	
	[self setupNavigationBar];
	self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupNavigationBar {
	self.navigationController.navigationBar.topItem.title = @"Chats";
	//self.navigationItem.leftBarButtonItem = _signOutBarButtonItem ? _signOutBarButtonItem : nil;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_chat"]																			  style:UIBarButtonItemStylePlain
																			 target:self action:@selector(composeNewChatButtonHandler:)];
}

- (void)setupTableView {
	[_tableView registerClass:SFCChatTableViewCell.self forCellReuseIdentifier:kSFCChatCellIdentifier];
	_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	SFCChatTableViewHeader *headerView = [[SFCChatTableViewHeader alloc] init];
	[headerView.composeGroupButton addTarget:self action:@selector(composeGroupButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
	_tableView.tableHeaderView = headerView;
	_tableView.translatesAutoresizingMaskIntoConstraints = NO;
	_tableView.rowHeight = 100;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	[self fillWithView:_tableView];
}

- (void)composeNewChatButtonHandler:(UIBarButtonItem *)sender {
	NSManagedObjectContext *composeChatContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	//composeChatContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
	composeChatContext.parentContext = _context;
	SFCComposeChatViewController *composeChatViewController = [[SFCComposeChatViewController alloc] init];
	composeChatViewController.context = composeChatContext;
	composeChatViewController.delegate = self;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeChatViewController];
	[self presentViewController:navigationController animated:true completion:nil];
}

- (SFCFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
	//MARK: Build FetchedResultsController
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCChatEntityName];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastMessageTime" ascending:NO];
	fetchRequest.sortDescriptors = @[sortDescriptor];
	//fetchRequest.relationshipKeyPathsForPrefetching = @[@"messages"];
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																							   managedObjectContext:_context
																								 sectionNameKeyPath:nil cacheName:nil];
	
	SFCFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[SFCFetchedResultsControllerDataSource alloc]
																	  initWithFetchedResultsController:fetchedResultsController
																				 andCelllIdentifier:kSFCChatCellIdentifier];
	return fetchedResultsControllerDataSource;
}

- (void)composeGroupButtonHandler:(UIButton *)sender {
	NSManagedObjectContext *composeGroupChatContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	//composeGroupChatContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
	composeGroupChatContext.parentContext = _context;
	SFCComposeGroupViewController *composeGroupViewController = [SFCComposeGroupViewController new];
	composeGroupViewController.delegate = self;
	composeGroupViewController.context = composeGroupChatContext;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeGroupViewController];
	[self presentViewController:navigationController animated:YES completion:nil];
}

//MARK: SFCAdapterDelegate

- (void)adapter:(id<SFCAdapter>)adapter didSelectRowAtIndexPath:(NSIndexPath *)indexPath WithObject:(id)object {
	SFCChatTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
	[cell showUnreadMessageLabel:NO];
	SFCChat *chat = (SFCChat *)object;
	chat.isActive = YES;
	SFCMessagesViewController *messagesViewController = [SFCMessagesViewController new];
	messagesViewController.context = _context;
	messagesViewController.parentChat = chat;
	messagesViewController.hidesBottomBarWhenPushed = YES;
	
	[self.navigationController pushViewController:messagesViewController animated:YES];
	
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)adapter:(id<SFCAdapter>)adapter didRemoveRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
	[_context performBlock:^{
		NSError *error;
		BOOL saveSuccessful = [_context saveContext:&error];
		if(!saveSuccessful) {
			NSLog(@"\n\nError saving context after chat deletion:\n%@\n", error);
		}
	}];
}

- (void)adapter:(id<SFCAdapter>)adapter didDeselectRowAtIndexPath:(NSIndexPath *)indexPath WithObject:(id)object {
	printf("\ndid deselect row\n");
}

//MARK: SFCComposeChatViewControllerDelegate
- (void)composeChatViewController:(SFCComposeChatViewController *)controller didComposeChat:(SFCChat *)chat
		   inManagedObjectContext:(NSManagedObjectContext *)context
{
	SFCMessagesViewController *messagesViewController = [SFCMessagesViewController new];
	messagesViewController.context = context;
	messagesViewController.parentChat = chat;
	
	messagesViewController.hidesBottomBarWhenPushed = YES;
	
	[self.navigationController pushViewController:messagesViewController animated:YES];
}

@end
