//
//  AppDelegate.m
//  SearchDemo
//
//  Created by Ilja Rozhko on 14.06.15.
//  Copyright © 2015 IR Works. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray *restorableObjects))restorationHandler {
    
    if ([[userActivity activityType] isEqualToString:CSSearchableItemActionType]) {
        // This activity represents an item indexed using Core Spotlight, so restore the context related to the unique identifier.
        // The unique identifier of the Core Spotlight item is set in the activity’s userInfo for the key CSSearchableItemActivityIdentifier.
        NSString *uniqueIdentifier = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
        
        ViewController *rootViewController = (ViewController*)self.window.rootViewController;
        [rootViewController handleClickOnItemWithID:uniqueIdentifier];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler {
    
    NSString *result = @"";
    
    if ([identifier isEqualToString:@"ACTION_ONE"]) {
        
       result = @"You clicked the \"Like\" Button last time.";
    }
    else if ([identifier isEqualToString:@"ACTION_TWO"]) {
        
        result = [NSString stringWithFormat:@"You typed: %@", [responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey]];
        
    }
    if (completionHandler) {
        
        completionHandler();
    }
    
    ViewController *rootViewController = (ViewController*)self.window.rootViewController;
    [rootViewController handleNotificationResultWithText:result];
    
}

@end
