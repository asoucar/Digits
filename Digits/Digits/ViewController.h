//
//  ViewController.h
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
// 

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *numbersView;
@property (weak, nonatomic) IBOutlet UIView *calculator;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *numberDisplay;
@property (weak, nonatomic) IBOutlet UIButton *makeNumber;

- (IBAction)clearNumber:(UIButton *)sender;
- (IBAction)decimalPressed:(UIButton *)sender;
- (IBAction)numberPressed:(UIButton *)sender;
- (IBAction)submitPressed:(UIButton *)sender;
- (IBAction)clearPresssed:(UIButton *)sender;
- (IBAction)showCalc:(UIButton *)sender;


@end
