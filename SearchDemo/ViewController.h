//
//  ViewController.h
//  SearchDemo
//
//  Created by Ilja Rozhko on 14.06.15.
//  Copyright © 2015 IR Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (void)handleClickOnItemWithID:(NSString *)itemID;
- (void)handleNotificationResultWithText:(NSString *)result;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *notificationResultLbl;
@property (weak, nonatomic) IBOutlet UITextField *notificationText;
- (IBAction)sendNotification:(id)sender;


@end

