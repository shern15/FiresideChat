//
//  SFCMessagesViewController.h
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCMessagesViewController.h"
#import "SFCGroupDetailsViewController.h"
#import "SFCMessagesTableViewAdapter.h"
#import "SFCKeyboardEventViewAnimator.h"
#import "SFCMessageTableViewCell.h"
#import "SFCMessagesParticipantsHeaderView.h"
#import "SFCFetchedResultsControllerDataSource.h"
#import "SFCMessage.h"
#import "SFCChat.h"
#import "SFCContact.h"
#import "UIViewController+SHFillWithView.h"
#import "UITableView+SFCAdditions.h"
#import "NSManagedObjectContext+SHSaveContext.h"

@interface SFCMessagesViewController()<SFCAdapterDelegate>
{
	NSManagedObjectContext *_context;
}

@property (nonnull, nonatomic) UITableView *tableView;
@property (nonnull, nonatomic) UIView *createMessageBackgroundView;
@property (nonnull, nonatomic) UITextView *createMessageTextView;
@property (nonnull, nonatomic) SFCMessagesParticipantsHeaderView *participantsHeaderView;
@property (nonnull, nonatomic) SFCMessagesTableViewAdapter *messagesTableViewAdapter;
@property (nonnull, nonatomic) NSLayoutConstraint *backgroundBottomConstraint;
@property (nonnull, nonatomic) SFCKeyboardEventViewAnimator *keyboardEventViewAnimator;
@property (nonnull, nonatomic) UIButton *sendButton;

@end

@implementation SFCMessagesViewController
@synthesize context = _context;

NSString * const keyboardWillShowNotificationEvent = @"keyboardWillShowWithNotification";
NSString * const keyboardWillHideNotificationEvent = @"keyboardWillHideWithNotification";


- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self setupViewController];
	[_messagesTableViewAdapter refreshDataInView];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[_tableView scrollToBottom];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	_parentChat.isActive = NO;
	_parentChat.unreadMessagesCount = @0;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setupViewController {
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
	_createMessageBackgroundView = [UIView new];
	_sendButton = [UIButton new];
	_createMessageTextView = [UITextView new];
	
	[self setupCreateMessageBackground];
	[self setupSendButton];
	[self setupCreateMessageTextView];
	[self setupMessagesTableViewAdapter];
	if([_parentChat isGroupChat]) { [self setupParticipantsHeader]; }
	[self setupTableView];
	[self setupViewControllerTitle];
	

	[self addEventListeners];
	
	_keyboardEventViewAnimator = [[SFCKeyboardEventViewAnimator alloc]
								  initWithLayoutConstraintToModify:_backgroundBottomConstraint andConstraintOwner:self.view];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithTitle:@"Details"
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(showGroupDetailsViewController)];
}

- (void)setupMessagesTableViewAdapter {
	_messagesTableViewAdapter = [[SFCMessagesTableViewAdapter alloc]
								 initWithTableView:_tableView
								 andDataSource:[self fetchedResultsControllerDataSource]];
	_messagesTableViewAdapter.delegate = self;
}

- (void)setupParticipantsHeader {
	_participantsHeaderView = [SFCMessagesParticipantsHeaderView new];
	[_participantsHeaderView setParticipantsNamesWithArray:[_parentChat participantNames]];
	
	_participantsHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.view addSubview:_participantsHeaderView];
	
	NSArray<NSLayoutConstraint *> *constraints = @[
												   [_participantsHeaderView.leadingAnchor
													constraintEqualToAnchor: self.view.leadingAnchor],
												   [_participantsHeaderView.trailingAnchor
													constraintEqualToAnchor:self.view.trailingAnchor],
												   [_participantsHeaderView.topAnchor
													constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
												   [_participantsHeaderView.heightAnchor
													constraintEqualToConstant:30]
												   ];
	
	[NSLayoutConstraint activateConstraints:constraints];
	
	UITapGestureRecognizer *participantsHeaderTapRecognizer = [[UITapGestureRecognizer alloc]
															   initWithTarget:self
															   action:@selector(participantsHeaderTapHandler:)];
	
	[_participantsHeaderView addGestureRecognizer:participantsHeaderTapRecognizer];

}

