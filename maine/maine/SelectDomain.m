//
//  SelectDomain.m
//  maine
//
//  Created by Razvan Balint on 4/29/15.
//  Copyright (c) 2015 Laborator iOS Cronian Academy. All rights reserved.
//

#import "SelectDomain.h"
#import "loggedIn.h"
#import "CompanyDetails.h"
#import "CustomTabBarController.h"

@interface SelectDomain ()

@property (strong, nonatomic) NSArray *domainsArray;
@property (strong, nonatomic) NSMutableArray *companiesArray;

@end

@implementation SelectDomain

@synthesize domainsArray;
@synthesize companiesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [header setText:@"Choose a domain"];
    [header setTextAlignment:NSTextAlignmentCenter];
    
    [self.tableView setTableHeaderView:header];
    
    domainsArray = [[NSArray alloc] initWithObjects:@"Internet / eCommerce", @"Software/Tehnologii", @"Comert", @"Farmaceutice", @"Cercetare", @"Consultanta", @"Transport", @"Servicii persoane / firme", @"Sanatate", @"Finante/Contabilitate", @"Automatizari industriale", @"Recrutare / Resurse umane", @"Imobiliare", @"Media / Comunicare", @"Educatie / Training", @"Serviciu clienti", @"Consultanta", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    return [domainsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [domainsArray objectAtIndex:indexPath.row];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSError *error = nil;
//    NSString *post = [NSString stringWithFormat:@"DOMAIN=%@", [domainsArray objectAtIndex:indexPath.row]];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"http://compvspred.byethost7.com/compvspred/php/cvp_get_company.php"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    NSURLResponse *response = nil;
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    if (error) {
//        NSLog(@"%s: NSURLConnection error: %@", __FUNCTION__, error);
//        [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
//        
//        // Try again
//    }
//    else {
//        NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        NSLog(@"RESPONSE STRING: %@",responseString);
//        
//        NSDictionary *dictionary = [[NSMutableDictionary alloc] init];
//        dictionary = [NSJSONSerialization JSONObjectWithData:returnData
//                                                     options:NSJSONReadingAllowFragments
//                                                       error:&error];
//        
//        companiesArray = [[NSMutableArray alloc] init];
//        for(NSDictionary *companyInfo in dictionary[@"user"]) {
//            CompanyDetails *temp = [[CompanyDetails alloc] init];
//            [temp setCompanyID:companyInfo[@"ID"]];
//            [temp setCompanyName:companyInfo[@"NAME"]];
//            [temp setCompanyCity:companyInfo[@"CITY"]];
//            [temp setPlus:companyInfo[@"RPLUS"]];
//            [temp setMinus:companyInfo[@"RMINUS"]];
//            
//            if([temp.plus class] == [NSNull class] || temp.plus == nil) {
//                [temp setPlus:@"0"];
//            }
//            
//            if([temp.minus class] == [NSNull class] || temp.minus == nil) {
//                [temp setMinus:@"0"];
//            }
//            
//            if([temp.companyName class] != [NSNull class] && [temp.companyCity class] != [NSNull class])
//                [companiesArray addObject:temp];
//        }
//        
//        
//        loggedIn *user = [[loggedIn alloc] init];
//        user.companyArray = [[NSMutableArray alloc] initWithArray:companiesArray];
//
//        [self addChildViewController:user];
//        user.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//        [self.view addSubview:user.view];
//        [self.tableView setScrollEnabled:NO];
//        [self didMoveToParentViewController:user];
//        
//        [self performSegueWithIdentifier:@"login" sender:self];
//        
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"login"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSError *error = nil;
        NSString *post = [NSString stringWithFormat:@"DOMAIN=%@", [domainsArray objectAtIndex:indexPath.row]];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://compvspred.byethost7.com/compvspred/php/cvp_get_company.php"]];
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
            
            companiesArray = [[NSMutableArray alloc] init];
            for(NSDictionary *companyInfo in dictionary[@"user"])
            {
                CompanyDetails *temp = [[CompanyDetails alloc] init];
                [temp setCompanyID:companyInfo[@"ID"]];
                [temp setCompanyName:companyInfo[@"NAME"]];
                [temp setCompanyCity:companyInfo[@"CITY"]];
                [temp setPlus:companyInfo[@"RPLUS"]];
                [temp setMinus:companyInfo[@"RMINUS"]];
                NSString *commentString = companyInfo[@"COMMENT"];
                if (commentString != (id)[NSNull null])
                    temp.comments = [[NSArray alloc] initWithArray:[commentString componentsSeparatedByString:@"#"]];
                else
                    temp.comments = [[NSArray alloc] init];
                
                if([temp.plus class] == [NSNull class] || temp.plus == nil) {
                    [temp setPlus:@"0"];
                }
                
                if([temp.minus class] == [NSNull class] || temp.minus == nil) {
                    [temp setMinus:@"0"];
                }
                
                if([temp.companyName class] != [NSNull class] && [temp.companyCity class] != [NSNull class])
                    [companiesArray addObject:temp];
            }
        }

        
        loggedIn *user = segue.destinationViewController;
        user.companyArray = [[NSMutableArray alloc] initWithArray:companiesArray];
    }
}

@end
