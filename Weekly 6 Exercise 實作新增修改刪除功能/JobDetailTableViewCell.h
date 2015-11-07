//
//  JobDetailTableViewCell.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/29.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *jobDetailImageView;
@property (strong, nonatomic) IBOutlet UITextField *jobDetailNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobDetailOfficialNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobDetailEyeCountTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobDetailSalaryLowTextField;
@property (strong, nonatomic) IBOutlet UILabel *signBtwSalariesDetail;
@property (strong, nonatomic) IBOutlet UITextField *jobDetailSalaryHighTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobDetailStatusTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobDetailPostDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *jobDetailTagsTextField;
//

@property (strong, nonatomic) IBOutlet UILabel *jobDetailJobDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITextView *jobDetailJobDescriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *jobDetailJobRequirementLabel;
@property (strong, nonatomic) IBOutlet UITextView *jobDetailJobRequirementTextView;
@property (strong, nonatomic) IBOutlet UILabel *jobDetailJobWelfareLabel;
@property (strong, nonatomic) IBOutlet UITextView *jobDetailJobWelfareTextView;


@end
