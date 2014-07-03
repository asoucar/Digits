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
@property (nonatomic) int numTimesTenDecMovers;
@property (nonatomic) int numDivTenDecMovers;
@property (nonatomic, strong) UIImageView *multBy10;
@property (nonatomic, strong) UIImageView *divBy10;

@end

@implementation ViewController

int numDigits =0;
bool decimalUsed = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.calculator.hidden=true;
    self.decimalMoverCreator.hidden = true;
    self.numTimesTenDecMovers = 0;
    self.numDivTenDecMovers = 0;
    
    self.onScreenNums = [NSMutableArray array];
    
    UIPanGestureRecognizer *gesture1 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(multDragged:)];
    UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(divDragged:)];
    
    self.divBy10 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteLeftArrow.png"]];
    self.multBy10 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteRightArrow.png"]];
    
    self.divBy10.userInteractionEnabled = YES;
    self.multBy10.userInteractionEnabled = YES;
    self.divBy10.frame = CGRectMake(65, 125, 65, 65);
    self.divBy10.backgroundColor = [UIColor clearColor];
    self.multBy10.frame = CGRectMake(65, 190, 65, 60);
    self.multBy10.backgroundColor = [UIColor clearColor];
    
    [self.multBy10 addGestureRecognizer:gesture1];
    [self.divBy10 addGestureRecognizer:gesture2];
    
    [self.view addSubview:self.divBy10];
    [self.view addSubview:self.multBy10];

    self.divBy10.hidden = YES;
    self.multBy10.hidden = YES;
    self.multCount.hidden = YES;
    self.divCount.hidden = YES;
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
        int decShift = 0;
        if(number.decimalNumberDigits.count > 0){
            decShift = 17;
        }
        
        NSNumber *numberDecimalLoc = [NSNumber numberWithFloat:((number.frame.origin.x)+[number.decimalPosition floatValue])+decShift];
        int arrowAllign = abs([numberDecimalLoc intValue]-((int)mult.frame.origin.x+14));
        
        CGRect numberProjectedFrame = CGRectMake(number.frame.origin.x, number.frame.origin.y+number.frame.size.height, number.frame.size.width+60, 10);
        
        CGRect multProjectedFrame = CGRectMake(mult.frame.origin.x, mult.frame.origin.y+30, mult.frame.size.width, 10);

        if (CGRectIntersectsRect(multProjectedFrame, numberProjectedFrame) && (arrowAllign <=5)) {

            NSDecimalNumber *decNum1 = number.value;
            decNum1 = [decNum1 decimalNumberByMultiplyingByPowerOf10:1];
            number.value = decNum1;
            int labelLength = 60*decNum1.stringValue.length;
            if ([decNum1.stringValue rangeOfString:@"."].location != NSNotFound) {
                labelLength -= 30;
            }
            mult.center = CGPointMake(100, 120);
            self.numTimesTenDecMovers -= 1;
            self.multCount.text = [NSString stringWithFormat:@"%d", self.numTimesTenDecMovers];
            if (self.numDivTenDecMovers <= 0) {
                self.divBy10.hidden = YES;
                self.divCount.hidden = YES;
            }
            if (self.numTimesTenDecMovers <= 0) {
                self.multBy10.hidden = YES;
                self.multCount.hidden = YES;
            }
            gesture.enabled = NO;
            gesture.enabled = YES;
            
            
            BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(number.frame.origin.x, number.frame.origin.y, labelLength, 80)andValue:decNum1 ];
            newNumber.userInteractionEnabled = YES;
