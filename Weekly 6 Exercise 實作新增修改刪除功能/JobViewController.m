//
//  JobViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "JobViewController.h"
#import "JobTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "JobDetailTableViewController.h"

@interface JobViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* arrayOfNumberOfRowsInSectionByJSONDictJob;
@property (strong, nonatomic) NSString* urlStr;

@end

@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* searchButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch  target:self action:@selector(searchButPressed)];
    
    self.navigationItem.rightBarButtonItems = @[searchButton];
    
    //AFNetworking
    NSURL *youratorURL = [NSURL URLWithString:@"http://www.yourator.co/"];
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:youratorURL];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.tableView reloadData];
}

-(void)searchButPressed { //有時間回來做啊!!!
    
    //    UIViewController* CompanyAddViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyAddVC"];
    //    [self presentViewController:CompanyAddViewController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [self performSelector:@selector(getData:) withObject:nil afterDelay:0];
    NSLog(@"YouratorJob %@",_youratorJobDic);//沒有印出來，都是null，但是最早印，為什麼沒有印出來啊～～～～～！！！！！
    
    //[self performSelector:@selector(noIdeaHowToGetJSON:) withObject:nil afterDelay:0];//不用這個也行喔
}

- (void)getData:(id)sender {
    NSLog(@"get data");//有印出來，但是很晚
    [_manager GET:@"/api/v1/jobs" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              _youratorJobDic = responseObject;
              NSLog(@"_youratorJobDic %@",_youratorJobDic);//有印出來，但是很晚
              [self.tableView reloadData];//有用嗎？？？
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    _arrayOfNumberOfRowsInSectionByJSONDictJob = _youratorJobDic[@"jobs"][@"data"];
    return _arrayOfNumberOfRowsInSectionByJSONDictJob.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JOB_CELL_ID" forIndexPath:indexPath];
    
    NSLog(@"jobTableViewCell");
    cell.jobNameTextField.text = _youratorJobDic[@"jobs"][@"data"][indexPath.row][@"name"];
    cell.jobCategoryTextField.text = _youratorJobDic[@"jobs"][@"data"][indexPath.row][@"job_category"];
    //數字轉文字string
    NSString* jobEyeCount = [NSString stringWithFormat:@"%@",_youratorJobDic[@"jobs"][@"data"][indexPath.row][@"views_count"]];
    cell.jobEyeCountTextField.text = jobEyeCount;
    NSString* jobSalaryHigh = [NSString stringWithFormat:@"%@",_youratorJobDic[@"jobs"][@"data"][indexPath.row][@"salary_ceiling"]];
    cell.jobSalaryHighTextField.text = jobSalaryHigh;
    NSString* jobSalaryLow = [NSString stringWithFormat:@"%@",_youratorJobDic[@"jobs"][@"data"][indexPath.row][@"salary_floor"]];
    
    //判斷薪水是否為空值(面議)
    if (_youratorJobDic[@"jobs"][@"data"][indexPath.row][@"salary_floor"] == nil) {
        cell.jobSalaryLowTextField.text = @" ";
    }
    else {
        cell.jobSalaryLowTextField.text = jobSalaryLow;
    }
    
    if (_youratorJobDic[@"jobs"][@"data"][indexPath.row][@"salary_ceiling"] == nil) {
        cell.jobSalaryHighTextField.text = @"薪資面議";
    }
    else {
        cell.jobSalaryHighTextField.text = jobSalaryHigh;
    }
//    if ((cell.jobSalaryHighTextField.text == nil)||(cell.jobSalaryLowTextField.text == nil)) {
//        cell.jobSalaryLowTextField.text = @"";
//        cell.jobSalaryHighTextField.text = @"薪資面議";
//    }
    
    
    
    cell.jobStatusTextField.text = _youratorJobDic[@"jobs"][@"data"][indexPath.row][@"status"];
    //modify status
    if ((cell.jobStatusTextField.text = @"career_begin")) {
        cell.jobStatusTextField.text = @"徵才中";
    }
    
    cell.jobPostDateTextField.text = _youratorJobDic[@"jobs"][@"data"][indexPath.row][@"published_on"];

    NSString* jobTags = [NSString stringWithFormat:@"%@, %@", _youratorJobDic[@"jobs"][@"data"][indexPath.row][@"tags"][0][@"name"], _youratorJobDic[@"jobs"][@"data"][indexPath.row][@"tags"][1][@"name"]];
    NSLog(@"companyTags %@",jobTags);
    cell.jobTagsTextField.text = jobTags;
    
    
    NSString *urlJSONJobBannerStr = _youratorJobDic[@"jobs"][@"data"][indexPath.row][@"banner"];
    NSLog(@"urlJSONPhotoStr %@", urlJSONJobBannerStr);
    NSURL *url = [NSURL URLWithString: urlJSONJobBannerStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            if(data)
            {
                UIImage *image = [[UIImage alloc] initWithData:data]; dispatch_async(dispatch_get_main_queue(), ^{
                    cell.jobImageView.image = image;
                });
            }
    }];
    [task resume];

//    //NSLog(@"Cell name111 %@", _youratorCompanyDic);
//    NSLog(@"Cell name222 %@", _youratorCompanyDic[@"yourator"][@"data"][0][@"name"]);
//
//    [cell.nameTextField setText:_youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"name"]];
//    [cell.createdAtTextField setText: _youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"created_at"]];
//    
//    cell.youratorDataID = [[NSString alloc] initWithFormat:@"%@",_youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"id"]];
//    [cell.companyJobsTextField setText: cell.youratorDataID];
//
//    NSString *urlJSONPhotoStr = (@"company logo %@", _youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"logo"]);
//    NSLog(@"urlJSONPhotoStr %@", urlJSONPhotoStr);
//    NSURL *url = [NSURL URLWithString: urlJSONPhotoStr];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
//    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
//                {
//                    if(data)
//                    {
//                        UIImage *image = [[UIImage alloc] initWithData:data];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            cell.jobImageView.image = image;
//                        }); }
//                }];
//    [task resume];
    return cell;
}


