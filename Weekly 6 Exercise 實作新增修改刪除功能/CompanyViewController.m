//
//  CompanyViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "CompanyViewController.h"
#import "Parse/Parse.h"
#import "CompanyTableViewCell.h"
#import <AFNetworking/AFNetworking.h>

@interface CompanyViewController () <UITableViewDataSource, UITableViewDelegate> {
}

@property (strong, nonatomic) NSMutableArray* arrayOfNumberOfRowsInSectionByJSONDictCompany;

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"company view load");
    //style: UIBarButtonItemStylePlain
    
    
    UIBarButtonItem* searchButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch  target:self action:@selector(searchButPressed)];
 
    self.navigationItem.rightBarButtonItems = @[searchButton];
    
    //AFNetworking
    NSURL *youratorURL = [NSURL URLWithString:@"http://www.yourator.co/"];
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:youratorURL];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.tableView reloadData];
}

- (void)searchButPressed {//這邊不用:(id)sender
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"YouratorCompany %p",_youratorCompanyDic);
    
    [self performSelector:@selector(getData:) withObject:nil afterDelay:0];
    
    [self performSelector:@selector(noIdeaHowToGetJSON:) withObject:nil afterDelay:0];//後來發現只用上面的，這個不用也行
}

- (void)getData:(id)sender {
    
    NSLog(@"get data");
    [_manager GET:@"/api/v1/companies" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              _youratorCompanyDic = responseObject;
              [self.tableView reloadData];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)noIdeaHowToGetJSON:(id)sender {
    
    //建立一個NSURL物件
    NSURL *url = [NSURL URLWithString:@"http://www.yourator.co/api/v1/companies"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    //取得網路上的資料
    NSURLSessionDataTask* task1ForWeb = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data1, NSURLResponse * _Nullable response1, NSError * _Nullable error1) {
        if (data1) {
            NSString* dataStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            NSLog(@"dataStr %p", dataStr);
        }
    }];
    //怎樣讀JSON呢～～？
    NSURLSessionDataTask* task2ForJSON = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
        if (data2) {
            NSLog(@"JSON data2");
            NSError* jsonError;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:&jsonError];//沒用到這個dictionary??
            NSLog(@"dic %p", dic);
            if(jsonError == nil) {
                NSLog(@"jsonError == nil");
                //NSLog(@"name %@", dic[@"yourator"][@"data"][0][@"brand"]);
            }
        }
    }];
    
    [task1ForWeb resume];
    [task2ForJSON resume];
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
    
    _arrayOfNumberOfRowsInSectionByJSONDictCompany = _youratorCompanyDic[@"yourator"][@"data"];
    return _arrayOfNumberOfRowsInSectionByJSONDictCompany.count;

}

/*

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
     CompanyTableViewCell *viewCell = cell;
     //[viewCell.companyIntroTextView setContentOffset:CGPointZero];
    [viewCell.companyIntroTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    
}

*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"COMPANY_CELL_ID" forIndexPath:indexPath];
    
    NSLog(@"companyTableViewCell");
    cell.companyBrandNameTextField.text = _youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"brand"];
    cell.companyCategoryTextField.text = _youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"company_category"];
    
    NSString* companyTagsTextField = @"";
    if ((!(_youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"company_tags"][0][@"name"]==nil))&&(!(_youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"company_tags"][1][@"name"]==nil))) {
        companyTagsTextField = [NSString stringWithFormat:@"%@, %@", _youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"company_tags"][0][@"name"], _youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"company_tags"][1][@"name"]];
    }
    NSLog(@"companyTags %@",companyTagsTextField);
    cell.companyTagsTextField.text = companyTagsTextField;
    
    cell.companyIntroTextView.text = _youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"about"];
    
    
   
    
    NSString *urlJSONPhotoStr =  _youratorCompanyDic[@"yourator"][@"data"][indexPath.row][@"logo"];
    NSLog(@"urlJSONPhotoStr %@", urlJSONPhotoStr);
    NSURL *url = [NSURL URLWithString: urlJSONPhotoStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            if(data)
            {
              UIImage *image = [[UIImage alloc] initWithData:data]; dispatch_async(dispatch_get_main_queue(), ^{
                    cell.companyLogoImageView.image = image;
                  }); }
            }];
    [task resume];
    
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
