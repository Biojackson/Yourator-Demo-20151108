//
//  JobTableViewCell.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/28.
//  Copyright © 2015年 洪駿之. All rights reserved.
//
#import "JobViewController.h"
#import "JobTableViewCell.h"
#import "JobDetailEditViewController.h"

@implementation JobTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.nameLabel = dic[@"yourator"][@"data"][0][@"name"];
}
//- (IBAction)jobPostJSONButPressed:(id)sender {

//    NSURL *youratorURL = [NSURL URLWithString:@"http://www.yourator.co/"];
//    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:youratorURL];
//    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    _postJSONParameters = @{@"id": @"8", @"name": @"BOOMBOOMBOOM", @"created_at": @"2015", @"company_jobs":@"007"};
//    
//    [_manager POST:@"/api/v1/companies" parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSLog(@"JSON: %@", responseObject);
//              _postJSONParameters = responseObject;
//              NSLog(@"postJSONParameters1 %@",_postJSONParameters);
//              //NSLog(@"postJSONParameters2 %@",_postJSONParameters[@"yourator"][@"data"][0][@"name"]);
//              
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"Error: %@", error);
//          }];
    
    
    
    
    //利用NSURLSessionUploadTask
//    NSURL* url = [NSURL URLWithString:@"http://www.yourator.co/api/v1/companies"];
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
//    urlRequest.HTTPMethod = @"POST";
//    [urlRequest setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
//    NSDictionary *dictionary = @{@"id": @"8", @"name": @"BOOMBOOMBOOM", @"created_at": @"2015", @"company_jobs":@"007"};
//    NSError *error = nil;
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
//                                                   options:kNilOptions error:&error];
//    NSURLSessionUploadTask *task = [[NSURLSession sharedSession] uploadTaskWithRequest:urlRequest fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if(error == nil) {
//                NSError *jsonError;
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
//                         if(dic && [dic[@"success"] intValue] == 1) {
//                                NSLog(@"成功");
//                            }
//                }
//    }];
//    [task resume];

    //JobDetailEditViewController* jobDetailEditVC = [jobDetailEditVC.storyboard instantiateInitialViewController:@"jobDetailEditViewController"];//無法換頁啊
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
