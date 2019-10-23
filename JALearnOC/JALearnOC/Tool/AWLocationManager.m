//
//  AWLocationManager.m
//  JALearnOC
//
//  Created by jason on 13/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWLocationManager.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@implementation AWLocationModel

@end

@interface AWLocationManager()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) CLGeocoder        *geocoder;
@property (nonatomic,copy) complateBlock       addressBlock;

@end

@implementation AWLocationManager

+ (instancetype)location {
    static AWLocationManager *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[AWLocationManager alloc] init];
    });
    return location;
}

- (void)startLocationAddress:(complateBlock)block {
    
    self.addressBlock = block;
    
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        if([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.manager requestWhenInUseAuthorization];
        }
        [self.manager startUpdatingLocation];
        return;
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"请点击设置打开定位服务" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                
                
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }

            }
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
        
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
}

#pragma mark - <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    // 强制转换成简体中文
    //    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil, nil] forKey:@"AppleLanguages"];
    
    __weak typeof (self) weakSelf = self;
   AWLocationModel *model = [[AWLocationModel alloc] init];
    model.currentLocation = location;
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark=[placemarks firstObject];
        model.locatedAddress = placemark.addressDictionary;
        model.name = placemark.name;
        model.country = placemark.country;
        model.postalCode = placemark.postalCode;
        model.ISOcountryCode = placemark.ISOcountryCode;
        model.administrativeArea = placemark.administrativeArea;
        model.subAdministrativeArea = placemark.subAdministrativeArea;
        model.locality = placemark.locality;
        model.subLocality = placemark.subLocality;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        
        if (weakSelf.addressBlock) {
            weakSelf.addressBlock (YES,model);
        }
    }];
    // 停止定位
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stopLocation];
    if (self.addressBlock) {
        self.addressBlock (NO,nil);
    }
}

#pragma mark - lazy loading
- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        [_manager requestWhenInUseAuthorization];
        [_manager setDelegate:self];
        [_manager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_manager setDistanceFilter:kCLDistanceFilterNone];
    }
    return _manager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
/**
 * 停止定位
 */
-(void)stopLocation {
    [self.manager stopUpdatingLocation];
    self.manager = nil; //这句话必须加上，否则可能会出现调用多次的情况
}
@end
