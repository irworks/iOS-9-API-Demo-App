//
//  ViewController.m
//  SearchDemo
//
//  Created by Ilja Rozhko on 14.06.15.
//  Copyright © 2015 IR Works. All rights reserved.
//

#import "ViewController.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

NSDictionary *mainItems;
NSDictionary *subItem1;
NSDictionary *subItem2;

NSString * const NotificationCategoryIdent  = @"ACTIONABLE";
NSString * const NotificationActionOneIdent = @"ACTION_ONE";
NSString * const NotificationActionTwoIdent = @"ACTION_TWO";

@implementation ViewController

@synthesize titleLbl, descriptionLbl, notificationText, notificationResultLbl;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    subItem1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Test of the new API", @"title", @"This is a test of the new SearchAPI using the CoreSpotlight framework.", @"description", nil];
    subItem2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"IR Works Product", @"title", @"This is a IR Works Product. You can click it.", @"description", nil];
    
    /* We created two items to test with, to access the data by the identifier we will store them like this */
    
    mainItems = [[NSDictionary alloc] initWithObjectsAndKeys:subItem1, @"123456", subItem2, @"1234567", nil];
    
    /* Main storage where for each item is a nested NSDictionary */
    
    [self addProductWithTitle:[subItem1 objectForKey:@"title"]
                  Description:[subItem1 objectForKey:@"description"]
                           ID:@"123456"];
    
    [self addProductWithTitle:[subItem2 objectForKey:@"title"]
                  Description:[subItem2 objectForKey:@"description"]
                           ID:@"1234567"];
    
    /* This called our method to insert our two demo items in the search */
    
    [self registerForNotification];
    
    /* This called our method to register for local notifications */
}

- (void)addProductWithTitle:(NSString *)title Description:(NSString *) description ID:(NSString *)Identifier {
    
    CSSearchableItemAttributeSet* attributeSet
                                    = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
    
    attributeSet.title              = title;
    attributeSet.contentDescription = description;
    
    CSSearchableItem *item          = [[CSSearchableItem alloc] initWithUniqueIdentifier:Identifier
                                             domainIdentifier:@"de.irworksTEST"
                                                 attributeSet:attributeSet];
    
    /* Setup search item */
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler: ^(NSError * __nullable error){
        NSLog(@"Search item (ID: %@) indexed", Identifier);
        /* This added our item to the default search index */
    }];
    
}

- (void)handleClickOnItemWithID:(NSString *)itemID {
    
    NSDictionary *tempDict = [mainItems objectForKey:itemID];
    
    /* Get data from in-app storage (NSDictionary[s]) by transported identifier from delegate method */
    
    NSString *tempMsg = [NSString stringWithFormat:@"You clicked item with ID: %@, title: %@", itemID, [tempDict objectForKey:@"title"]];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Search => App Handler"
                                          message:tempMsg
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    /* Dialog to show */
    
    [titleLbl       setText:[tempDict objectForKey:@"title"]];
    [descriptionLbl setText:[tempDict objectForKey:@"description"]];
    
    /* Set labels with data from NSDictionary metioned above */

}

- (void)handleNotificationResultWithText:(NSString *)result {
    [notificationResultLbl setText:result];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForNotification {
    
    UIMutableUserNotificationAction *action1;
    action1 = [[UIMutableUserNotificationAction alloc] init];
    [action1 setActivationMode:UIUserNotificationActivationModeBackground];
    [action1 setTitle:@"Like"];
    [action1 setIdentifier:NotificationActionOneIdent];
    [action1 setDestructive:NO];
    [action1 setAuthenticationRequired:NO];
    
    /* Created right button, not added yet */
    
    UIMutableUserNotificationAction *action2;
    action2 = [[UIMutableUserNotificationAction alloc] init];
    [action2 setActivationMode:UIUserNotificationActivationModeBackground];
    [action2 setTitle:@"Reply"];
    [action2 setIdentifier:NotificationActionTwoIdent];
    [action2 setDestructive:NO];
    [action2 setAuthenticationRequired:NO];
    [action2 setBehavior:UIUserNotificationActionBehaviorTextInput]; // Trigger a textfield on press, new in iOS 9!
    
     /* Created left button, not added yet */
    
    UIMutableUserNotificationCategory *actionCategory;
    actionCategory = [[UIMutableUserNotificationCategory alloc] init];
    [actionCategory setIdentifier:NotificationCategoryIdent];
    [actionCategory setActions:@[action1, action2]
                    forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObject:actionCategory];
    UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                    UIUserNotificationTypeSound|
                                    UIUserNotificationTypeBadge);
    
    /* Created setup for the type of our interactable notification */
    
    UIUserNotificationSettings *settings;
    settings = [UIUserNotificationSettings settingsForTypes:types
                                                 categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    /* This will present the dialog to the user */
}

- (IBAction)sendNotification:(id)sender {
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    [notification setRepeatInterval:NSCalendarUnitDay];
    [notification setAlertBody:[notificationText text]];
    [notification setCategory:NotificationCategoryIdent];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
    
    /* Setup local sheduled notification which will be delivered in 1 second (only when app is _not_ in foreground, no in-app-notification-delegte implemented) */
    
    [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
}
@end