//            
            UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(numberSwiped:)];
            [newNumber addGestureRecognizer:gesture3];
            
            [self.onScreenNums removeObject:number];
            [number removeFromSuperview];
            
            // add it
            [self.view addSubview:newNumber];
            [self.onScreenNums addObject:newNumber];
            [newNumber wobbleAnimation];
            
            break;
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
        int decShift = 0;
        if(number.decimalNumberDigits.count > 0){
            decShift = 17;
        }
        
        NSNumber *numberDecimalLoc = [NSNumber numberWithFloat:((number.frame.origin.x)+[number.decimalPosition floatValue])+decShift];
        int arrowAllign = abs([numberDecimalLoc intValue]-((int)div.frame.origin.x+div.frame.size.width-14));
        NSLog(@"arrow allign: %i", arrowAllign);
        
        CGRect numberProjectedFrame = CGRectMake(number.frame.origin.x, number.frame.origin.y+number.frame.size.height, number.frame.size.width+60, 10);
        
        CGRect divProjectedFrame = CGRectMake(div.frame.origin.x, div.frame.origin.y+30, div.frame.size.width, 10);
        
        if (CGRectIntersectsRect(divProjectedFrame, numberProjectedFrame) && (arrowAllign <=5)) {            NSDecimalNumber *decNum1 = number.value;
            decNum1 = [decNum1 decimalNumberByMultiplyingByPowerOf10:-1];
            number.value = decNum1;
            int labelLength = 60*decNum1.stringValue.length;
            if ([decNum1.stringValue rangeOfString:@"."].location != NSNotFound) {
                labelLength -= 30;
            }
            div.center = CGPointMake(100, 50);
            self.numDivTenDecMovers -= 1;
            self.divCount.text = [NSString stringWithFormat:@"%d", self.numDivTenDecMovers];
            if (self.numDivTenDecMovers <= 0) {
                self.divBy10.hidden = YES;
                self.divCount.hidden = YES;
            }
            if (self.numTimesTenDecMovers <= 0) {
                self.multBy10.hidden = YES;
                self.multCount.hidden = YES;
            }
            gesture.enabled = NO;
            gesture.enabled = YES;
            
            
            BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(number.frame.origin.x, number.frame.origin.y, labelLength, 80)andValue:decNum1 ];
            newNumber.userInteractionEnabled = YES;
            
            UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(numberSwiped:)];
            [newNumber addGestureRecognizer:gesture3];
            
            [self.onScreenNums removeObject:number];
            [number removeFromSuperview];
            
            // add it
            [self.view addSubview:newNumber];
            [self.onScreenNums addObject:newNumber];
            [newNumber wobbleAnimation];
            
            break;
        }
    }

}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
	BigNumber *firstNumber = (BigNumber *)gesture.view;
    firstNumber.backgroundColor = [UIColor clearColor];
    
    //move number
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint imageViewPosition = firstNumber.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    CGFloat checkOriginX = firstNumber.frame.origin.x + translation.x;
    CGFloat checkOriginY = firstNumber.frame.origin.y + translation.y;
    
    CGRect rectToCheckBounds = CGRectMake(checkOriginX, checkOriginY, firstNumber.frame.size.width, firstNumber.frame.size.height);
    
    CGRect draggableFrame = CGRectMake(0, 25, self.view.frame.size.width, self.view.frame.size.height-180);
    if (CGRectContainsRect(draggableFrame, rectToCheckBounds)){
        firstNumber.center = imageViewPosition;
        [gesture setTranslation:CGPointZero inView:self.view];
    }
    else {
        [firstNumber wobbleAnimation];
    }
    

    NSNumber *firstNumberDecimalLoc = [NSNumber numberWithFloat:((firstNumber.frame.origin.x)+[firstNumber.decimalPosition floatValue])];

    
    for (BigNumber *otherNumber in self.onScreenNums) {
        NSNumber *otherNumberDecimalLoc = [NSNumber numberWithFloat:((otherNumber.frame.origin.x)+[otherNumber.decimalPosition floatValue])];

        if (firstNumber != otherNumber && CGRectIntersectsRect(firstNumber.frame, otherNumber.frame)) {
            int decimalLocDiff = abs([firstNumberDecimalLoc intValue]-[otherNumberDecimalLoc intValue]);
            if (decimalLocDiff <= 20) {
                
                NSDecimalNumber *decNum1 = firstNumber.value;
                NSDecimalNumber *decNum2 = otherNumber.value;
                
                NSDecimalNumber *sumVal = [decNum2 decimalNumberByAdding:decNum1];
                int labelLength = 60*sumVal.stringValue.length;
                if ([sumVal.stringValue rangeOfString:@"."].location != NSNotFound) {
                    labelLength -= 30;
                }
                int num1Length = decNum1.stringValue.length;
                int num2Length = decNum2.stringValue.length;
                CGRect sumFrame;
                if (num1Length > num2Length) {
                    sumFrame = CGRectMake(firstNumber.frame.origin.x, firstNumber.frame.origin.y, labelLength, 80);
                }
                else {
                    sumFrame = CGRectMake(otherNumber.frame.origin.x, otherNumber.frame.origin.y, labelLength, 80);
                }
                
                
                BigNumber *sumNumber = [[BigNumber alloc] initWithFrame:sumFrame andValue:sumVal ];
                sumNumber.userInteractionEnabled = YES;
                
                UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(numberSwiped:)];
                [sumNumber addGestureRecognizer:gesture3];
                
                [self.onScreenNums removeObject:firstNumber];
                [self.onScreenNums removeObject:otherNumber];
                [firstNumber removeFromSuperview];
                [otherNumber removeFromSuperview];
                
                // add it
                [self.view addSubview:sumNumber];
                [self.onScreenNums addObject:sumNumber];
                [sumNumber wobbleAnimation];
                
                break;
            }
            else
            {
            
            //for not aligned
                BOOL anotherCollisionDetected = NO;
                for (BigNumber *thirdNum in self.onScreenNums) {
                    if (otherNumber != thirdNum && thirdNum != firstNumber){
                        if (CGRectIntersectsRect(otherNumber.frame, thirdNum.frame)) {
                            anotherCollisionDetected = YES;
                        }
                    }
                }
                CGFloat check2ndOriginX = otherNumber.frame.origin.x + translation.x;
                CGFloat check2ndOriginY = otherNumber.frame.origin.y + translation.y;
                
                CGRect rectToCheckBounds = CGRectMake(check2ndOriginX, check2ndOriginY, otherNumber.frame.size.width, otherNumber.frame.size.height);
                
                CGRect draggableFrame = CGRectMake(0, 25, self.view.frame.size.width, self.view.frame.size.height-180);
                if (!CGRectContainsRect(draggableFrame, rectToCheckBounds)){
                    anotherCollisionDetected = YES;
                }
   
                if (anotherCollisionDetected) {
                    firstNumber.center = CGPointMake(firstNumber.center.x - translation.x,
                                                     firstNumber.center.y - translation.y);
                }
                else{
                    otherNumber.center = CGPointMake(otherNumber.center.x + translation.x,
                                                 otherNumber.center.y + translation.y);
                }

            }
        }

    }
    
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:firstNumber];
}

