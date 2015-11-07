//
//  ProfileViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/11/2.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyProfileTableViewCell.h"
#import "MyProfileEditTableViewController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKMessageDialog.h>
#import <AFNetworking/AFNetworking.h>

@interface ProfileViewController () < UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate> {
    NSUserDefaults *userDefault;
    NSDictionary * parameters;
    NSString *apiName;
}

@property (strong, nonatomic) UIImage* takePhotoImage;
@property (strong, nonatomic) NSDictionary* takePhotoAlbum;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit  target:self action:@selector(editButPressed:)];
    //style: UIBarButtonItemStylePlain
    
    UIBarButtonItem* cameraButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(cameraButPressed:)];
    
    self.navigationItem.rightBarButtonItems = @[editButton, cameraButton];
    
    [self getProfilefromJSON];
    
    
}

- (void) getProfilefromJSON {
    userDefault = [NSUserDefaults standardUserDefaults];
    NSString* getAuthToken = [userDefault objectForKey:@"auth_token"];
    NSString* getUserID = [userDefault objectForKey:@"user_id"];
    NSString* getUserFBID = [userDefault objectForKey:@"user_fb_uid"];
    NSLog(@"getUserID: %@, getUserFBID: %@, getAuthToken:%@",getUserID, getUserFBID, getAuthToken); //有印出來
    
    apiName = [NSString stringWithFormat:@"http://www.yourator.co/api/v1/users/%@", getUserFBID];
    NSLog(@"getAuthToken:%@", getAuthToken);
    parameters = @{@"auth_token": getAuthToken};
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:apiName parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %p", responseObject);
              NSLog(@"apiName  Success: %p", responseObject);
              
              _youratorProfileDic = responseObject;
              NSLog(@"_youratorProfileDic  Success: %@", _youratorProfileDic);
              
              _profileUserName.text = _youratorProfileDic[@"users"][@"data"][@"name"];
              _profileUserGender.text = _youratorProfileDic[@"users"][@"data"][@"sex"];
              _profileUserBday.text = _youratorProfileDic[@"users"][@"data"][@"birthday"];
              _profileUserMobile.text = _youratorProfileDic[@"users"][@"data"][@"phone"];
              _profileUserEmail.text = _youratorProfileDic[@"users"][@"data"][@"email"];
              _profileUserAddress.text = _youratorProfileDic[@"users"][@"data"][@"address"];
              _profileUserSummary.text = _youratorProfileDic[@"users"][@"data"][@"summary"];
              
              //最後來處理1個pic: fbImage
              NSString *profileFBImageStr = _youratorProfileDic[@"users"][@"data"][@"fb_image"];
              NSLog(@"profileFBImageStr %@", profileFBImageStr);
              NSURL *profileFBImageURL = [NSURL URLWithString: profileFBImageStr];
              NSURLRequest *urlRequestProfileFBImage = [NSURLRequest requestWithURL:profileFBImageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
              NSURLSessionDataTask *taskProfileFBImageURL = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequestProfileFBImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                {
                  if(data)
                  {
                      UIImage *image = [[UIImage alloc] initWithData:data]; dispatch_async(dispatch_get_main_queue(), ^{
                          _takePhotoImageView.image = image;
                          //這樣get跟之後update會不會conflict!!?
                      });
                  }
              }];
              [taskProfileFBImageURL resume];
 
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)cameraButPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    
    //    MyProfileTableViewCell* peterCell = sender.superview;
    //    while ([peterCell isKindOfClass:[MyProfileTableViewCell class]]) {
    //        peterCell = peterCell.superview;
    //    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSLog(@"info %p", info);
    _takePhotoImage = info[@"UIImagePickerControllerOriginalImage"];
    
    
    //把照片存到手機
    UIImageWriteToSavedPhotosAlbum(_takePhotoImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //把照片存到App
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    NSString *name = [NSString stringWithFormat:@"%f.jpg", interval];
    NSString *path = [documentsDirectory
                      stringByAppendingPathComponent:name];
    NSData *data = UIImageJPEGRepresentation(_takePhotoImage, 0.9);
    [data writeToFile:path atomically:YES];
    
    _takePhotoImageView.image = _takePhotoImage;
    
    //Johnny大大的方法
    //UIImage* newImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    [self postPhoto];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//把照片存到手機的method
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    if (!error) {
        NSLog(@"_takePhotoImage %p", _takePhotoImage);
    }
    else {
        NSLog(@"err %@", error);
    }
}

