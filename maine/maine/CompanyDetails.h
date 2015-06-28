//
//  CompanyDetails.h
//  maine
//
//  Created by Razvan Balint on 4/29/15.
//  Copyright (c) 2015 Laborator iOS Cronian Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDetails : NSObject

@property (strong, nonatomic) NSString *companyID;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *companyCity;
@property (strong, nonatomic) NSString *plus;
@property (strong, nonatomic) NSString *minus;
@property (strong, nonatomic) NSMutableArray *comments;

- (void)updateComments:(NSArray*)newComments;

@end