- (void) numberSwiped:(UIPanGestureRecognizer *)gesture
{
    BigNumber *firstNumber = (BigNumber *)gesture.view;
    [firstNumber numberSwiped:gesture];
}

- (void)decomposeBigNumberWithNewValue:(NSDecimalNumber *)val andOrigNum:(BigNumber *)prevNum andDir:(NSString *)dir andOffset:(int)offest
{
    NSDecimalNumber *decNum1 = prevNum.value;
    NSDecimalNumber *decNum2 = [NSDecimalNumber decimalNumberWithDecimal:val.decimalValue];
    
    NSDecimalNumber *subVal = [decNum1 decimalNumberBySubtracting:decNum2];
    int labelLength = 60*subVal.stringValue.length;
    if ([subVal.stringValue rangeOfString:@"."].location != NSNotFound) {
        labelLength -= 30;
    }
    
    BigNumber *subNumber = [[BigNumber alloc] initWithFrame:CGRectMake(prevNum.frame.origin.x, prevNum.frame.origin.y, labelLength, 80) andValue:subVal];
    subNumber.userInteractionEnabled = YES;
    subNumber.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:232.0f/255.0f blue:136.0f/255.0f alpha:1];
    
    UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(numberSwiped:)];
    [subNumber addGestureRecognizer:gesture3];
    
    [self.onScreenNums removeObject:prevNum];
    [prevNum removeFromSuperview];
    
    // add it
    if ([subVal compare:[NSNumber numberWithInt:0]] != NSOrderedSame) {
        [self.view addSubview:subNumber];
        [self.onScreenNums addObject:subNumber];
        [subNumber wobbleAnimation];
    }

    int addX = 0;
    int addY = 0;
    if ([dir isEqualToString:@"up"]) {
        addY = -80;
    }
    else if ([dir isEqualToString:@"down"]) {
        addY = 50;
    }
    else if ([dir isEqualToString:@"right"]) {
        addX = labelLength + 75;
    }
    
    labelLength = 60*decNum2.stringValue.length;
    if ([decNum2.stringValue rangeOfString:@"."].location != NSNotFound) {
        labelLength -= 30;
    }
    BigNumber *newNum = [[BigNumber alloc] initWithFrame:CGRectMake(subNumber.frame.origin.x + addX +offest, subNumber.frame.origin.y + addY, labelLength, 80) andValue:decNum2];
    newNum.userInteractionEnabled = YES;
    newNum.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:232.0f/255.0f blue:136.0f/255.0f alpha:1];
    
    UILabel *cover = [[UILabel alloc] initWithFrame:CGRectMake(subNumber.frame.origin.x + addX +offest, subNumber.frame.origin.y + addY, 60, 80)];
    cover.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:232.0f/255.0f blue:136.0f/255.0f alpha:1];
    [self.view addSubview:cover];
    
    
    UIPanGestureRecognizer *gesture4 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(numberSwiped:)];
    [newNum addGestureRecognizer:gesture4];
    
    // add it
    if ([newNum.value compare:[NSNumber numberWithInt:0]] != NSOrderedSame) {
        [self.view addSubview:newNum];
        [self.onScreenNums addObject:newNum];
        [self.view sendSubviewToBack:newNum];
        [newNum wobbleAnimation];
    }
    
}

