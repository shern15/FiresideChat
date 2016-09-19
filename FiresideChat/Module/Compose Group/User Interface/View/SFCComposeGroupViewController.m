//
//  SFCComposeGroupViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCComposeGroupViewController.h"
#import "SFCSelectContactsViewController.h"
#import "SFCTableViewAdapter.h"
#import "SFCFetchedResultsControllerDataSource.h"
#import "SFCContact.h"
#import "SFCChat.h"
#import "UIViewController+SHFillWithView.h"
#import "UIColor+SFCViewColors.h"

@interface SFCComposeGroupViewController()<UITextFieldDelegate>
{
	NSManagedObjectContext *_context;
}

@property (nonnull, nonatomic) UITextField *subjectField;
@property (nonnull, nonatomic) UILabel *characterNumberLabel;
@property (nonnull, nonatomic) UIImageView *backgroundImageView;

@end

@implementation SFCComposeGroupViewController
@synthesize context = _context;
static NSString *kComposeChatCacheName = @"ComposeChatCache";

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setupViewController];
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[_subjectField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setupViewController {
	_subjectField = [UITextField new];
	_characterNumberLabel = [UILabel new];
	
	_backgroundImageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
	self.title = @"New Group";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
											  initWithTitle:@"Cancel"
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(cancelButtonHandler:)];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithTitle:@"Next"
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(nextButtonHandler:)];
	[self updateNextButtonForCharCount:0];
	
	_subjectField.placeholder = @"Group Subject";
	_subjectField.delegate = self;
	_subjectField.translatesAutoresizingMaskIntoConstraints = NO;
	[self fillWithView:_backgroundImageView];
	[self.view addSubview:_subjectField];
	[self updateCharacterLabelForCharCount:0];
	
	[_characterNumberLabel setTextColor:[UIColor grayColor]];
	_characterNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_subjectField addSubview:_characterNumberLabel];
	
	UIView *bottomBorder = [UIView new];
	bottomBorder.backgroundColor = [UIColor lightGrayColor];
	bottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
	[_subjectField addSubview:bottomBorder];
	
	NSArray<NSLayoutConstraint *> *constraints;
	constraints = @[
					[_subjectField.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:20],
					[_subjectField.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor],
					[_subjectField.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
					[bottomBorder.widthAnchor constraintEqualToAnchor:_subjectField.widthAnchor],
					[bottomBorder.bottomAnchor constraintEqualToAnchor:_subjectField.bottomAnchor],
					[bottomBorder.leadingAnchor constraintEqualToAnchor:_subjectField.leadingAnchor],
					[bottomBorder.heightAnchor constraintEqualToConstant:1],
					[_characterNumberLabel.centerYAnchor constraintEqualToAnchor:_subjectField.centerYAnchor],
					[_characterNumberLabel.trailingAnchor constraintEqualToAnchor:_subjectField.layoutMarginsGuide.trailingAnchor]
					];
	
	[NSLayoutConstraint activateConstraints:constraints];
}

- (void)nextButtonHandler:(UIButton *)sender {
	if (_context) {		
		SFCSelectContactsViewController *selectContactsViewController = [[SFCSelectContactsViewController alloc]
																		 initWithNumberOfSelectionsRequiredToProceed:2 context:_context
																		 searchPredicate:[NSPredicate predicateWithFormat:@"storageId != nil"]
																		 dismissBarButtonItemTitle:@"Create"
																		 viewControllerTitle:@"Add Participants"];
		selectContactsViewController.delegate = self;
		
		[self.navigationController pushViewController:selectContactsViewController animated:YES];
	}
}

- (void)cancelButtonHandler:(UIButton *)sender
{
	if ([self.delegate respondsToSelector:@selector(composeChatViewControllerDidCancelChatComposition:)]) {
		[self.delegate composeChatViewControllerDidCancelChatComposition:self];
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateCharacterLabelForCharCount:(NSUInteger)length {
	_characterNumberLabel.text = [NSString stringWithFormat:@"%lud",25 - length];
}

- (void)updateNextButtonForCharCount:(NSUInteger)length {
	if (length == 0) {
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
		self.navigationItem.rightBarButtonItem.enabled = NO;
	} else {
		self.navigationItem.rightBarButtonItem.tintColor = [UIColor navigationBarItemTintColor];
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
}

//MARK: UITextfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSUInteger currentCharCount = [textField.text length];
	NSUInteger newLength = currentCharCount + [string length] - range.length;
	
	if (newLength <= 25) {
		[self updateCharacterLabelForCharCount:newLength];
		[self updateNextButtonForCharCount:newLength];
		
		return YES;
	}
	
	return NO;
}

//MARK: SFCSelectContactsDelegate
//Create Chat
- (void)controller:(SFCSelectContactsViewController *)controller didSelectContacts:(NSArray<SFCContact *> *)selectedContacts
{
   if (!_context) {
		return;
	}
	SFCChat *chat = [SFCChat chatWithName:_subjectField.text inManagedObjectContext:_context];
	
	
	chat.participants = [[NSSet alloc] initWithArray:selectedContacts];
	
	if (self.delegate) {
		[self.delegate composeChatViewController:self didComposeChat:chat inManagedObjectContext:_context];
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
