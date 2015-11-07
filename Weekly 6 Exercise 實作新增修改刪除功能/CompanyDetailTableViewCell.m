//
//  CompnyDetailTableViewCell.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/26.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "CompanyDetailTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CompanyMapAnnotation.h"

@interface CompanyDetailTableViewCell  () <MKMapViewDelegate, CLLocationManagerDelegate>


@end

@implementation CompanyDetailTableViewCell

- (void)awakeFromNib {

   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
