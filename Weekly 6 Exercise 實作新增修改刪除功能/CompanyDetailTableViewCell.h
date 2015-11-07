//
//  CompnyDetailTableViewCell.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/26.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "CompanyMapAnnotation.h"
@interface CompanyDetailTableViewCell : UITableViewCell <MKMapViewDelegate, CLLocationManagerDelegate>

    
@property (strong, nonatomic) IBOutlet UIImageView *companyLogoImageView;
@property (strong, nonatomic) IBOutlet UITextView *companyBrandNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyCategoyTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyTagsTextField;
@property (strong, nonatomic) IBOutlet UITextView *companyWebsiteTextView;
@property (strong, nonatomic) IBOutlet UITextView *companyFacebookTextView;
@property (strong, nonatomic) IBOutlet UITextView *companyAppTextView;
@property (strong, nonatomic) IBOutlet UITextView *companyIntroTextView;
@property (strong, nonatomic) IBOutlet UITextView *companyVisionTextView;
@property (strong, nonatomic) IBOutlet UITextView *companyStoryTextView;
@property (strong, nonatomic) IBOutlet UITextView *companyWelfareTextView;
    // 3 buttons omitted
@property (strong, nonatomic) IBOutlet UIImageView *companyPhotoImageView;
@property (strong, nonatomic) IBOutlet MKMapView *companyMapView;
@property (strong, nonatomic) IBOutlet UIView *companyYoutubeView;




@end
