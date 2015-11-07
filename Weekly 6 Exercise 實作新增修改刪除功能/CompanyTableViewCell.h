//
//  CompanyTableViewCell.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/11/3.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyViewController.h"
@interface CompanyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *companyLogoImageView;
@property (strong, nonatomic) IBOutlet UITextField *companyBrandNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyCategoryTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyTagsTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyIntroTextField;
@property (strong, nonatomic) IBOutlet UITextView *companyIntroTextView;

@property (strong, nonatomic) UITextField *companyAddressTextField;

@end
