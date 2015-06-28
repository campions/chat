#import "LoginUserViewController.h"

@interface LoginUserViewController () <UITextFieldDelegate>

@end

@implementation LoginUserViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //create instance of NSUSerDefaults
  
    //if statement to check if there is a registered user or not
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
        _loginBtn.hidden = YES; //hide login button because no user is regsitered
    }
    else {
        NSLog(@"user is registered");
        _reEnterPasswordField.hidden = YES;
        _registerBtn.hidden = YES;
        _roleField.hidden = YES;
        _emailField.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    
    //check if all text fields are completed
    if ([_usernameField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""] || [_roleField.text isEqualToString:@""]|| [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //check that the two apssword fields are identical
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        NSLog(@"passwords match!");
        
        [self registerNewUser];
    }
    else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    
}

- (void) registerNewUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //write the username and password and set BOOL value in NSUserDefaults
    [defaults setObject:_usernameField.text forKey:@"username"];
    [defaults setObject:_passwordField.text forKey:@"password"];
    [defaults setObject:_emailField.text forKey:@"email"];
    [defaults setObject:_roleField.text forKey:@"role"];
    [defaults setBool:YES forKey:@"registered"];
    
   

    [defaults synchronize];

    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"domains" sender:self];
}

- (IBAction)LoginUser:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //check that username and password match stored values
    if ([_usernameField.text isEqualToString:[defaults objectForKey:@"username"]] && [_passwordField.text isEqualToString:[defaults objectForKey:@"password"]]) {
        _usernameField.text = nil;
        _passwordField.text = nil;
        [self performSegueWithIdentifier:@"domains" sender:self]; //perform segue to next view controller
    }
    else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your username and password does not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
