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
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLbl;


@end

