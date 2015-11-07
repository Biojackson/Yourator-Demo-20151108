//
//  CompanyDetailTableViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "CompanyDetailTableViewController.h"
#import "CompanyDetailTableViewCell.h"
#import "CompanyMapAnnotation.h"
#import "Parse/Parse.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <XCDYouTubeKit/XCDYouTubeKit.h>

@interface CompanyDetailTableViewController () <MKMapViewDelegate, CLLocationManagerDelegate> {
    
    
    CLLocationManager *locationManager;
    
    BOOL isFirstGetLocation;
    
    CLGeocoder* geoCoder;
    
    NSString* companyAddress;
    
    CompanyMapAnnotation *annotation;
    
    CLPlacemark *placeMark;
    
    NSString *videoIdentifier;
    
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
}


@end

@implementation CompanyDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    UIBarButtonItem* saveButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButPressed)];
    
    self.navigationItem.rightBarButtonItems = @[saveButton];
    
    //AFNetworking
    NSURL *youratorURL = [NSURL URLWithString:@"http://www.yourator.co/"];
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:youratorURL];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];

    // Initialization code
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    
    //    isFirstGetLocation = NO;
    
    geoCoder = [[CLGeocoder alloc]init];
    
    
    //[self.tableView reloadData];//強者密技！！！
}

- (void)saveButPressed {

}

- (void)getData:(id)sender {
    
    NSLog(@"get CompanyDetail data");
    
    //@"/api/v1/companies/1"的 “1” 應該要改成變數!!
    [_manager GET:@"/api/v1/companies/1" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %p", responseObject);//有印出
              _youratorCompanyDetailDic = responseObject;
              NSLog(@"JSON_youratorCompanyDetailDic: %p", _youratorCompanyDetailDic);//有印出
              
              videoIdentifier = _youratorCompanyDetailDic[@"yourator"][@"data"][@"video"];
              
              videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoIdentifier];

              
              [self.tableView reloadData];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if(isFirstGetLocation == NO) {
        isFirstGetLocation = YES;
        
        MKCoordinateRegion region ;
        region.center = userLocation.location.coordinate;
        MKCoordinateSpan mapSpan;
        mapSpan.latitudeDelta = 0.1;
        mapSpan.longitudeDelta = 0.1;
        region.span = mapSpan;
        mapView.region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000, 1000);
        [mapView setRegion:region animated:YES];
        //        mapSpan.latitudeDelta = ABS(coordinate101.latitude-userLocation.location.coordinate.latitude)*2.1;
        //        mapSpan.longitudeDelta = ABS(coordinate101.longitude-userLocation.location.coordinate.longitude)*2.1;
        //        region.span = mapSpan;
    }
    
}

//有接地址轉座標
-(void)getCoordinateFromAddress {
    
    companyAddress = _youratorCompanyDetailDic[@"yourator"][@"data"][@"address"];

    [geoCoder geocodeAddressString: companyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil && placemarks.count > 0)
        {
            placeMark = placemarks[0];
            //NSLog(@"location %@", placeMark.location);//每3-5秒印有點煩
            [self addAnnotation];
            [self.tableView reloadData];//must reload bcoz it's a slow block which execte after cell~!!!!//強者密技！！！
        }
        //
    }];
}
//
//- (void) getDistanceFromMap { //有時間再來弄距離
//
//    //第一個座標
//    CLLocation *current=[[CLLocation alloc] initWithLatitude:32.178722 longitude:119.508619];
//    //第二個座標
//    CLLocation *before=[[CLLocation alloc] initWithLatitude:32.206340 longitude:119.425600];
//    // 計算距離
//    CLLocationDistance meters=[current distanceFromLocation:before];
//}

