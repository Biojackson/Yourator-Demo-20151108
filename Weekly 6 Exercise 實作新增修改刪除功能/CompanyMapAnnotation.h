//
//  CompanyMapAnnotation.h
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/26.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>
@interface CompanyMapAnnotation : NSObject <MKAnnotation>



-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate title:(NSString*)argTitle subtitle:(NSString*)argSubtitle;



@end
