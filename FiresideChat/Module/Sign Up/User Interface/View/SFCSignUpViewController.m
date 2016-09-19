//
//  SFCSignUpViewController.m
//  FiresideChat
//
//  Created by Sean Hernandez.
//

#import "SFCSignUpViewController.h"
#import "SFCRemoteStoreInterface.h"
#import "SFCContactImporter.h"
#import "SFCCustomTextField.h"
#import "SFCCustomButton.h"
#import "SFCKeyboardEventViewAnimator.h"
#import "SFCShowTextFieldAnimator.h"

@interface SFCSignUpViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumberConstraint;
@property (weak, nonatomic) IBOutlet SFCCustomTextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet SFCCustomTextField *emailTextField;
@property (weak, nonatomic) IBOutlet SFCCustomTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalConstraint;
@property (weak, nonatomic) IBOutlet UILabel *haveAnAccountLabel;
@property (weak, nonatomic) IBOutlet SFCCustomButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *changeFormButton;

@property (nonatomic, nonnull) SFCKeyboardEventViewAnimator *keyboardEventViewAnimator;
@property (nonatomic, nonnull) SFCShowTextFieldAnimator *showTextFieldAnimator;
@property (nonatomic) BOOL keyboardAlreadyVisible;
@property (nonatomic) BOOL isRegistrationMode;
@end

@implementation SFCSignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupViewController];
	
	_isRegistrationMode = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)toggleRegistration {
	_isRegistrationMode = !_isRegistrationMode;
	[_showTextFieldAnimator animateToShowTextField:_isRegistrationMode withAnimationDuration:0.25];

	if (_isRegistrationMode) {
		[_continueButton setTitle:@"Register" forState:UIControlStateNormal];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:_changeFormButton.currentAttributedTitle];
		_haveAnAccountLabel.text = @"Already have an account?";
		
		[attributedString replaceCharactersInRange:NSMakeRange(0, attributedString.length) withString:@"Login"];
		[_changeFormButton setAttributedTitle:attributedString forState:UIControlStateNormal];
	} else {
		[_continueButton setTitle:@"Login" forState:UIControlStateNormal];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:_changeFormButton.currentAttributedTitle];
		_haveAnAccountLabel.text = @"Don't have an account?";
		
		[attributedString replaceCharactersInRange:NSMakeRange(0, attributedString.length) withString:@"Register"];
		[_changeFormButton setAttributedTitle:attributedString forState:UIControlStateNormal];
	}
	
	//TODO: Animate UI based on RegistrationMode
}


- (void)setupViewController {
	_keyboardEventViewAnimator = [[SFCKeyboardEventViewAnimator alloc] initWithLayoutConstraintToModify:_logoVerticalConstraint andConstraintOwner:self.view];
	_showTextFieldAnimator = [[SFCShowTextFieldAnimator alloc] initWithTextField:_phoneNumberTextField
															 textFieldConstraint:_phoneNumberConstraint
																constantModifier:48];
	[self listenForKeyboardEvents];
	[_continueButton addTarget:self action:@selector(continueButtonTapHandler:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addGestureRecognizer:[self tapGestureRecornizer]];
}

- (UIGestureRecognizer *)tapGestureRecornizer {
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
													initWithTarget:self
													action:@selector(tapGestureHandler:)];
	
	return tapGestureRecognizer;
}
- (void)listenForKeyboardEvents {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShowEventNotification:)
												 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHideEventNotification:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
	[self.view endEditing:YES];
}

- (void)continueButtonTapHandler:(UIButton *)sender {
	sender.enabled = NO;
	[self.view resignFirstResponder];
	if (![self validateTextFields]) {
		sender.enabled = YES;
		return;
	}
	if (_isRegistrationMode) {
		[_remoteStore
		 signUpWithPhoneNumber:_phoneNumberTextField.text
		 email:_emailTextField.text password:_passwordTextField.text
		 successCallback:
		 ^{
			 printf("\nSuccess!\n");
			 sender.enabled = YES;
			 _phoneNumberTextField.text = @"";
			 _emailTextField.text = @"";
			 _passwordTextField.text = @"";
			 
			 [_contactImporter fetchContacts];
			 [_remoteStore startSynchronization];
			 [_contactImporter addObservers];

			 
			 [_delegate didLoginFromViewController:self];
			 
		 }
		 errorCallback:
		 ^(NSString * _Nonnull errorMessage) {
			 sender.enabled = YES;
			 NSLog(@"\n\nError registering user:\n\n%@\n", errorMessage);
			 [self presentAlertForErrorMessage:errorMessage];
		 }];
	} else {
		[_remoteStore loginWithEmail:_emailTextField.text
							password:_passwordTextField.text
					 successCallback:^{
						 printf("\nSuccess!\n");
						 [_remoteStore startSynchronization];
						 [_contactImporter fetchContacts];
						 [_contactImporter addObservers];
						 
						 sender.enabled = YES;
						 _phoneNumberTextField.text = @"";
						 _emailTextField.text = @"";
						 _passwordTextField.text = @"";

						 [_delegate didLoginFromViewController:self];
					 }
					   errorCallback:^(NSString * _Nonnull errorMessage) {
						   NSLog(@"\n\nError signing in user:\n\n%@\n", errorMessage);
						   sender.enabled = YES;
						   [self presentAlertForErrorMessage:errorMessage];
					   }];
	}
}


- (void)presentAlertForErrorMessage:(NSString *)errorMessage
{
	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@"Error"
										  message:errorMessage
										  preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
	[alertController addAction:okAction];
	
	[self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)validateTextFields {
	if (_isRegistrationMode) {
		if (!_phoneNumberTextField.text || _phoneNumberTextField.text.length < 10 || _phoneNumberTextField.text.length > 13)
		{
			[self presentAlertForErrorMessage:@"Please include a valid phone number"];
			return false;
		}
	}
	
	NSUInteger passwordLength = _passwordTextField.text ? [_passwordTextField.text length] : 0;
	
	if (passwordLength < 6 || passwordLength > 24)
	{
		[self presentAlertForErrorMessage:@"Password must be between 6 and 24 characters in length"];
		return false;
	}
	
	NSRegularExpression *emailValidationRegex = [[NSRegularExpression alloc] initWithPattern:@"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$" options:NSRegularExpressionCaseInsensitive error:nil];
	NSString *emailString = _emailTextField.text;
	if (!emailString ||
		![emailValidationRegex firstMatchInString:emailString options:0 range:NSMakeRange(0, emailString.length)])
	{
		[self presentAlertForErrorMessage:@"Please include a valid email address"];
		return false;
	}
	
	return true;
}

//MARK: Keyboard Notifications

- (void)keyboardWillShowEventNotification:(NSNotification *)notification {
	if (_keyboardAlreadyVisible) {
		return;
	}
	_keyboardAlreadyVisible = YES;
	
	[_keyboardEventViewAnimator
	 animateOnKeyboardNotification:notification
	 withViewToShowAboveKeyboard:_continueButton
	 keyboardPaddingConstant:5.0
	 animationDelay:0.0 animationCompletion:nil];
}

- (void)keyboardWillHideEventNotification:(NSNotification *)notification {
	_keyboardAlreadyVisible = NO;
	
	[_keyboardEventViewAnimator
	 animateOnKeyboardNotification:notification
	 withViewToShowAboveKeyboard:nil
	 keyboardPaddingConstant:0.0
	 animationDelay:0.0
	 animationCompletion:nil];
}

@end
