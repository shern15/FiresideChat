//
//  SFCRootContainerViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

@import Firebase;

#import "SFCRootContainerViewController.h"
#import "SFCCoreDataStack.h"
#import "SFCChatViewController.h"
#import "SFCContactsViewController.h"
#import "SFCContact.h"
#import "SFCContactImporter.h"
#import "SFCCoreDataStackConsumer.h"
#import "SFCContextConsumer.h"
#import "SFCContextSynchronizer.h"
#import "SFCFavoritesViewController.h"
#import "SFCSignUpViewController.h"
#import "SFCFirebaseStore.h"
#import "UIViewController+SHFillWithView.h"
#import "UINavigationBar+SFCNavigationBarAppearance.h"
#import "NSManagedObjectContext+SHSaveContext.h"
#import "NSUserDefaults+SHStoredUserDefaults.h"


@interface SFCRootContainerViewController ()

@property (nonnull, nonatomic) SFCCoreDataStack *coreDataStack;
@property (nonnull, nonatomic) SFCContactImporter *contactImporter;
@property (nonnull, nonatomic) SFCContextSynchronizer *writerContextSynchronizer;
@property (nonnull, nonatomic) SFCContextSynchronizer *contactsSynchronizer;
@property (nonnull, nonatomic) SFCContextSynchronizer *contactsUploadSynchronizer;
@property (nonnull, nonatomic) SFCContextSynchronizer *firebaseSynchronizer;
@property (nonnull, nonatomic) SFCFirebaseStore *firebaseStore;
@property (nonnull, nonatomic) SFCSignUpViewController *signUpViewController;
@property (nonnull, nonatomic) UITabBarController *tabBarController;

@end

@implementation SFCRootContainerViewController
typedef NSArray<NSDictionary<NSString *, id> *> ViewControllerDataArray;
static NSString * const kImageKey = @"image";
static NSString * const kSelectedImageKey = @"selectedImage";
static NSString * const kViewControllerKey = @"viewController";
static NSString * const kTitleKey = @"title";

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
	_coreDataStack = [SFCCoreDataStack new];
	[self initializeSynchronizersWithPersistentStoreCoordinator:_coreDataStack.persistentStoreCoordinator];
	
	if ([_firebaseStore hasAuth] &&
		[NSUserDefaults currentPhoneNumber]) {
		[_firebaseStore startSynchronization];
		[_contactImporter fetchContacts];
		[_contactImporter addObservers];

		[self addViewController:[self tabBarController]];
	} else {
		if ([_firebaseStore hasAuth]) {
			[_firebaseStore unauth];
		}
		[self addViewController:[self signUpViewController]];
	}
}

- (void)initializeSynchronizersWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	NSManagedObjectContext *contactsContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	contactsContext.persistentStoreCoordinator = persistentStoreCoordinator;
	//contactsContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
	
	NSManagedObjectContext *firebaseContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	firebaseContext.persistentStoreCoordinator = persistentStoreCoordinator;
	//firebaseContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;

	_contactImporter = [[SFCContactImporter alloc] initWithManagedObjectContext:contactsContext];
	_firebaseStore = [[SFCFirebaseStore alloc] initWithManagedObjectContext:firebaseContext];

	_contactsSynchronizer = [[SFCContextSynchronizer alloc] initWithMainContext:_coreDataStack.managedObjectContext andBackgroundContext:contactsContext];
	_contactsUploadSynchronizer = [[SFCContextSynchronizer alloc] initWithMainContext:contactsContext andBackgroundContext:firebaseContext];
	_firebaseSynchronizer = [[SFCContextSynchronizer alloc] initWithMainContext:_coreDataStack.managedObjectContext andBackgroundContext:firebaseContext];
	
	_contactsUploadSynchronizer.remoteStore = _firebaseStore;
	_firebaseSynchronizer.remoteStore = _firebaseStore;
}