@end

//    [_manager POST:@"http://www.yourator.co//api/v1/companies" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    UIImage *image = [UIImage imageNamed:@"test"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    //[formData appendPartWithFormData:imageData name:@"photo"];
//    [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.png"
//                            mimeType:@"image/png"];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"Success: %@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//    }];


//- (void)noIdeaHowToGetJSON:(id)sender {
//
//    //建立一個NSURL物件
//    NSURL *url = [NSURL URLWithString:@"http://www.yourator.co/api/v1/companies"];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    //取得網路上的資料
//    NSURLSessionDataTask* task1ForWeb = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data1, NSURLResponse * _Nullable response1, NSError * _Nullable error1) {
//        if (data1) {
//            NSString* dataStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
//            NSLog(@"dataStr %p", dataStr);
//        }
//    }];
//    //怎樣讀JSON呢～～？
//    NSURLSessionDataTask* task2ForJSON = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
//        if (data2) {
//            NSLog(@"JSON1");
//            NSError* jsonError;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:&jsonError];
//            if(jsonError == nil) {
//                NSLog(@"JSON2");
//                //NSArray *array = dic[@"name"];
//
//                NSLog(@"name %@", dic[@"yourator"][@"data"][0][@"name"]);
//                //for(NSDictionary *appDic in array) {
//                    //NSLog(@"name %@", appDic[@"yourator"][@"data"][0][@"name"]);
//
//                    //NSLog(@"name %@", appDic[@"yourator"][@"data"][0][@"name"]);
//                //}
//            }
//        }
//    }];
//    [task1ForWeb resume];
//    [task2ForJSON resume];
//}

//    NSURLSessionDataTask* task = [NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if(data) {
//            NSError *jsonError;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
//            if(jsonError == nil) {
//                NSArray *array = dic[@"results"];
//                for(NSDictionary *appDic in array) {
//                    NSLog(@"trackName %@", appDic[@"trackName"]);
//                }
//            }
//        }
//NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//利用<key,value>的方式取得Json資料
//    NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"first_name = %@",[jsonObj objectForKey:@"first_name"]);
//    NSLog(@"last_name = %@",[jsonObj objectForKey:@"last_name"]);


//- (void) getJSONPhoto:(id)sender {
//
//    _urlStr = @"%@,_youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"logo"]";
//
//
//}