- (void)decomposeBigNumberWithNewValue:(NSDecimalNumber *)val andOrigNum:(BigNumber *)prevNum andDir:(NSString *)dir andOffset:(int)offest andDigit:(NSString *)digit
{
    NSDecimalNumber *decNum1 = prevNum.value;
    NSDecimalNumber *decNum2 = [NSDecimalNumber decimalNumberWithDecimal:val.decimalValue];
    
    NSDecimalNumber *subVal = [decNum1 decimalNumberBySubtracting:decNum2];
    int labelLength = 60*subVal.stringValue.length;
    if ([subVal.stringValue rangeOfString:@"."].location != NSNotFound) {
        labelLength -= 30;
    }
    
    BigNumber *subNumber = [[BigNumber alloc] initWithFrame:CGRectMake(prevNum.frame.origin.x, prevNum.frame.origin.y, labelLength, 80) andValue:subVal];
    subNumber.userInteractionEnabled = YES;
    subNumber.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:232.0f/255.0f blue:136.0f/255.0f alpha:1];
    
    UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(labelDragged:)];
    [subNumber addGestureRecognizer:gesture3];
    
    [self.onScreenNums removeObject:prevNum];
    [prevNum removeFromSuperview];
    
    // add it
    if ([subVal compare:[NSNumber numberWithInt:0]] != NSOrderedSame) {
        [self.view addSubview:subNumber];
        [self.onScreenNums addObject:subNumber];
    }
    
    int addX = 0;
    int addY = 0;
    if ([dir isEqualToString:@"up"]) {
        addY = -80;
    }
    else if ([dir isEqualToString:@"down"]) {
        addY = 50;
    }
    else if ([dir isEqualToString:@"right"]) {
        addX = labelLength + 75;
    }
    
    labelLength = 60*decNum2.stringValue.length;
    if ([decNum2.stringValue rangeOfString:@"."].location != NSNotFound) {
        labelLength -= 30;
    }
    BigNumber *newNum = [[BigNumber alloc] initWithFrame:CGRectMake(subNumber.frame.origin.x + addX +offest, subNumber.frame.origin.y + addY, labelLength, 80) andValue:decNum2];
    newNum.userInteractionEnabled = YES;
    newNum.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:232.0f/255.0f blue:136.0f/255.0f alpha:1];
    
    UILabel *cover = [[UILabel alloc] initWithFrame:CGRectMake(subNumber.frame.origin.x + addX +offest, subNumber.frame.origin.y + addY, 60, 80)];
    cover.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:232.0f/255.0f blue:136.0f/255.0f alpha:1];
    cover.text = digit;
    cover.textColor = [UIColor whiteColor];
    cover.font = [UIFont fontWithName:@"Futura" size:100];
    [self.view addSubview:cover];
    
    
    UIPanGestureRecognizer *gesture4 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(labelDragged:)];
    [newNum addGestureRecognizer:gesture4];
    
    // add it
    if ([newNum.value compare:[NSNumber numberWithInt:0]] != NSOrderedSame) {
        [self.view addSubview:newNum];
        [self.onScreenNums addObject:newNum];
        [self.view sendSubviewToBack:newNum];
    }
    
}

- (IBAction)clearNumber:(UIButton *)sender {
    for (UILabel *v in self.onScreenNums) {
        [v removeFromSuperview];
    }
    [self.onScreenNums removeAllObjects];
    
    self.numTimesTenDecMovers = 0;
    self.numDivTenDecMovers = 0;
    self.divCount.text = [NSString stringWithFormat:@"%d", self.numDivTenDecMovers];
    self.multCount.text = [NSString stringWithFormat:@"%d", self.numTimesTenDecMovers];
    self.divCount.hidden = YES;
    self.multCount.hidden = true;
    self.divBy10.hidden = YES;
    self.multBy10.hidden = true;
}

- (IBAction)decimalPressed:(UIButton *)sender {
    NSString *decimal = sender.currentTitle;
    if (!decimalUsed) {
        self.numberDisplay.text = [self.numberDisplay.text stringByAppendingString:decimal];
        decimalUsed = true;
    }
    
}

- (IBAction)numberPressed:(UIButton *)sender {
    NSString *number = sender.currentTitle;
    if (numDigits < 8) {
        self.numberDisplay.text = [self.numberDisplay.text stringByAppendingString:number];
        numDigits++;
    }
}

