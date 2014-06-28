//
//  BigNumber.m
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "BigNumber.h"
#import "ViewController.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface BigNumber()

@property (nonatomic, strong) NSMutableArray *wholeNumberDigits;

@property (nonatomic, strong) NSMutableArray *digitViews;

@property BOOL movable;

@end

@implementation BigNumber

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andValue:(NSDecimalNumber*)value
{
    self = [super initWithFrame:frame];
    self.value = value;
    if (self) {
        self.movable = true;
        self.wholeNumberDigits = [[NSMutableArray alloc] init];
        self.decimalNumberDigits = [[NSMutableArray alloc] init];
        int xPos = 0;
        
        NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *wholePart = [value decimalNumberByRoundingAccordingToBehavior:behavior];
                NSDecimalNumber *decPart = [value decimalNumberBySubtracting:wholePart];
        
        //pull apart whole part into digits
        NSString *wholeValString = wholePart.stringValue;
        for (int i =0; i < wholeValString.length; i++){
            NSString *charNum = [NSString stringWithFormat:@"%c",[wholeValString characterAtIndex:i]];
            self.wholeNumberDigits[i] = charNum;
        }
        self.decimalPosition = [NSNumber numberWithInt:wholeValString.length*60];
        
        //pull apart decimal part into digits
        NSString *decValString = decPart.stringValue;
        for (int i =0; i < decValString.length; i++){
            NSString *charNum = [NSString stringWithFormat:@"%c",[decValString characterAtIndex:i]];
            self.decimalNumberDigits[i] = charNum;
        }
        //remove the leading 0 of the decimal numbers.
        [self.decimalNumberDigits removeObjectAtIndex:0];

        self.digitViews = [[NSMutableArray alloc] init];
        
        for (NSString *digit in self.wholeNumberDigits) {
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:digit];
            value = [value decimalNumberByMultiplyingByPowerOf10:((short)([self.wholeNumberDigits count]-[self.wholeNumberDigits indexOfObject:digit]-1))];
            
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 60, 80) andValue:value];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
            newDigit.textColor = [UIColor whiteColor];
            newDigit.font = [UIFont fontWithName:@"Futura" size:100];
            xPos = xPos+60;
            newDigit.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberTapped:)];
            [newDigit addGestureRecognizer:gesture2];
            }
        
        for (NSString *digit in self.decimalNumberDigits) {
            if ([digit isEqualToString:@"."]) {
                UILabel *decimal = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, 60, 80)];
                [self.digitViews addObject:decimal];
                [self addSubview:decimal];
                decimal.text = digit;
                decimal.textAlignment = UITextAlignmentCenter;
                decimal.textColor = [UIColor whiteColor];
                decimal.font = [UIFont fontWithName:@"Futura" size:100];
                xPos = xPos+60;
            }
            else{
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:digit];
            value = [value decimalNumberByMultiplyingByPowerOf10:((short)(-1*[self.decimalNumberDigits indexOfObject:digit]))];
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 60, 80) andValue:value];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
            newDigit.textColor = [UIColor whiteColor];
            newDigit.font = [UIFont fontWithName:@"Futura" size:100];
            xPos = xPos+60;
                            newDigit.userInteractionEnabled = YES;
                UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberTapped:)];
                [newDigit addGestureRecognizer:gesture2];
            }
        
        }
    }
    
    
    return self;
}

- (void) numberTapped:(UITapGestureRecognizer *)gesture
{
    self.movable = true;
    DigitView *tappedNum =(DigitView *)(gesture.view);
    NSLog(@"tap: %@", tappedNum.value);
    
    for (DigitView *digit in self.digitViews) {
        if (![digit.text isEqualToString: @"."]) {
            if (!(digit == tappedNum) && digit.isDigitSelected) {
                [digit deselect];
            }
            else if (digit == tappedNum && !digit.isDigitSelected) {
                [digit selected];
                UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(numberSwiped:)];
                
                [tappedNum addGestureRecognizer:gesture2];
                self.movable = false;
            }
            else if (digit == tappedNum && digit.isDigitSelected) {
                [digit deselect];
            }
        }
    }
    /*
    if (!tappedNum.isDigitSelected) {
        NSLog(@"select");
        [tappedNum selected];
    }
    
    for (DigitView *digit in self.digitViews) {
        if (![digit.text isEqualToString: @"."]) {
            if (digit.isDigitSelected) {
                self.movable = false;
            }

        }
    }
     */
    UIPanGestureRecognizer *dragger = [self.gestureRecognizers objectAtIndex:0];
    dragger.enabled = self.movable;
}


