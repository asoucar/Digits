//
//  MenuViewController.h
//  Digits
//
//  Created by Ashley Soucar on 7/25/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface MenuViewController : UIViewController

@property (weak) ViewController* delegate;

- (IBAction)levelButtonPressed:(UIButton *)sender;
@end
