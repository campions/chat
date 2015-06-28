#import "loggedIn.h"
#import "DraggableViewBackground.h"
#import "CommentsViewController.h"
#import "CompanyDetails.h"
@interface loggedIn ()

@end

@implementation loggedIn

@synthesize companyArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame2 = CGRectMake(0, self.view.frame.size.height/11, self.view.frame.size.width, self.view.frame.size.height);
    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:frame2];
    [draggableBackground loadArray:companyArray];
//    [draggableBackground setParent:self];
    [self.view addSubview:draggableBackground];
    
    draggableBackground.messageButton = [[UIButton alloc]initWithFrame:CGRectMake(draggableBackground.frame.size.width - 35, 34, 18, 18)];
    [draggableBackground.messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
    [draggableBackground.messageButton addTarget:self action:@selector(goToChat) forControlEvents:UIControlEventTouchUpInside];
    [draggableBackground addSubview:draggableBackground.messageButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decrementStack) name:@"StackDecremented" object:nil];
}

- (IBAction)goToChat
{
    NSLog(@"Go to chat");
    
//    CommentsViewController *commentsView = [[CommentsViewController alloc] init];
//    commentsView.commentsArray = [[NSMutableArray alloc] initWithArray:companyArray];
////    commentsView.company = 
    [self performSegueWithIdentifier:@"comment" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"comment"])
    {
        CommentsViewController *commentsView = [segue destinationViewController];
        commentsView.commentsArray = [[NSMutableArray alloc] initWithArray:companyArray];
        commentsView.company = [[CompanyDetails alloc] init];
        commentsView.company = [companyArray objectAtIndex:0];
    }
}

- (void)decrementStack
{
    [companyArray removeObjectAtIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
