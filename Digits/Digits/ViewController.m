//
//  ViewController.m
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *onScreenNums;

@end

@implementation ViewController

int labelX = 10;
int labelY = 10;
int numDigits =0;
bool decimalUsed = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.calculator.hidden=true;
    
    self.onScreenNums = [NSMutableArray array];

}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
	UILabel *label = (UILabel *)gesture.view;
	CGPoint translation = [gesture translationInView:label];
    
	// move label
	label.center = CGPointMake(label.center.x + translation.x,
                               label.center.y + translation.y);
    
    for (UILabel *otherLabel in self.onScreenNums) {
        if (label != otherLabel && CGRectIntersectsRect(label.frame, otherLabel.frame)) {
            //pretending alignment
            if (YES) {
                
                NSDecimalNumber *decNum1 = [NSDecimalNumber decimalNumberWithString:label.text];
                NSDecimalNumber *decNum2 = [NSDecimalNumber decimalNumberWithString:otherLabel.text];
                
                NSDecimalNumber *sumVal = [decNum2 decimalNumberByAdding:decNum1];
                
                UILabel *sumLabel = [[UILabel alloc] initWithFrame:label.frame];
                sumLabel.text = sumVal.stringValue;
                sumLabel.font = [UIFont systemFontOfSize:30.0];
                
                sumLabel.userInteractionEnabled = YES;
                
                UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(labelDragged:)];
                [sumLabel addGestureRecognizer:gesture3];
                
                [self.onScreenNums removeObject:label];
                [self.onScreenNums removeObject:otherLabel];
                [label removeFromSuperview];
                [otherLabel removeFromSuperview];
                
                // add it
                [self.view addSubview:sumLabel];
                [self.onScreenNums addObject:sumLabel];
                
                break;
            }
            else
            {
            
            //for not aligned
            
//            otherLabel.center = CGPointMake(otherLabel.center.x + translation.x,
//                                                otherLabel.center.y + translation.y);
            }
        }

    }
    
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:label];
    
    
    
}

- (IBAction)clearNumber:(UIButton *)sender {
    for (UILabel *v in self.onScreenNums) {
        [v removeFromSuperview];
    }
    [self.onScreenNums removeAllObjects];
}

- (IBAction)decimalPressed:(UIButton *)sender {
    NSString *decimal = sender.currentTitle;
    if (!decimalUsed) {
        self.numberDisplay.text = [self.numberDisplay.text stringByAppendingString:decimal];
        decimalUsed = true;
    }
    
}

- (IBAction)numberPressed:(UIButton *)sender {
    NSString *number = sender.currentTitle;\
    if (numDigits < 8) {
        self.numberDisplay.text = [self.numberDisplay.text stringByAppendingString:number];
        numDigits++;
    }
}

- (IBAction)submitPressed:(UIButton *)sender {
    
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, 150, 100)];
    labelY = labelY+150;
    newLabel.text = self.numberDisplay.text;
    newLabel.font = [UIFont systemFontOfSize:30.0];
    
    newLabel.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(labelDragged:)];
    [newLabel addGestureRecognizer:gesture3];
    
    // add it
    [self.view addSubview:newLabel];
    [self.onScreenNums addObject:newLabel];
    
    self.numberDisplay.text = @"";
    decimalUsed = false;
    numDigits = 0;
    [self.makeNumber setTitle:@"Make Number" forState:UIControlStateNormal];
    self.calculator.hidden = true;
    

}

- (IBAction)clearPresssed:(UIButton *)sender {
    numDigits = 0;
    self.numberDisplay.text = @"";
}

- (IBAction)showCalc:(UIButton *)sender {
    if (self.calculator.hidden == true) {
        [sender setTitle:@"Close" forState:UIControlStateNormal];
        self.calculator.hidden=false;
    }
    else{
        [sender setTitle:@"Make Number" forState:UIControlStateNormal];
        self.calculator.hidden=true;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
