
#import "DraggableViewBackground.h"
////#import "ChatController.h"
#import "loggedIn.h"
#import "CompanyDetails.h"
#import "CommentsViewController.h"

@interface DraggableViewBackground ()

@end

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* menuButton;
    
    UIButton* checkButton;
    UIButton* xButton;
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 220; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;
@synthesize exampleCardLabelsImages;//%%% all the cards
//@synthesize parent;
@synthesize nrPlus;
@synthesize nrMinus;
@synthesize sendId;
@synthesize messageButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
//        nrMinus = [[UILabel alloc] initWithFrame:CGRectMake(30, 350, 20, 20)];
        nrMinus = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/5 - 40, self.frame.size.height*0.7, 59, 59)];
        [self addSubview:nrMinus];
//        nrPlus = [[UILabel alloc] initWithFrame:CGRectMake(280, 350, 20, 20)];
        nrPlus = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.width/5 - 49, self.frame.size.height*0.7, 89, 59)];
        [self addSubview:nrPlus];
        sendId = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadArray:(NSMutableArray*)importCardLabels
{
    NSString *user = @"user";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![user isEqualToString:[defaults objectForKey:@"role"]]) {
        //Here will be the users!!!!!!!!!!!!!
        //        exampleCardLabels = [[NSArray alloc]initWithObjects:@"firstUser",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
        
        exampleCardLabels = [[NSArray alloc] initWithArray:importCardLabels];
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
        [self loadCards];
    } else {
        ///HERE WILL BE THE COMPANIES!!!!
        exampleCardLabels = [[NSArray alloc]initWithObjects:@"firstCompany",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
        [self loadCards];
    }
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];

//    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 330, 59, 59)];
    xButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/5, self.frame.size.height*0.7, 59, 59)];
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
//    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 330, 89, 59)];
    checkButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.width/5 - 89, self.frame.size.height*0.7, 89, 59)];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menuButton];
    [self addSubview:messageButton];
    [self addSubview:xButton];
    [self addSubview:checkButton];
}


//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    NSString *user = @"user";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2.5, CARD_WIDTH, CARD_HEIGHT)];
    draggableView.information.text = [[exampleCardLabels objectAtIndex:index] companyCity];
    draggableView.informationName.text = [[exampleCardLabels objectAtIndex:index] companyName];
    [sendId addObject:[[exampleCardLabels objectAtIndex:index] companyID]];
    if ([user isEqualToString:[defaults objectForKey:@"role"]]) {

        draggableView.information.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:[NSString stringWithFormat:@"image%ld", index+1]]]; //%%% placeholder for card-specific information
    }
    draggableView.delegate = self;
    
    
    [nrMinus setText:[[exampleCardLabels objectAtIndex:index] minus]];
    [nrMinus setTextAlignment:NSTextAlignmentCenter];
//    [self addSubview:nrMinus];
    
    
    [nrPlus setText:[[exampleCardLabels objectAtIndex:index] plus]];
    [nrPlus setTextAlignment:NSTextAlignmentCenter];
//    [self addSubview:nrPlus];
    
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([exampleCardLabels count] > 0) {
        NSInteger numLoadedCardsCap =(([exampleCardLabels count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[exampleCardLabels count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[exampleCardLabels count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
          
          
        }
    }
   }

//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
       // DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    [sendId removeObjectAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StackDecremented"
                                                        object:self];
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
       
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }else {
        xButton.hidden = YES;
        checkButton.hidden = YES;
    }
    
    [nrMinus setText:[NSString stringWithFormat:@"%d", [nrMinus.text intValue] + 1]];
    
    
//    NSError *error = nil;
//    NSString *post = [NSString stringWithFormat:@"RMINUS=%@", [sendId objectAtIndex:0]];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"http://compvspred.byethost7.com/compvspred/php/cvp_rminus.php"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
    
//    NSURLResponse *response = nil;
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

}


//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    [sendId removeObjectAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StackDecremented"
                                                        object:self];
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    } else {
        xButton.hidden = YES;
        checkButton.hidden = YES;
    }
//    else {
//        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"There are no more cards!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [error show];
//}

    [nrPlus setText:[NSString stringWithFormat:@"%d", [nrPlus.text intValue] + 1]];
    
//    NSError *error = nil;
//    NSString *post = [NSString stringWithFormat:@"RPLUS=%@", [sendId objectAtIndex:0]];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"http://compvspred.byethost7.com/compvspred/php/cvp_rplus.php"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
    
//    NSURLResponse *response = nil;
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}



//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

@end
