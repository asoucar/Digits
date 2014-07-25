//
//  MenuViewController.m
//  Digits
//
//  Created by Ashley Soucar on 7/25/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)levelButtonPressed:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 2:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 3:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 4:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 5:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 6:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 7:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 8:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 9:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 10:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 11:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 12:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 13:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 14:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 15:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 16:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 17:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        case 18:
            [self.menuPopover dismissPopoverAnimated:YES];
            break;
        default:
            break;
    }
}

-(NSDictionary *)returnDictionaryForLevel:(int)levelNum {
    
    switch (levelNum) {
        case 1:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSDecimalNumber decimalNumberWithString:@"25"], @"targetNumber",
                        [NSArray arrayWithObjects:
                            [NSDecimalNumber decimalNumberWithString:@"25"],
                            [NSDecimalNumber decimalNumberWithString:@"3"], nil ], @"componentNumbers", nil];
            
        case 2:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSDecimalNumber decimalNumberWithString:@"26.2"], @"targetNumber",
                        [NSArray arrayWithObjects:
                            [NSDecimalNumber decimalNumberWithString:@"26"],
                            [NSDecimalNumber decimalNumberWithString:@"0.2"], nil ], @"componentNumbers", nil];
    }
    
    // default returns level 1
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSDecimalNumber decimalNumberWithString:@"25"], @"targetNumber",
                            [NSArray arrayWithObjects:
                                [NSDecimalNumber decimalNumberWithString:@"25"],
                                [NSDecimalNumber decimalNumberWithString:@"3"], nil ], @"componentNumbers", nil];
}

@end
