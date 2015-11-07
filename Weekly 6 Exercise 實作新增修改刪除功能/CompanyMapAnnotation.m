//
//  CompanyMapAnnotation.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/26.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "CompanyMapAnnotation.h"

@implementation CompanyMapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate title:(NSString*)argTitle subtitle:(NSString*)argSubtitle
{
    self = [super init];
    if(self)
    {
        coordinate = argCoordinate;
        title = argTitle;
        subtitle = argSubtitle;
    }
    return self;
}



@end
