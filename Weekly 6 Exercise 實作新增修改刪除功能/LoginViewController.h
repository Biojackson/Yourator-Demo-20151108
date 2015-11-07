//
//  LoginViewController.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *youratorLogo;
@property (strong, nonatomic) IBOutlet UIButton *youratorLogIn;
@property (strong, nonatomic) NSString *authToken;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userFBID;
@end
