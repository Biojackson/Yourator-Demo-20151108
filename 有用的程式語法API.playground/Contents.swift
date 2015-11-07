//: Playground - noun: a place where people can play

import UIKit

//以下都是用Objective-C寫的
//用程式寫的Button，去連結下一頁
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    //loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    
    [loginButton addTarget:self
    action:@selector(FBLoginButPressed:)
    forControlEvents:UIControlEventTouchUpInside
    ];
}
    
- (void)FBLoginButPressed:(id)sender {
    UITabBarController* TabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        
        [self presentViewController:TabBarController animated:YES completion:nil];
        
    
        
        //    newViewController* tigerController = [[newViewController alloc] init];
        //    [self presentViewController:tigerController animated:YES completion:nil];
        }

- (void)didReceiveMemoryWarning {
            [super didReceiveMemoryWarning];
            // Dispose of any resources that can be recreated.
}