- (IBAction)submitPressed:(UIButton *)sender {
    
    int labelLength = (60*self.numberDisplay.text.length);
    if ([self.numberDisplay.text rangeOfString:@"."].location != NSNotFound) {
        labelLength -= 30;
    }

    CGRect potentialFrame = CGRectMake(300, 50, labelLength, 80);
    
    BOOL isANumInSpawnSpot = NO;
    for (BigNumber *oldNum in self.onScreenNums) {
        if (CGRectIntersectsRect(oldNum.frame, potentialFrame)) {
            isANumInSpawnSpot = YES;
        }
    }
    
    if (!isANumInSpawnSpot && ![self.numberDisplay.text isEqualToString:@""]) {
        BigNumber *newNumber = [[BigNumber alloc] initWithFrame:potentialFrame
                                                       andValue:[NSDecimalNumber decimalNumberWithString:self.numberDisplay.text]];
        [self.view addSubview:newNumber];
        newNumber.center = CGPointMake(384, 200);
        [self.onScreenNums addObject:newNumber];
        UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(numberSwiped:)];
        [newNumber addGestureRecognizer:gesture3];
        [newNumber wobbleAnimation];
        
        self.numberDisplay.text = @"";
        decimalUsed = false;
        numDigits = 0;
        [self.makeNumber setTitle:@"Make" forState:UIControlStateNormal];
        self.calculator.hidden = true;
        
        //for decimal mover creator
        self.numTimesTenDecMovers = [NSDecimalNumber decimalNumberWithString:self.times10NumDisplay.text].intValue;
        self.numDivTenDecMovers = [NSDecimalNumber decimalNumberWithString:self.divide10NumDisplay.text].intValue;
        self.times10NumDisplay.text = @"";
        self.divide10NumDisplay.text = @"";
        
        self.divCount.text = [NSString stringWithFormat:@"%d", self.numDivTenDecMovers];
        self.multCount.text = [NSString stringWithFormat:@"%d", self.numTimesTenDecMovers];
        self.divCount.hidden = YES;
        self.multCount.hidden = true;
        self.divBy10.hidden = YES;
        self.multBy10.hidden = true;
        
        if (self.numDivTenDecMovers > 0) {
            self.divBy10.hidden = NO;
            self.divCount.hidden = NO;
        }
        if (self.numTimesTenDecMovers > 0) {
            self.multBy10.hidden = NO;
            self.multCount.hidden = NO;
        }
        self.decimalMoverCreator.hidden = YES;
    }
}

- (IBAction)clearPresssed:(UIButton *)sender {
    numDigits = 0;
    decimalUsed = false;
    self.numberDisplay.text = @"";
}

- (IBAction)showCalc:(UIButton *)sender {
    if (self.calculator.hidden == true) {
        [sender setTitle:@"Close" forState:UIControlStateNormal];
        self.calculator.hidden=false;
        [self.view bringSubviewToFront:self.calculator];
        
        self.decimalMoverCreator.hidden = false;
        [self.view bringSubviewToFront:self.decimalMoverCreator];
        if ([self.times10NumDisplay.text isEqualToString:@""]) {
            self.times10NumDisplay.text = @"0";
        }
        if ([self.divide10NumDisplay.text isEqualToString:@""]) {
            self.divide10NumDisplay.text = @"0";
        }
    }
    else{
        [sender setTitle:@"Make" forState:UIControlStateNormal];
        self.calculator.hidden=true;
        self.decimalMoverCreator.hidden = true;
    }
}

- (IBAction)addTimesTen:(id)sender {
    int newNum =[NSDecimalNumber decimalNumberWithString:self.times10NumDisplay.text].intValue + 1;
    self.times10NumDisplay.text = [NSString stringWithFormat:@"%d",newNum];
}

- (IBAction)subtractTimesTen:(id)sender {
    int newNum =[NSDecimalNumber decimalNumberWithString:self.times10NumDisplay.text].intValue - 1;
    if (newNum < 0) {
        newNum = 0;
    }
    self.times10NumDisplay.text = [NSString stringWithFormat:@"%d",newNum];
}

- (IBAction)addDivTen:(id)sender {
    int newNum =[NSDecimalNumber decimalNumberWithString:self.divide10NumDisplay.text].intValue + 1;
    self.divide10NumDisplay.text = [NSString stringWithFormat:@"%d",newNum];
}

- (IBAction)subtractDivTen:(id)sender {
    int newNum =[NSDecimalNumber decimalNumberWithString:self.divide10NumDisplay.text].intValue - 1;
    if (newNum < 0) {
        newNum = 0;
    }
    self.divide10NumDisplay.text = [NSString stringWithFormat:@"%d",newNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
