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

@property (weak, nonatomic) IBOutlet UIView *decimalMoverCreator;
@property (weak, nonatomic) IBOutlet UILabel *times10NumDisplay;
@property (weak, nonatomic) IBOutlet UILabel *divide10NumDisplay;
@property (weak, nonatomic) IBOutlet UILabel *multCount;
@property (weak, nonatomic) IBOutlet UILabel *divCount;

- (IBAction)clearNumber:(UIButton *)sender;
- (IBAction)decimalPressed:(UIButton *)sender;
- (IBAction)numberPressed:(UIButton *)sender;
- (IBAction)submitPressed:(UIButton *)sender;
- (IBAction)clearPresssed:(UIButton *)sender;
- (IBAction)showCalc:(UIButton *)sender;

- (IBAction)addTimesTen:(id)sender;
- (IBAction)subtractTimesTen:(id)sender;
- (IBAction)addDivTen:(id)sender;
- (IBAction)subtractDivTen:(id)sender;
- (IBAction)submitNumDecimalMoversPressed:(id)sender;

- (void)decomposeBigNumberWithNewValue:(NSNumber *)val andOrigNum:(BigNumber *)prevNum andDir:(NSString *)dir;

@end