- (NSArray<UINavigationController *> *)navigationControllersArray {
	[UINavigationBar stylizeNavigationBarAppearance];
	__block NSMutableArray<UINavigationController *> *navigationControllersArray = [NSMutableArray new];
	ViewControllerDataArray *viewControllerDataArray = @[
														 @{kViewControllerKey : [SFCFavoritesViewController new],
														   kImageKey : [[UIImage imageNamed:@"favorites_icon_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
														   kSelectedImageKey : [[UIImage imageNamed:@"favorites_icon_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
														   kTitleKey : @"Favorites"},
														 @{kViewControllerKey : [SFCContactsViewController new],
														   kImageKey : [[UIImage imageNamed:@"contact_icon_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
														   kSelectedImageKey : [[UIImage imageNamed:@"contact_icon_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
														   kTitleKey : @"Contacts"},
														 @{kViewControllerKey : [SFCChatViewController new],
														   kImageKey : [[UIImage imageNamed:@"chat_icon_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
														   kSelectedImageKey : [[UIImage imageNamed:@"chat_icon_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
														   kTitleKey : @"Chats"}
														 ];
	
	[viewControllerDataArray enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UIViewController *viewController = (UIViewController *)obj[kViewControllerKey];
		if([viewController conformsToProtocol:@protocol(SFCContextConsumer)]) {
			((id<SFCContextConsumer>)viewController).context = _coreDataStack.managedObjectContext;
		}
		
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		navigationController.tabBarItem.image = (UIImage *)obj[kImageKey];
		navigationController.tabBarItem.selectedImage = (UIImage *)obj[kSelectedImageKey];
		[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
		[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor yellowColor]} forState:UIControlStateSelected];
		navigationController.title = (NSString *)obj[kTitleKey];
		[navigationControllersArray addObject:navigationController];
	}];
	
	return [NSArray arrayWithArray:navigationControllersArray];
}

- (UIViewController *)signUpViewController {
	if (_signUpViewController) {
		return _signUpViewController;
	}
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SignUpViewController" bundle:[NSBundle mainBundle]];
	SFCSignUpViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kSFCSignUpViewControllerIdentifier];
	viewController.remoteStore = _firebaseStore;
	viewController.contactImporter = _contactImporter;
	
	_signUpViewController = viewController;
	_signUpViewController.delegate = self;
	
	return viewController;
}

- (UITabBarController *)tabBarController {
	if (_tabBarController) {
		return _tabBarController;
	}
	
	UITabBarController *tabBarController = [UITabBarController new];
	tabBarController.viewControllers = [self navigationControllersArray];
	_tabBarController = tabBarController;
	_tabBarController.tabBar.barTintColor = [UIColor secondaryColor];
	_tabBarController.tabBar.tintColor = [UIColor colorWithHexString:kBarItemTintColorHex];
	return tabBarController;
}

- (void)transitionFromSourceViewController: (UIViewController*) sourceViewController
			   toDestinationViewController: (UIViewController*) destinationViewController {

	UIView *sourceSnapshot = [sourceViewController.view snapshotViewAfterScreenUpdates:YES];
	[destinationViewController.view addSubview:sourceSnapshot];
	[self addChildViewController:destinationViewController];
	
 
 
	// Queue up the transition animation.
	[self transitionFromViewController: sourceViewController toViewController: destinationViewController
							  duration: 0.25 options:0
							animations:^{
								sourceSnapshot.layer.opacity = 0;
								sourceSnapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
							} completion:^(BOOL finished) {
								[sourceViewController willMoveToParentViewController:nil];
								[sourceViewController removeFromParentViewController];
								[sourceSnapshot removeFromSuperview];
								[destinationViewController didMoveToParentViewController:self];
							}];
}

- (void)addViewController:(UIViewController *)viewController {
	[self addChildViewController:viewController];
	[self fillWithView:viewController.view];
}

//MARK: SFCLoginStateDelegate
- (void)didLoginFromViewController:(UIViewController *)sourceViewController {
	[self transitionFromSourceViewController:sourceViewController toDestinationViewController:[self tabBarController]];
}

@end
