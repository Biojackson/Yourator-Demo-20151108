//
//  CompanyDetailScrollViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/11/7.
//  Copyright © 2015年 洪駿之. All rights reserved.
//
#import "CompanyViewController.h"
#import "CompanyDetailScrollViewController.h"
#import "CompanyMapAnnotation.h"
#import "Parse/Parse.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <XCDYouTubeKit/XCDYouTubeKit.h>
@interface CompanyDetailScrollViewController () <MKMapViewDelegate, CLLocationManagerDelegate> {
    
    
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

@implementation CompanyDetailScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //self.companyDetailScrollView.contentSize = CGSizeMake(320*1, 1500*1);//看起來很棒但是不work!!??

    //_contentViewWidthContraint.constant = self.view.bounds.size.width;//看起來很棒但是不work!!??

//
//    UIBarButtonItem* saveButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButPressed)];
//    
//    self.navigationItem.rightBarButtonItems = @[saveButton];
//
//    
    [self getData:nil];


    //youtube
    [self playYouTube];
    
    //MAP!!
    [self addAnnotation];//很重要~!!執行code~!
    //[self getCoordinateFromAddress];

    
    //[self.tableView reloadData];//強者密技！！！
    //[self.view setNeedsDisplay];
}

- (void)saveButPressed {
    
    
//    
//    //Map
//    [self getCoordinateFromAddress];
    
//
//    

}

- (void)getData:(id)sender {
    
    NSLog(@"get CompanyDetail data");
    //AFNetworking
    NSURL *youratorURL = [NSURL URLWithString:@"http://www.yourator.co/"];
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:youratorURL];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
/****/    //@"/api/v1/companies/1"的 “1” 應該要改成變數!!
    
    [_manager GET:@"/api/v1/companies/1" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %p", responseObject);//有印出
              _youratorCompanyDetailDic = responseObject;
              NSLog(@"JSON_youratorCompanyDetailDic: %p", _youratorCompanyDetailDic);//有印出了!!!
              
              _companyBrandNameTextField.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"brand"];
              _companyCategoyTextField.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"company_category"];
              
              //tags 我必須要固定設定兩個以上!!!!
              NSString* companyTags = @"";
              if ((!(_youratorCompanyDetailDic[@"yourator"][@"data"][@"company_tags"][0][@"name"]==nil))&&(!(_youratorCompanyDetailDic[@"yourator"][@"data"][@"company_tags"][1][@"name"]==nil))) {
                  companyTags = [NSString stringWithFormat:@"%@, %@", _youratorCompanyDetailDic[@"yourator"][@"data"][@"company_tags"][0][@"name"], _youratorCompanyDetailDic[@"yourator"][@"data"][@"company_tags"][1][@"name"]];
              }
              NSLog(@"companyTags %@",companyTags);
              _companyTagsTextField.text = companyTags;
              _companyWebsiteTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"web"];
              _companyFacebookTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"fb"];
              _companyAppTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"iOS"];
              _companyIntroTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"about"];
              _companyVisionTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"idea"];
              _companyStoryTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"story"];
              _companyWelfareTextView.text = _youratorCompanyDetailDic[@"yourator"][@"data"][@"welfare"];
              
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
                                                            _companyLogoImageView.image = image;
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
                                                             _companyPhotoImageView.image = image;
                                                         });
                                                     }
                                                 }];
              [taskLogo resume];
              [taskPhoto resume];

              
              //[self reloadData];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    // Initialization code
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    
    //    isFirstGetLocation = NO;
    
    geoCoder = [[CLGeocoder alloc]init];
    
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
    //@"台北市文山區興隆路一段251巷3弄9號";//_youratorCompanyDetailDic[@"yourator"][@"data"][@"address"];
    
    [geoCoder geocodeAddressString: companyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil && placemarks.count > 0)
        {
            placeMark = placemarks[0];
            //NSLog(@"location %@", placeMark.location);//每3-5秒印有點煩
            [self addAnnotation];
            //[self.tableView reloadData];//must reload bcoz it's a slow block which execte after cell~!!!!//強者密技！！！
        }
        //
    }];
        NSLog(@"companyAddress %@", companyAddress);
}


- (void)addAnnotation {
    [self getCoordinateFromAddress];
    CLLocationCoordinate2D coordinate101 = CLLocationCoordinate2DMake(placeMark.location.coordinate.latitude, placeMark.location.coordinate.longitude);
    //25.033408, 121.564099); //
    //NSLog(@"%f,%f", placeMark.location.coordinate.latitude, placeMark.location.coordinate.longitude);//每3-5秒印有點煩 why?
    
    annotation = [[CompanyMapAnnotation alloc] initWithCoordinate:coordinate101 title:@("本公司所在") subtitle:companyAddress];
    [_companyMapView addAnnotation:annotation];//很重要~!!執行code~!
}

//
////- (void) getDistanceFromMap { //有時間再來弄距離
////
////    //第一個座標
////    CLLocation *current=[[CLLocation alloc] initWithLatitude:32.178722 longitude:119.508619];
////    //第二個座標
////    CLLocation *before=[[CLLocation alloc] initWithLatitude:32.206340 longitude:119.425600];
////    // 計算距離
////    CLLocationDistance meters=[current distanceFromLocation:before];
////}

- (void)viewWillAppear:(BOOL)animated {
    
    //[super viewWillAppear:animated];
    
    NSLog(@"_youratorCompanyDetailDic: %p",_youratorCompanyDetailDic);//沒印出來~!!~!!~!~!~!不管它了
}

- (void) playYouTube {
    
    //偷塞youtube在這裡面
    videoIdentifier = @"DNWs6BJPD6w";//_youratorCompanyDetailDic[@"yourator"][@"data"][@"video"];
    NSLog(@"videoIdentifier %@", videoIdentifier);
    videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoIdentifier];
    
    //youtube play!!!
    [videoPlayerViewController presentInView:_companyYoutubeView];
    
    [videoPlayerViewController.moviePlayer play];//comment掉就不會直接播放了，可是好像大家比較愛直接來
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
