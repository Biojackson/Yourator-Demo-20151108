//
//  JobDetailTableViewController.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobViewController.h"
#import "JobDetailTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
@interface JobDetailTableViewController : UITableViewController

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager ;
@property (strong, nonatomic) NSDictionary* youratorJobDetailDic;
@property (strong, nonatomic) NSArray* youratorJobDetailArray;

@end
