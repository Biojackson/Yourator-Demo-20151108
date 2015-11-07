//
//  JobDetailTableViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//
#import "JobViewController.h"
#import "JobDetailTableViewController.h"
#import "JobDetailTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
@interface JobDetailTableViewController ()

@end

@implementation JobDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* bookMarksButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookMarksButPressed)];
    
    self.navigationItem.rightBarButtonItems = @[bookMarksButton];
    
    //AFNetworking
    NSURL *youratorURL = [NSURL URLWithString:@"http://www.yourator.co/"];
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:youratorURL];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
}

- (void)bookMarksButPressed {
    
}

- (void)getData:(id)sender {
    
    NSLog(@"get jobDetail data");
    
    //@"/api/v1/jobs/1"的 “1” 應該要改成變數!!
    [_manager GET:@"/api/v1/jobs/5" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %p", responseObject);//有印出
              _youratorJobDetailDic = responseObject;
              NSLog(@"JSON_youratorJobDetailDic: %p", _youratorJobDetailDic);//有印出
              [self.tableView reloadData];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}


- (IBAction)alertButPressed:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"確認寄出履歷?" message:@"請認真思考" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"YES：太好了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //if ([self respondsToSelector:@selector(whichOneToChoose)]){
        [self performSelector:@selector(actionSheetAfterAlertButPressed:) withObject:nil  afterDelay:0];
    }];
    
    UIAlertAction* maybeButton = [UIAlertAction actionWithTitle:@"Maybe：多多考慮是好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Nope：下一個會更好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alertController addAction:yesButton];
    [alertController addAction:maybeButton];
    [alertController addAction:noButton];
    
    [self presentViewController:alertController animated:YES completion:nil ];
}

//- (void) whichOneToChoose {}
- (void) actionSheetAfterAlertButPressed: (id) sender {
    
    UIAlertController* alertSheetController = [UIAlertController alertControllerWithTitle:@"恭喜，祝面試順利！" message:@"那要開始戀愛了!想跟以下哪位開始戀愛!?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* girl1Button = [UIAlertAction actionWithTitle:@"林可彤"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction* girl2Button = [UIAlertAction actionWithTitle:@"徐嬌"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //無法在裡面放照片
        UIImage* image = [UIImage imageNamed:@"徐嬌png"];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:imageView];
    }];
    
    UIAlertAction* girl3Button = [UIAlertAction actionWithTitle:@"尤緻妍"  style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction* noGirlButton = [UIAlertAction actionWithTitle:@"我都不想要"  style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alertSheetController addAction:girl1Button];
    [alertSheetController addAction:girl2Button];
    [alertSheetController addAction:girl3Button];
    [alertSheetController addAction:noGirlButton];
    
    //alertSheetController.view.tintColor = [UIColor redColor];
    [self presentViewController:alertSheetController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"_youratorJobDetailDic: %p",_youratorJobDetailDic);

    [self performSelector:@selector(getData:) withObject:nil afterDelay:0];
    //[self performSelector:@selector(noIdeaHowToGetJSON:) withObject:nil afterDelay:0];//不用這個OK
    
    //[self.tableView reloadData];//其實不用這個，就已經可以跟後台同步upadte接他的即時資料
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   //找機會改成動態連結
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JOBDETAIL_CELL_ID"];
    
    NSLog(@"jobTableViewCell");
    
    cell.jobDetailNameTextField.text = _youratorJobDetailDic[@"jobs"][@"data"][@"name"];
    cell.jobDetailOfficialNameTextField.text = _youratorJobDetailDic[@"jobs"][@"data"][@"company_name"];
    //數字轉文字string
    NSString* jobDetailEyeCount = [NSString stringWithFormat:@"%@",_youratorJobDetailDic[@"jobs"][@"data"][@"views_count"]];
    cell.jobDetailEyeCountTextField.text = jobDetailEyeCount;
    NSString* jobDetailSalaryLow = [NSString stringWithFormat:@"%@",_youratorJobDetailDic[@"jobs"][@"data"][@"salary_floor"]];
    cell.jobDetailSalaryLowTextField.text = jobDetailSalaryLow;
    NSString* jobDetailSalaryHigh = [NSString stringWithFormat:@"%@",_youratorJobDetailDic[@"jobs"][@"data"][@"salary_ceiling"]];
    cell.jobDetailSalaryHighTextField.text = jobDetailSalaryHigh;
    cell.jobDetailStatusTextField.text = @"徵才中";//JSON沒這個項目~!!!
    cell.jobDetailJobDescriptionTextView.text = _youratorJobDetailDic[@"jobs"][@"data"][@"content"];
    cell.jobDetailPostDateTextField.text = _youratorJobDetailDic[@"jobs"][@"data"][@"published_on"];
    cell.jobDetailJobRequirementTextView.text = _youratorJobDetailDic[@"jobs"][@"data"][@"skill"];
    cell.jobDetailJobWelfareTextView.text = _youratorJobDetailDic[@"jobs"][@"data"][@"company_welfare"];

    //tags 我必須要固定設定兩個以上!!!!
    NSString* jobDetailTags = @"";
    if ((!(_youratorJobDetailDic[@"jobs"][@"data"][@"tags"][0][@"name"]==nil))&&(!(_youratorJobDetailDic[@"jobs"][@"data"][@"tags"][1][@"name"]==nil))) {
        jobDetailTags = [NSString stringWithFormat:@"%@, %@", _youratorJobDetailDic[@"jobs"][@"data"][@"tags"][0][@"name"], _youratorJobDetailDic[@"jobs"][@"data"][@"tags"][1][@"name"]];
    }
    NSLog(@"jobDetailTags %@",jobDetailTags);
    cell.jobDetailTagsTextField.text = jobDetailTags;
        
    //最後來處理1個pic: logo
    NSString *jobDetailLogoStr = _youratorJobDetailDic[@"jobs"][@"data"][@"company_logo"];
    NSLog(@"jobDetailLogoStr %@", jobDetailLogoStr);
    NSURL *jobDetailLogoURL = [NSURL URLWithString: jobDetailLogoStr];
    NSURLRequest *urlRequestJobDetailLogo = [NSURLRequest requestWithURL:jobDetailLogoURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLSessionDataTask *taskjobDetailLogo = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequestJobDetailLogo completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            if(data)
            {
                UIImage *image = [[UIImage alloc] initWithData:data]; dispatch_async(dispatch_get_main_queue(), ^{
                cell.jobDetailImageView.image = image;
            });
        }
    }];
    
    [taskjobDetailLogo resume];

    
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
