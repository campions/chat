//
//  CommentsViewController.h
//  maine
//
//  Created by Razvan Balint on 5/16/15.
//  Copyright (c) 2015 Laborator iOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyDetails.h"

@interface CommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) CompanyDetails *company;

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)sendMessage:(id)sender;

@end
