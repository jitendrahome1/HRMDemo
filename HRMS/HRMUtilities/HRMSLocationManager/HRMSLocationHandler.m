//
//  PMLocationManager.m
//  PampMe
//
//  Created by Rupam Mitra on 30/09/15.
//  Copyright (c) 2015 Indus Net. All rights reserved.
//

#import "HRMSLocationHandler.h"

static HRMSLocationHandler *handler = nil;

@implementation HRMSLocationHandler

+(instancetype)handler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[HRMSLocationHandler alloc] init];
    });
    return handler;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        self.currentLocation = [[CLLocation alloc] init];
    }
    return self;
}

-(void)requestAndStartLocationManager
{
    if ([[[HRMSLocationHandler handler] locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[[HRMSLocationHandler handler] locationManager] requestWhenInUseAuthorization];
        [[[HRMSLocationHandler handler] locationManager] requestAlwaysAuthorization];
    }
    [[[HRMSLocationHandler handler] locationManager] startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    [self performCoordinateGeocode];
}

- (void)performCoordinateGeocode
{
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
    }
    else
    {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    NSLog(@"current location :%@",_currentLocation);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
          return;
        }
        else
        {
            _placemark =[placemarks lastObject];
//            NSLog(@"%@ %@ %@", self.placemark.country, self.placemark.locality, self.placemark.subLocality);
//            NSLog(@"Address: %@", self.placemark.addressDictionary);
        }
    }];
    }
}

@end