- (void) numberSwiped:(UIPanGestureRecognizer *)gesture
{
    CGPoint vel = [gesture velocityInView:self];
    if (vel.x > 0 && vel.x > ABS(vel.y)) {
        //tell big number to tell view controller to create a new big number
        //with value of whole number with digits to right of this number, inclusive
        //and subtract value from first big number
        //and remove this digit from big number
        NSLog(@"swipe right");
        
        if (gesture.enabled) {
            gesture.enabled = NO;
            NSLog(@"swipe right inside if");
            
            //calculate new value
            int indexOfTap = [self.digitViews indexOfObject:((DigitView *)(gesture.view))];
            
            NSDecimalNumber *newNum = [NSDecimalNumber decimalNumberWithString:@"0"];
            for (indexOfTap; indexOfTap < self.digitViews.count; indexOfTap++) {
                DigitView *dig = [self.digitViews objectAtIndex:indexOfTap];
                if (![dig.text isEqualToString:@"."]) {
                    newNum = [newNum decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:dig.value.decimalValue]];
                }
            }
            
            ViewController *mainViewController = (ViewController*)[self.superview nextResponder];
            [mainViewController decomposeBigNumberWithNewValue:newNum andOrigNum:self andDir:@"right" andOffset:0];
        }

        
    }
    else if (vel.y < 0) {
        //tell big number to tell view controller to create a new big number
        //with value of this digit
        //and subtract value from first big number
        //and remove this digit from big number
        NSLog(@"swipe up");

        if (gesture.enabled) {
            gesture.enabled = NO;
            NSLog(@"swipe up inside if");
            ViewController *mainViewController = (ViewController*)[self.superview nextResponder];
            int offset = 60*([self.digitViews indexOfObject:((DigitView *)(gesture.view))]);
            if ([NSDecimalNumber decimalNumberWithDecimal:((DigitView *)(gesture.view)).value.decimalValue].doubleValue < 1) {
                offset = self.wholeNumberDigits.count*60-120;
            }
                        NSLog(@"offset: %i", offset);

            [mainViewController decomposeBigNumberWithNewValue:[NSDecimalNumber decimalNumberWithDecimal:((DigitView *)(gesture.view)).value.decimalValue] andOrigNum:self andDir:@"up" andOffset:offset];
        }

    }
    else if (vel.y > 0) {
        //tell big number to tell view controller to create a new big number
        //with value of this digit
        //and subtract value from first big number
        //and remove this digit from big number
        NSLog(@"swipe down");
        
        if (gesture.enabled) {
            NSLog(@"swipe down inside if");
            gesture.enabled = NO;
            ViewController *mainViewController = (ViewController*)[self.superview nextResponder];
            int offset = 60*([self.digitViews indexOfObject:((DigitView *)(gesture.view))]);
            if ([NSDecimalNumber decimalNumberWithDecimal:((DigitView *)(gesture.view)).value.decimalValue].doubleValue < 1) {
                NSLog(@"less than 1");
                offset = (self.wholeNumberDigits.count - 1)*60;
            }
            NSLog(@"offset: %i", offset);
            
            [mainViewController decomposeBigNumberWithNewValue:[NSDecimalNumber decimalNumberWithDecimal:((DigitView *)(gesture.view)).value.decimalValue] andOrigNum:self andDir:@"down" andOffset:offset];
        }
    }
}

- (void)wobbleAnimation
{
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-10.0));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(10.0));
    
    [UIView beginAnimations:@"wobble" context:(__bridge void *)(self)];
    self.transform = leftWobble;  // starting point
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:2]; // adjustable
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    self.transform = rightWobble; // end here & auto-reverse
    [UIView commitAnimations];
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0.0));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
