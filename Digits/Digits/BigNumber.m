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

@property int numNonZeroDigits;
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
        self.hasCheckedPullVel = NO;
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
        }
        
        for (NSString *digit in self.decimalNumberDigits) {
            if ([digit isEqualToString:@"."]) {
                UILabel *decimal = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, 30, 80)];
                [self.digitViews addObject:decimal];
                [self addSubview:decimal];
                decimal.text = digit;
                decimal.textAlignment = UITextAlignmentCenter;
                decimal.textColor = [UIColor whiteColor];
                decimal.font = [UIFont fontWithName:@"Futura" size:100];
                xPos = xPos+30;
            }
            else{
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:digit];
            value = [value decimalNumberByMultiplyingByPowerOf10:((short)(-1*[self.decimalNumberDigits indexOfObject:digit]))];
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 60, 80) andValue:value];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
            newDigit.backgroundColor = [UIColor colorWithRed:119 green:232 blue:136 alpha:0];
            newDigit.textColor = [UIColor whiteColor];
            newDigit.font = [UIFont fontWithName:@"Futura" size:100];
            xPos = xPos+60;
            newDigit.userInteractionEnabled = YES;
            }
        }
    }
    
    
    return self;
}


- (void) numberSwiped:(UIPanGestureRecognizer *)gesture
{
    BigNumber *firstNumber = (BigNumber*)gesture.view;
    firstNumber.numNonZeroDigits = 0;
    CGPoint touchLocal = [gesture locationInView:gesture.view];
    
    if (!firstNumber.hasCheckedPullVel) {
        CGPoint initialVel = [gesture velocityInView:self];
        if (initialVel.y > 0) {
            self.movable = NO;
            NSLog(@"setmovetono");
            firstNumber.hasCheckedPullVel = YES;
        }
        else
        {
            self.movable = YES;
            NSLog(@"setmovetoyes");
            firstNumber.hasCheckedPullVel = YES;
        }
    }
    
    if (self.movable) {
        ViewController *mainViewController = (ViewController*)[self.superview nextResponder];
        [mainViewController labelDragged:gesture];
    }
    else
    {
        if (gesture.enabled) {
            gesture.enabled = NO;
            
            for (DigitView *digit in firstNumber.digitViews) {
                if (![digit.text isEqualToString:@"."]) {
                    if (CGRectContainsPoint(digit.frame, touchLocal)) {
                        ViewController *mainViewController = (ViewController*)[self.superview nextResponder];
                        int offset = 60*([self.digitViews indexOfObject:digit]);
                        if ([NSDecimalNumber decimalNumberWithDecimal:digit.value.decimalValue].doubleValue < 1) {
                            offset = (self.wholeNumberDigits.count - 1)*60;
                        }
                        for (DigitView *digit in firstNumber.digitViews) {
                            NSLog(@"digit: %@",digit.text);
                            if (![digit.text isEqualToString:@"0"] && ![digit.text isEqualToString:@"."]) {
                                firstNumber.numNonZeroDigits +=1;
                            }
                        }
                        NSLog(@"offset: %i", offset);
                        if (firstNumber.numNonZeroDigits != 1) {
                            [mainViewController decomposeBigNumberWithNewValue:[NSDecimalNumber decimalNumberWithDecimal:digit.value.decimalValue] andOrigNum:self andDir:@"down" andOffset:offset andDigit:digit.text];
                        }
                        break;
                    }
                }
            }
            firstNumber.hasCheckedPullVel = NO;
            gesture.enabled = YES;
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        firstNumber.hasCheckedPullVel = NO;
        gesture.enabled = YES;
    }
}



- (void)wobbleAnimation
{
    //replace with something
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