- (void)addAnnotation {
    
    CLLocationCoordinate2D coordinate101 = CLLocationCoordinate2DMake(placeMark.location.coordinate.latitude, placeMark.location.coordinate.longitude);
    //NSLog(@"%f,%f", placeMark.location.coordinate.latitude, placeMark.location.coordinate.longitude);//每3-5秒印有點煩 why?
    annotation = [[CompanyMapAnnotation alloc] initWithCoordinate:coordinate101 title:@("本公司所在") subtitle:companyAddress];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSLog(@"_youratorCompanyDetailDic: %p",_youratorCompanyDetailDic);
    
    //[self performSelector:@selector(getData:) withObject:nil afterDelay:0];
    
    //[self performSelector:@selector(noIdeaHowToGetJSON:) withObject:nil afterDelay:0];//不用這個看看行嗎？
    //[self.tableView reloadData];

    [self getData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //找機會改成動態連結
    
    /*
    if (videoPlayerViewController == nil) {
        return 0;
    }
    else {
        return 1;
    }
    */
    
    return 1;
    
 }

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"COMPANYDETAIL_CELL_ID"];
    
    
    
    NSLog(@"companyTableViewCell %@", cell);
    
 
    cell.companyBrandNameTextField.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"brand"];
    cell.companyCategoyTextField.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"company_category"];
    
    //tags 我必須要固定設定兩個以上!!!!
    NSString* companyTags = @"";
    if ((!(_youratorCompanyDetailDic[@"yourator"][@"data"][@"company_tags"][0][@"name"]==nil))&&(!(_youratorCompanyDetailDic[@"yourator"][@"data"][@"company_tags"][1][@"name"]==nil))) {
        companyTags = [NSString stringWithFormat:@"%@, %@", _youratorCompanyDetailDic[@"yourator"][@"data"][@"company_tags"][0][@"name"], _youratorCompanyDetailDic[@"yourator"][@"data"][@"company_tags"][1][@"name"]];
    }
    NSLog(@"companyTags %@",companyTags);
    cell.companyTagsTextField.text = companyTags;
    cell.companyWebsiteTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"web"];
    cell.companyFacebookTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"fb"];
    cell.companyAppTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"iOS"];
    cell.companyIntroTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"about"];
    cell.companyVisionTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"idea"];
    cell.companyStoryTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"story"];
    cell.companyWelfareTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"welfare"];
    
    //最後來處理2個pic: logo and banner
    NSString *companyLogoStr = _youratorCompanyDetailDic[@"yourator"][@"data"][@"logo"];
    NSLog(@"companyLogoStr %@", companyLogoStr);
    NSURL *companyLogoURL = [NSURL URLWithString: companyLogoStr];
    NSURLRequest *urlRequestLogo = [NSURLRequest requestWithURL:companyLogoURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLSessionDataTask *taskLogo = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequestLogo completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            if(data)
            {
                UIImage *image = [[UIImage alloc] initWithData:data]; dispatch_async(dispatch_get_main_queue(), ^{
                        cell.companyLogoImageView.image = image;
                        });
            }
        }];
    NSString *companyPhotoStr = _youratorCompanyDetailDic[@"yourator"][@"data"][@"banners"][0][@"banner"];
    NSLog(@"companyBannerStr %@", companyPhotoStr);
    NSURL *companyPhotoURL = [NSURL URLWithString: companyPhotoStr];
    NSURLRequest *urlRequestPhoto = [NSURLRequest requestWithURL:companyPhotoURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    
    NSURLSessionDataTask *taskPhoto = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequestPhoto completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            if(data)
            {
                UIImage *image = [[UIImage alloc] initWithData:data]; dispatch_async(dispatch_get_main_queue(), ^{
                    cell.companyPhotoImageView.image = image;
                });
            }
        }];
    [taskLogo resume];
    [taskPhoto resume];

    //Map
    [self getCoordinateFromAddress];
    [cell.companyMapView addAnnotation:annotation];
    
    //youtube play!!!
    //[videoPlayerViewController presentInView:cell.companyYoutubeView];
    
    //[videoPlayerViewController.moviePlayer play];//comment掉就不會直接播放了，可是好像大家比較愛直接來
 
    
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
