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

@implementation ViewController

@synthesize titleLbl, descriptionLbl;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    subItem1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Test of the new API", @"title", @"This is a test of the new SearchAPI using the CoreSpotlight framework.", @"description", nil];
    subItem2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"IR Works Product", @"title", @"This is a IR Works Product. You can click it.", @"description", nil];
    
    mainItems = [[NSDictionary alloc] initWithObjectsAndKeys:subItem1, @"123456", subItem2, @"1234567", nil];
    
    [self addProductWithTitle:[subItem1 objectForKey:@"title"]
                  Description:[subItem1 objectForKey:@"description"]
                           ID:@"123456"];
    
    [self addProductWithTitle:[subItem2 objectForKey:@"title"]
                  Description:[subItem2 objectForKey:@"description"]
                           ID:@"1234567"];
}

- (void)addProductWithTitle:(NSString *)title Description:(NSString *) description ID:(NSString *)Identifier {
    
    CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
    
    attributeSet.title              = title;
    attributeSet.contentDescription = description;
    
    CSSearchableItem *item;
    item = [[CSSearchableItem alloc] initWithUniqueIdentifier:Identifier
                                             domainIdentifier:@"de.irworksTEST"
                                                 attributeSet:attributeSet];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler: ^(NSError * __nullable error){
        NSLog(@"Search item (ID: %@) indexed", Identifier);
    }];
    
}

- (void)handleClickOnItemWithID:(NSString *)itemID {
    
    NSDictionary *tempDict = [mainItems objectForKey:itemID];
    
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
    
    [titleLbl       setText:[tempDict objectForKey:@"title"]];
    [descriptionLbl setText:[tempDict objectForKey:@"description"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
