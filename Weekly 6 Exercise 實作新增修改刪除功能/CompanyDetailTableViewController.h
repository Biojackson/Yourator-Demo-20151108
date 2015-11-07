//
//  CompanyDetailTableViewController.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CompanyViewController.h"
#import "CompanyMapAnnotation.h"
#import "CompanyDetailTableViewCell.h"
#import <AFNetworking/AFNetworking.h>

@interface CompanyDetailTableViewController : UITableViewController <MKMapViewDelegate> {

    

}

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager ;
@property (strong, nonatomic) NSDictionary* youratorCompanyDetailDic;
@property (strong, nonatomic) NSArray* youratorCompanyDetailArray;

@end
