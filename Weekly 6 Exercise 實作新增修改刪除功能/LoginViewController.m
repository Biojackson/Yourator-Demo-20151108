//
//  LoginViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKMessageDialog.h>
#import <Parse/Parse.h>
#import <AFNetworking/AFNetworking.h>

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_youratorLogIn.titleLabel.font = [UIFont systemFontOfSize:48];//為什麼改不到沒有用!!
    _youratorLogIn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    FBSDKLoginButton *FBLoginButton = [[FBSDKLoginButton alloc] init];
    FBLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    CGRect frame = FBLoginButton.frame;
    frame.size = CGSizeMake(90, 35);
    FBLoginButton.frame = frame;//還是想用autolayout...
//    FBLoginButton.center = self.view.center;
    FBLoginButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/1.6);
    
    //FBLoginButton.backgroundColor = [UIColor greenColor];//按鍵顏色沒變化為什麼??!
    [self.view addSubview:FBLoginButton];
    [self.view bringSubviewToFront:FBLoginButton];
    
//    NSDictionary *views = @{@"firstView" : _youratorLogo, @"secondView" :_youratorLogIn, @"thirdView" : FBLoginButton};
//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[firstView(200)]-50-[secondView(100)]-50-[thirdView(100)]" options:0 metrics:0 views: views];
//    [self.view addConstraints:constraints];
    
//    NSDictionary *viewsDictionary1 = NSDictionaryOfVariableBindings(_youratorLogIn);
//    NSDictionary *viewsDictionary2 = NSDictionaryOfVariableBindings(FBLoginButton);
//    
//    [FBLoginButton addConstraints:[NSLayoutConstraint
//      constraintsWithVisualFormat:@"V:|-50-[blueView(100)]"
//                          options:0 metrics:nil
//                            views:viewsDictionary1]];
}

- (IBAction)FBMessageButPressed:(id)sender {
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
    //content可以隨便改，url改成string或是picture都可以
    
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
    [FBSDKMessageDialog showWithContent:content delegate:nil];
    //error reason: 'fb-messenger-api is missing from your Info.plist under LSApplicationQueriesSchemes and is required for iOS 9.0' 但是這是simulator上面才有的問題，直接用手機看就沒問題．

}

- (void)viewWillAppear:(BOOL)animated {

    //UIStoryboard *storyboard = self.window.UITabBarController.storyboard;
    
    UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
//        FBSDKAccessToken* fbAccessToken = [FBSDKAccessToken currentAccessToken];
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSDictionary *parameters = @{@"user_fb_uid": fbAccessToken.userID};
        
//        [manager POST:@"http://www.yourator.co/api/v1/users" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            _authToken = responseObject[@"auth_token"];
//            NSLog(@"auth_token Success: %@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"auth_token Error: %@", error);
//        }];
        
        [self presentViewController:tabBarController animated:YES completion:nil];
        //[self performSegueWithIdentifier:@"LoginSegue" sender:nil];
    }
    else {     }
    
    //判斷已登⼊入
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fbTokenChangeNoti:)
                                                 name:FBSDKAccessTokenDidChangeNotification object:nil];
    
    //得到個⼈人profile:利用API
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"name,id,picture,gender,birthday,email"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);
             
             FBSDKAccessToken* fbToken = [FBSDKAccessToken currentAccessToken];
             //FBSDKAccessToken* fbuid = [FBSDKAccessToken ];
             
             AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             NSDictionary *parameters = @{@"access_token": fbToken.tokenString, @"access_uid":fbToken.userID};
             
             [manager POST:@"http://www.yourator.co/api/v1/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Success: %@", responseObject);
                    _authToken = responseObject[@"auth_token"];
                    _userID = responseObject [@"user_id"];
                    _userFBID =responseObject [@"user_fb_uid"];
                    NSLog(@"auth_token Success: %@", _authToken);
                    NSLog(@"fbUserID:%@", _userID);
                 
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:_authToken forKey:@"auth_token"];
                    [userDefault setObject:_userID forKey:@"user_id"];
                    [userDefault setObject:_userFBID forKey:@"user_fb_uid"];
                    NSLog(@"userDefault setObject auth_token Success: %@, %@, %@", _authToken, _userID, _userFBID);
                    [userDefault synchronize];
                 
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
             
         } }];
    //得到⼤頭照:利⽤用API
//    NSString *path = [[FBSDKProfile currentProfile]
//                      imagePathForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(100, 100)];
//    NSString *urlStr = [NSString stringWithFormat:@"http://graph.facebook.com/%@", path ];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               if(data) {
//                                   UIImage *image = [[UIImage alloc] initWithData:data];
//                                   UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//                                   [self.view addSubview:imageView];
//                               } }];
    
    
//    NSURL *picURL = [[FBSDKProfile currentProfile] imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(100, 100)];
//    NSString *urlStr = [NSString stringWithFormat:@"http://graph.facebook.com/%@", picURL ];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [NSURLSessionDataTask dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               if(data) {
//                                   UIImage *image = [[UIImage alloc] initWithData:data];
//                                   UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//                                   [self.view addSubview:imageView];
//                               } }];
}


-(void)fbTokenChangeNoti:(NSNotification*)noti {
    if ([FBSDKAccessToken currentAccessToken]) {
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOGIN_CELL_ID"];
    return cell;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
