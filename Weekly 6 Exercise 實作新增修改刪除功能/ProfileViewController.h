//
//  ProfileViewController.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/11/2.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) NSDictionary* youratorProfileDic;
@property (strong, nonatomic) NSArray* youratorProfileDetailArray;


@property (strong, nonatomic) IBOutlet UIImageView *takePhotoImageView;

@property (strong, nonatomic) IBOutlet UITextField *profileUserName;
@property (strong, nonatomic) IBOutlet UITextField *profileUserGender;
@property (strong, nonatomic) IBOutlet UITextField *profileUserBday;
@property (strong, nonatomic) IBOutlet UITextView *profileUserMobile;
@property (strong, nonatomic) IBOutlet UITextView *profileUserEmail;
@property (strong, nonatomic) IBOutlet UITextView *profileUserAddress;
@property (strong, nonatomic) IBOutlet UITextView *profileUserSummary;

@end
