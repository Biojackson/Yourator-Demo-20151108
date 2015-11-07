//
//  JobViewController.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
@interface JobViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager ;
@property (strong, nonatomic) NSDictionary* youratorJobDic;
@property (strong, nonatomic) NSArray* youratorJobArray;


@end
