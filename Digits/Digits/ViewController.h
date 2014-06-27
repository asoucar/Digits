//
//  ViewController.h
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "BigNumber.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *calculator;
@property (weak, nonatomic) IBOutlet UILabel *numberDisplay;
@property (weak, nonatomic) IBOutlet UIButton *makeNumber;

- (IBAction)clearNumber:(UIButton *)sender;
- (IBAction)decimalPressed:(UIButton *)sender;
- (IBAction)numberPressed:(UIButton *)sender;
- (IBAction)submitPressed:(UIButton *)sender;
- (IBAction)clearPresssed:(UIButton *)sender;
- (IBAction)showCalc:(UIButton *)sender;


- (void)decomposeBigNumberWithNewValue:(NSNumber *)val andOrigNum:(BigNumber *)prevNum andDir:(NSString *)dir andOffset:(int)offset;

@end