//把照片上傳到JSON的method
- (void) postPhoto {
    //FBSDKAccessToken* fbAccessToken = [FBSDKAccessToken currentAccessToken];
    
//    NSString *fbtokenforPostProfilePhoto = [userDefault objectForKey:@""];
    
    //NSString *token = [userDefault objectForKey:@"loginToken"];
    //NSString *userFBID = [userDefault objectForKey:@"userId"];

    //NSDictionary *parameters = @{@"photo":@"takeProfilePhoto", @"access_token": fbAccessToken.tokenString, @"access_uid":fbAccessToken.userID};
    //NSLog(@"token %@ + userID %@",fbAccessToken.tokenString, fbAccessToken.userID);
    
//    [manager POST:@"http://www.yourator.co/api/v1/companies" parameters:@{@"access_token":token,@"uid":userId} success:^(AFHTTPRequestOperation* operation, id responseObject) {
//        parameters:@{@"access_token":token,@"uid":uid}
//        
//        NSString *authToken = responseObject[@"auth_token"];
//        NSString *userId = responseObject[@"user_id"];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    NSString* getAuthToken = [userDefault objectForKey:@"auth_token"];
    NSString* getUserID = [userDefault objectForKey:@"user_id"];
    NSString* getUserFBID = [userDefault objectForKey:@"user_fb_uid"];
    NSLog(@"getUserID: %@, getUserFBID: %@, getAuthToken:%@",getUserID, getUserFBID, getAuthToken); //有印出來
    
        apiName = [NSString stringWithFormat:@"http://www.yourator.co/api/v1/users"];
    NSLog(@"getAuthToken:%@", getAuthToken);
    parameters = @{@"auth_token": getAuthToken, @"user_fb_uid":getUserFBID};
    //NSLog(@"parameters:%@", parameters);
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:apiName parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            UIImage *image = _takePhotoImage;
            
            CGSize size = CGSizeMake(300, image.size.height * 300 / image.size.width);
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            [image drawInRect:CGRectMake(0, 0, size.width,  size.height)];
            UIImage *resizeImage =  UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData *imageData = UIImageJPEGRepresentation(resizeImage, 0.5);
            
            [formData appendPartWithFileData:imageData name:@"photo" fileName:@"takeProfilePhoto.jpg"
                                    mimeType:@"image/jpg"];
        
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"apiName Success: %@", responseObject);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"apiName Error: %@", error);
    }];
}


-(void)editButPressed:(id)sender {
//    彩蛋在這裏
//    MyProfileEditTableViewController* myProfileEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileEditTVC"];
//    [self presentViewController:myProfileEditViewController animated:YES completion:nil];

    NSDictionary *profileUserUpdate =
        @{@"profileUserName":self.profileUserName.text,
          @"profileUserGender":self.profileUserGender.text,
          @"profileUserBday":self.profileUserBday.text,
          @"profileUserMobile":self.profileUserMobile.text,
          @"profileUserEmail":self.profileUserEmail.text,
          @"profileUserAddress":self.profileUserAddress.text,
          @"profileUserSummary":self.profileUserSummary.text,
          };
    
    userDefault = [NSUserDefaults standardUserDefaults];
    NSString* getAuthToken = [userDefault objectForKey:@"auth_token"];
    NSString* getUserID = [userDefault objectForKey:@"user_id"];
    NSString* getUserFBID = [userDefault objectForKey:@"user_fb_uid"];
    NSLog(@"getUserID: %@, getUserFBID: %@, getAuthToken:%@",getUserID, getUserFBID, getAuthToken); //有印出來
    
    parameters = @{@"auth_token": getAuthToken, @"user_fb_uid":getUserFBID, @"users":profileUserUpdate};
    //NSLog(@"parameters:%@", parameters);
    
    //這邊改用PATCH不用POST (for update更新)
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestSerializer *requestSerializer = [manager requestSerializer];
//    NSError *error = nil;

    [manager PATCH:apiName parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"PATCH apiName Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"FAILED");
    }];
}
    
    ///////
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:apiName parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
        
        
        
        
        
//        NSData *profileUserUpdateData = UIImageJPEGRepresentation(resizeImage, 0.5);
//        [formData appendPartWithFileData:imageData name:@"users" fileName:@"takeProfilePhoto.jpg"
//                                mimeType:@"image/jpg"];
        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"apiName Success: %@", responseObject);
// 
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"apiName Error: %@", error);
//    }];
//    [self resignFirstResponder];
    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"AddCoffee" object:nil
//     userInfo:dic];
//    [self.navigationController
//     popViewControllerAnimated:YES];


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
