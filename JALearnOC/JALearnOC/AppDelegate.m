//
//  AppDelegate.m
//  JALearnOC
//
//  Created by jason on 17/4/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AppDelegate.h"
#import "AWPlayerListVC.h"
#import "AWVideoHomeVC.h"
#import "AWUncaughtExceptionHandler.h"
#import "AWGuideVC.h"
#import <Accounts/Accounts.h>
#import "FCUUID.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSLog(@"this account id is %@",[[ACAccount  new] identifier]);
    NSLog(@"this new uuid is %@",[FCUUID uuidForDevice]);
    
    _window.backgroundColor = KNormalBgColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
     if(![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLogin"]){
          //首次登录
         [[NSUserDefaults standardUserDefaults] setObject:@"isFirstLogin" forKey:@"FirstLogin"];
         AWGuideVC *vc = [[AWGuideVC alloc] init];
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
         
         _window.rootViewController = nav;
     
     }else{
         //直接挑战
         NSArray *currentArray = [AWUserDefaultTool load:@"RECORD_CHANNEL"];
         
         if(currentArray && [currentArray count] > 0){
             
             AWVideoHomeVC *vc = [[AWVideoHomeVC alloc] init];
             UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
             
             _window.rootViewController = nav;
             
         }else{
             AWGuideVC *vc = [[AWGuideVC alloc] init];
             UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
             
             _window.rootViewController = nav;
             
         }
     }
    
   // [AWUncaughtExceptionHandler setDefaultHandler];
    
     [_window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark method
+ (AppDelegate *)shareDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
