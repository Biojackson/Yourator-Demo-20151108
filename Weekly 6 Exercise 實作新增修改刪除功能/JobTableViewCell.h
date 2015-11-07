//
//  JobTableViewCell.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/28.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface JobTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *jobImageView;
@property (strong, nonatomic) IBOutlet UITextField *jobNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobCategoryTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobEyeCountTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobSalaryLowTextField;
@property (strong, nonatomic) IBOutlet UILabel *signBtwSalaries;
@property (strong, nonatomic) IBOutlet UITextField *jobSalaryHighTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobStatusTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobPostDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobTagsTextField;
//
//@property (strong, nonatomic) NSMutableString* youratorDataID;
//@property (strong, nonatomic) NSMutableString* nameEditTextFeild;
//@property (strong, nonatomic) NSMutableString* createdAtEditTextFeild;
//@property (strong, nonatomic) NSMutableString* companyJobsEditTextFeild;


@end
