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
    [self.delegate createLevelWithDictionary:[self returnDictionaryForLevel:sender.tag]];
    [self.delegate.menuPopover dismissPopoverAnimated:YES];
}

-(NSDictionary *)returnDictionaryForLevel:(int)levelNum {
    
    switch (levelNum) {
            
        // move
        case 1:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSDecimalNumber decimalNumberWithString:@"8"], @"targetNumber",
                        [NSArray arrayWithObjects:
                            [NSDecimalNumber decimalNumberWithString:@"8"], nil ], @"componentNumbers",
                        [NSNumber numberWithInt:0], @"numRightArrows",
                        [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
        // add
        case 2:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"5"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"2"],
                      [NSDecimalNumber decimalNumberWithString:@"3"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
        // line up, add
        case 3:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"15"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"11"],
                      [NSDecimalNumber decimalNumberWithString:@"4"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
        // decompose
        case 4:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"40"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"42"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
        // decompose with distractors
        case 5:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"30"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"137"],
                      [NSDecimalNumber decimalNumberWithString:@"3041"],
                      [NSDecimalNumber decimalNumberWithString:@"302"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
           
            
        // add, decompose
        case 6:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"3"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"9"],
                      [NSDecimalNumber decimalNumberWithString:@"4"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
        // decompose, add
        case 7:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"30"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"15"],
                      [NSDecimalNumber decimalNumberWithString:@"26"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
         
        // add, decompose, with distractor
        case 8:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"30"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"15"],
                      [NSDecimalNumber decimalNumberWithString:@"26"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
        // add, decompose, with distractors
        case 9:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"8"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"3"],
                      [NSDecimalNumber decimalNumberWithString:@"9"],
                      [NSDecimalNumber decimalNumberWithString:@"2"],
                      [NSDecimalNumber decimalNumberWithString:@"7"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
        // decompose with distractors
        case 10:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"7"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"737"],
                      [NSDecimalNumber decimalNumberWithString:@"7373"],
                      [NSDecimalNumber decimalNumberWithString:@"3.7"],
                      [NSDecimalNumber decimalNumberWithString:@"773"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            
        // add, decompose, with distractors
        case 11:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"2"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"18"],
                      [NSDecimalNumber decimalNumberWithString:@"21"],
                      [NSDecimalNumber decimalNumberWithString:@"24"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
    }
    
    
    
    // default returns level 1
        return  [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSDecimalNumber decimalNumberWithString:@"25"], @"targetNumber",
                 [NSArray arrayWithObjects:
                  [NSDecimalNumber decimalNumberWithString:@"25"],
                  [NSDecimalNumber decimalNumberWithString:@"3"], nil ], @"componentNumbers",
                 [NSNumber numberWithInt:0], @"numRightArrows",
                 [NSNumber numberWithInt:0], @"numLeftArrows", nil];
}

@end
