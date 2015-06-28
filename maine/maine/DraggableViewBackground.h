

#import <UIKit/UIKit.h>
#import "DraggableView.h"
#import "loggedIn.h"

@interface DraggableViewBackground : UIView <DraggableViewDelegate>
//methods called in DraggableView
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
- (void)loadArray:(NSMutableArray*)importCardLabels;

@property (retain,nonatomic)NSArray* exampleCardLabels; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray* allCards; //%%% the labels the cards
@property (retain,nonatomic)NSArray* exampleCardLabelsImages;
//@property (nonatomic) loggedIn *parent;

@property (strong, nonatomic) UILabel *nrMinus;
@property (strong, nonatomic) UILabel *nrPlus;
@property (strong, nonatomic) NSMutableArray *sendId;

@property (strong, nonatomic) UIButton* messageButton;;

@end
