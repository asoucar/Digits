//
//  ViewController.h
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "BigNumber.h"
#import "DirectionPanGestureRecognizer.h"
#import "MenuViewController.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *innerGridViews;

@property (weak, nonatomic) IBOutlet UIView *calculator;
@property (weak, nonatomic) IBOutlet UILabel *numberDisplay;
@property (weak, nonatomic) IBOutlet UIButton *makeNumber;

@property (weak, nonatomic) IBOutlet UIView *decimalMoverCreator;
@property (weak, nonatomic) IBOutlet UILabel *times10NumDisplay;
@property (weak, nonatomic) IBOutlet UILabel *divide10NumDisplay;
@property (weak, nonatomic) IBOutlet UILabel *multCount;
@property (weak, nonatomic) IBOutlet UILabel *divCount;
@property (weak, nonatomic) IBOutlet UIView *gridFrame;

@property (strong, atomic) NSArray *xGridLines;
@property (strong, atomic) NSArray *yGridLines;

- (IBAction)clearNumber:(UIButton *)sender;
- (IBAction)decimalPressed:(UIButton *)sender;
- (IBAction)numberPressed:(UIButton *)sender;
- (IBAction)submitPressed:(UIButton *)sender;
- (IBAction)targetPressed:(UIButton *)sender;
- (IBAction)clearPresssed:(UIButton *)sender;
- (IBAction)showCalc:(UIButton *)sender;

- (IBAction)addTimesTen:(id)sender;
- (IBAction)subtractTimesTen:(id)sender;
- (IBAction)addDivTen:(id)sender;
- (IBAction)subtractDivTen:(id)sender;

-(void)colorizeLabelForAWhile:(UILabel *)label withUIColor:(UIColor *)tempColor animated:(BOOL)animated;

- (void)decomposeBigNumberWithNewValue:(NSNumber *)val andOrigNum:(BigNumber *)prevNum andDir:(NSString *)dir andOffset:(int)offset andDigit:(NSString *)digit;
- (BOOL)prefersStatusBarHidden;

- (void)labelDragged:(UIPanGestureRecognizer *)gesture;


@end