- (void)setupTableView {
	[_tableView registerClass:SFCMessageTableViewCell.self forCellReuseIdentifier:kSFCMessageCellIdentifier];
	_tableView.estimatedSectionHeaderHeight = 5;
	_tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
	
	_tableView.sectionFooterHeight = 1;
	_tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
	_tableView.estimatedSectionHeaderHeight = 25;
	_tableView.translatesAutoresizingMaskIntoConstraints = NO;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.estimatedRowHeight = 44;
	[self.view addSubview:_tableView];
	
	NSArray<NSLayoutConstraint *> *tableViewConstraints;
	tableViewConstraints = @[
							 [_tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
							 [_tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
							 [_tableView.bottomAnchor constraintEqualToAnchor:_createMessageBackgroundView.topAnchor]
							];
	
	NSLayoutConstraint *topConstraint = _participantsHeaderView ? [_tableView.topAnchor constraintEqualToAnchor:_participantsHeaderView.bottomAnchor] : [_tableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor];
	topConstraint.active = YES;
	[NSLayoutConstraint activateConstraints:tableViewConstraints];
}


- (void)setupSendButton {
	_sendButton.translatesAutoresizingMaskIntoConstraints = false;
	[_createMessageBackgroundView addSubview:_sendButton];
	
	[_sendButton setTitle:@"Send" forState:UIControlStateNormal];
	[_sendButton setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
	[_sendButton setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
	[_sendButton addTarget:self action:@selector(sendButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCreateMessageTextView {
	_createMessageTextView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_createMessageTextView];
	
	_createMessageTextView.scrollEnabled = NO;
	
	
	NSArray<NSLayoutConstraint *> *createMessageViewConstraints;
	createMessageViewConstraints = @[
								 [_createMessageTextView.leadingAnchor
								  constraintEqualToAnchor:_createMessageBackgroundView.leadingAnchor constant:10],
								 [_createMessageTextView.centerYAnchor
								  constraintEqualToAnchor:_createMessageBackgroundView.centerYAnchor],
								 [_sendButton.trailingAnchor
								  constraintEqualToAnchor:_createMessageBackgroundView.trailingAnchor constant:-10],
								 [_createMessageTextView.trailingAnchor
								  constraintEqualToAnchor:_sendButton.leadingAnchor constant:-10],
								 [_sendButton.centerYAnchor constraintEqualToAnchor:_createMessageTextView.centerYAnchor],
								 [_createMessageBackgroundView.heightAnchor constraintEqualToAnchor:_createMessageTextView.heightAnchor constant:20]
								 ];
	
	[NSLayoutConstraint activateConstraints:createMessageViewConstraints];
}

- (void)setupCreateMessageBackground {
	_createMessageBackgroundView.backgroundColor = [UIColor lightGrayColor];
	_createMessageBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_createMessageBackgroundView];
	
	NSArray<NSLayoutConstraint *> *createMessageBackgroundConstraints;
	createMessageBackgroundConstraints = @[
										   [_createMessageBackgroundView.leadingAnchor
											constraintEqualToAnchor:self.view.leadingAnchor],
										   [_createMessageBackgroundView.trailingAnchor
											constraintEqualToAnchor:self.view.trailingAnchor]
										   ];
	_backgroundBottomConstraint = [_createMessageBackgroundView.bottomAnchor
								   constraintEqualToAnchor:self.view.bottomAnchor];

	
	_backgroundBottomConstraint.active = YES;
	[NSLayoutConstraint activateConstraints:createMessageBackgroundConstraints];
	
}

- (void)setupViewControllerTitle {
	[_context performBlock:^{
		SFCChat *parentChat = [_context objectWithID:_parentChat.objectID];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			self.navigationItem.title = [parentChat chatName];
		}];
	}];
}

- (SFCFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
{
	//MARK: Build FetchedResultsController
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kSFCMessageEntityName];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
	fetchRequest.sortDescriptors = @[sortDescriptor];
	fetchRequest.predicate = [self fetchPredicate];
	
	NSManagedObjectContext *context = _context.parentContext ? _context.parentContext : _context;
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																							   managedObjectContext:context
																								 sectionNameKeyPath:kSFCSectionIdentifierKey cacheName:nil];
	
	SFCFetchedResultsControllerDataSource *fetchedResultsControllerDataSource = [[SFCFetchedResultsControllerDataSource alloc]
																				 initWithFetchedResultsController:fetchedResultsController
																				 andCelllIdentifier:kSFCMessageCellIdentifier];
	
	return fetchedResultsControllerDataSource;
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"chat == %@", _parentChat];
}

- (void)addEventListeners {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardEventNotification:)
												 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardEventNotification:)
												 name:UIKeyboardWillHideNotification object:nil];
	
	NSManagedObjectContext *context = _context.parentContext ? _context.parentContext : _context;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidUpdate:)
												 name:NSManagedObjectContextObjectsDidChangeNotification object:context];
	
	UITapGestureRecognizer *controllerViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																					action:@selector(controllerViewTapHandler:)];
	
	[self.view addGestureRecognizer:controllerViewTapRecognizer];
}

