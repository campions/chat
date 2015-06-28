//
//  CommentsViewController.m
//  maine
//
//  Created by Razvan Balint on 5/16/15.
//  Copyright (c) 2015 Laborator iOS Cronian Academy. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

@synthesize tableview;
@synthesize commentsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
//    commentsArray = [[NSMutableArray alloc] initWithObjects:@"Comment1", @"Comment2", @"Comment3", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[commentsArray objectAtIndex:0] comments] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[[commentsArray objectAtIndex:0] comments] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rating"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Like", @"Dislike", nil];
    [alert show];
}

- (IBAction)sendMessage:(id)sender {
    
    NSString *commentString = @"";
    for (NSString *temp in [[commentsArray objectAtIndex:0] comments]) {
        commentString = [commentString stringByAppendingString:temp];
        commentString = [commentString stringByAppendingString:@"#"];
    }
    
    commentString = [commentString stringByAppendingString:_textField.text];
    _textField.text = @"";
    
    //  SERVER REQUEST
    NSError *error = nil;
    
    NSString *post = [NSString stringWithFormat:@"ID=%@&COMMENT=%@", _company.companyID, commentString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://compvspred.byethost7.com/compvspred/php/cvp_update_comment.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"%s: NSURLConnection error: %@", __FUNCTION__, error);
        
        // Try again
    }
    else {
        NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"RESPONSE STRING: %@",responseString);
        
        NSDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [NSJSONSerialization JSONObjectWithData:returnData
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
        
        NSString *tempComment = dictionary[@"COMMENT"];
        NSArray *tempArray = [[NSArray alloc] initWithArray:[tempComment componentsSeparatedByString:@"#"]];
        [[commentsArray objectAtIndex:0] updateComments:tempArray];
         [tableview reloadData];
    }
    
    [tableview reloadData];
}
@end
