//
//  PMLocationManager.h
//  PampMe
//
//  Created by Rupam Mitra on 30/09/15.
//  Copyright (c) 2015 Indus Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HRMSLocationHandler : NSObject <CLLocationManagerDelegate>

+(instancetype)handler;
-(void)requestAndStartLocationManager;
-(void)performCoordinateGeocode;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLPlacemark *placemark;

@end