- (void)participantsHeaderTapHandler:(UITapGestureRecognizer *)tapRecognizer
{
	[_createMessageTextView resignFirstResponder];
	[self showGroupDetailsViewController];
}

- (void)controllerViewTapHandler:(UITapGestureRecognizer *)recognizer {
	[_createMessageTextView resignFirstResponder];
}

- (void)sendButtonHandler:(UIButton *)sender {
	NSString *text = _createMessageTextView.text;
	if (!text || text.length == 0) {
		return;
	}

	[self appendMessageWithText:text isIncoming:NO andDate:[NSDate new]];
	[self checkTemporaryContext];
	NSError *error;
	BOOL saveSuccessful = [_context saveContext:&error];
	if(!saveSuccessful) {
		NSLog(@"error saving main context:\n\n%@", error);
	}
	_createMessageTextView.text = @"";
}

- (void)showGroupDetailsViewController {
	NSArray<SFCContact *> *participants = _parentChat.participants.allObjects;
	SFCGroupDetailsViewController *groupDetailsViewController = [SFCGroupDetailsViewController new];
	groupDetailsViewController.participantsArray = participants;
	
	[self.navigationController pushViewController:groupDetailsViewController animated:YES];

}

//MARK: Keyboard Notifications

- (void)keyboardEventNotification:(NSNotification *)notification {
	[_keyboardEventViewAnimator animateOnKeyboardNotification:notification
								  withViewToShowAboveKeyboard:nil
									  keyboardPaddingConstant:0.0
											   animationDelay:0.0
										  animationCompletion:^(BOOL finished) {
											  [_tableView scrollToBottom];
										  }];
}

- (void)contextDidUpdate:(NSNotification *)notification {
	[_context performBlock:^{
		NSSet *set = (NSSet *)notification.userInfo[NSInsertedObjectsKey];
		NSArray *insertedObjects = set.allObjects;
		[insertedObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if ([obj isKindOfClass:[SFCMessage class]]) {
				SFCMessage *message = (SFCMessage *)obj;
				if (message.chat.objectID == _parentChat.objectID) {
					[_parentChat addMessagesObject:message];
				}
			}
			
		}];
		[_tableView scrollToBottom];
	}];
}

//MARK: Helper methods
- (void)checkTemporaryContext {
	//If there's a parentContext on _context, then that means
	//_parentContext is the main context and current _context
	//is the temporary context.
	NSManagedObjectContext *parentContext = _context.parentContext;
	if (parentContext) {
		//Place the temporary context into a temporary variable
		//and put the main context into our context member variable
		NSManagedObjectContext *temporaryContext = _context;
		_context = parentContext;
		NSError *error;
		BOOL saveSuccessful = [temporaryContext saveContext:&error];
		if (!saveSuccessful) {
			NSLog(@"error saving messages context:\n%@", error);
		}
		else {
			
			self.parentChat = [_context existingObjectWithID:_parentChat.objectID error:&error];
			[_messagesTableViewAdapter refreshDataInViewWithPredicate:[self fetchPredicate]];
		}
	}
}

- (void)appendMessageWithText:(NSString *)text isIncoming:(BOOL)isIncoming andDate:(NSDate *)date
{
	SFCMessage *message = [SFCMessage messageWithText:text timestamp:date inManagedObjectContext:_context];
	
	_parentChat.lastMessageTime = date;
	message.chat = _parentChat;
	
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
