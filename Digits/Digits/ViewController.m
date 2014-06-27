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

int numDigits =0;
bool decimalUsed = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.calculator.hidden=true;
    
    self.onScreenNums = [NSMutableArray array];
    
    UIPanGestureRecognizer *gesture1 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(multDragged:)];
    UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(divDragged:)];
    
    
    
    UIImageView *divBy10 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow.jpeg"]];
    UIImageView *multBy10 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.jpeg"]];
    
    divBy10.userInteractionEnabled = YES;
    multBy10.userInteractionEnabled = YES;
    
    divBy10.frame = CGRectMake(15, 25, 70, 50);
    divBy10.backgroundColor = [UIColor clearColor];
    multBy10.frame = CGRectMake(15, 95, 70, 50);
    multBy10.backgroundColor = [UIColor clearColor];
    
    [multBy10 addGestureRecognizer:gesture1];
    [divBy10 addGestureRecognizer:gesture2];
    
    [self.view addSubview:divBy10];
    [self.view addSubview:multBy10];

}

- (void)multDragged:(UIPanGestureRecognizer *)gesture
{
    UIImageView *mult = (UIImageView *)gesture.view;
    CGPoint translation = [gesture translationInView:mult];
    
	// move label
	mult.center = CGPointMake(mult.center.x + translation.x,
                               mult.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:mult];
    for (BigNumber *number in self.onScreenNums)
    {
        if (CGRectIntersectsRect(mult.frame, number.frame)) {
            NSDecimalNumber *decNum1 = number.value;
            decNum1 = [decNum1 decimalNumberByMultiplyingByPowerOf10:1];
            number.value = decNum1;
            int labelLength = 35*decNum1.stringValue.length;
            mult.center = CGPointMake(50, 120);
            gesture.enabled = NO;
            gesture.enabled = YES;
            
            
            BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(number.frame.origin.x, number.frame.origin.y, labelLength, 50)andValue:decNum1 ];
            newNumber.userInteractionEnabled = YES;
            
            UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(labelDragged:)];
            [newNumber addGestureRecognizer:gesture3];
            
            [self.onScreenNums removeObject:number];
            [number removeFromSuperview];
            
            // add it
            [self.view addSubview:newNumber];
            [self.onScreenNums addObject:newNumber];
            
        }
    }

}

- (void)divDragged:(UIPanGestureRecognizer *)gesture
{
    UIImageView *div = (UIImageView *)gesture.view;
    CGPoint translation = [gesture translationInView:div];
    
	// move label
	div.center = CGPointMake(div.center.x + translation.x,
                              div.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:div];
    for (BigNumber *number in self.onScreenNums)
    {
        if (CGRectIntersectsRect(div.frame, number.frame))
        {
            NSDecimalNumber *decNum1 = number.value;
            decNum1 = [decNum1 decimalNumberByMultiplyingByPowerOf10:-1];
            number.value = decNum1;
            int labelLength = 35*decNum1.stringValue.length;
            div.center = CGPointMake(50, 50);
            gesture.enabled = NO;
            gesture.enabled = YES;
            
            
            BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(number.frame.origin.x, number.frame.origin.y, labelLength, 50)andValue:decNum1 ];
            newNumber.userInteractionEnabled = YES;
            
            UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(labelDragged:)];
            [newNumber addGestureRecognizer:gesture3];
            
            [self.onScreenNums removeObject:number];
            [number removeFromSuperview];
            
            // add it
            [self.view addSubview:newNumber];
            [self.onScreenNums addObject:newNumber];        }
    }

}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
	BigNumber *firstNumber = (BigNumber *)gesture.view;
	CGPoint translation = [gesture translationInView:firstNumber];
    
	// move label
	firstNumber.center = CGPointMake(firstNumber.center.x + translation.x,
                               firstNumber.center.y + translation.y);
    NSNumber *firstNumberDecimalLoc = [NSNumber numberWithFloat:((firstNumber.frame.origin.x)+[firstNumber.decimalPosition floatValue])];

    
    for (BigNumber *otherNumber in self.onScreenNums) {
        NSNumber *otherNumberDecimalLoc = [NSNumber numberWithFloat:((otherNumber.frame.origin.x)+[otherNumber.decimalPosition floatValue])];

        if (firstNumber != otherNumber && CGRectIntersectsRect(firstNumber.frame, otherNumber.frame)) {
            int decimalLocDiff = abs([firstNumberDecimalLoc intValue]-[otherNumberDecimalLoc intValue]);
            if (decimalLocDiff <= 2) {
                
                NSDecimalNumber *decNum1 = firstNumber.value;
                NSDecimalNumber *decNum2 = otherNumber.value;
                
                NSDecimalNumber *sumVal = [decNum2 decimalNumberByAdding:decNum1];
                int labelLength = 35*sumVal.stringValue.length;
                
                BigNumber *sumNumber = [[BigNumber alloc] initWithFrame:CGRectMake(otherNumber.frame.origin.x, otherNumber.frame.origin.y, labelLength, 50)andValue:sumVal ];
                sumNumber.userInteractionEnabled = YES;
                
                UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(labelDragged:)];
                [sumNumber addGestureRecognizer:gesture3];
                
                [self.onScreenNums removeObject:firstNumber];
                [self.onScreenNums removeObject:otherNumber];
                [firstNumber removeFromSuperview];
                [otherNumber removeFromSuperview];
                
                // add it
                [self.view addSubview:sumNumber];
                [self.onScreenNums addObject:sumNumber];
                
                break;
            }
            else
            {
            
            //for not aligned
            
            otherNumber.center = CGPointMake(otherNumber.center.x + translation.x,
                                                otherNumber.center.y + translation.y);
            }
        }

    }
    
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:firstNumber];
    
    
    
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
    
    int labelLength = (35*self.numberDisplay.text.length);
    int lowerX = 50;
    int upperX = 768-(labelLength);
    int labelX = lowerX + arc4random() % (upperX - lowerX);
    int lowerY = 50;
    int upperY = 300;
    int labelY = lowerY + arc4random() % (upperY - lowerY);
    
    BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(labelX, labelY, labelLength, 50)
                                    andValue:[NSDecimalNumber decimalNumberWithString:self.numberDisplay.text]];
    [self.view addSubview:newNumber];
    [self.onScreenNums addObject:newNumber];
    UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(labelDragged:)];
    [newNumber addGestureRecognizer:gesture3];

    self.numberDisplay.text = @"";
    decimalUsed = false;
    numDigits = 0;
    [self.makeNumber setTitle:@"Make" forState:UIControlStateNormal];
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
        [self.view bringSubviewToFront:self.calculator];
    }
    else{
        [sender setTitle:@"Make" forState:UIControlStateNormal];
        self.calculator.hidden=true;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
