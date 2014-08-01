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
#define DISSOLVE_TO_SELECTED_TIME .6
#define DISSOLVE_TO_UNSELECTED_TIME .2
#define SECONDS_UNTIL_DESELECT 3.0

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
        //self.hasCheckedPullVel = NO;
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
        int digitCount = 1;
        for (NSString *digit in self.wholeNumberDigits) {
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:digit];
            value = [value decimalNumberByMultiplyingByPowerOf10:((short)([self.wholeNumberDigits count]-digitCount))];
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 60, 80) andValue:value];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
            newDigit.textColor = [UIColor whiteColor];
            newDigit.font = [UIFont fontWithName:@"Futura" size:95];
            xPos = xPos+60;
            if([self.wholeNumberDigits count]>1 && ![digit isEqualToString:@"0"]){
                newDigit.userInteractionEnabled = YES;
                UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberTapped:)];
                [newDigit addGestureRecognizer:gesture2];
            }
            digitCount++;
        }
        digitCount = 1;
        for (NSString *digit in self.decimalNumberDigits) {
            if ([digit isEqualToString:@"."]) {
                UILabel *decimal = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, 60, 80)];
                [self.digitViews addObject:decimal];
                [self addSubview:decimal];
                decimal.text = digit;
                decimal.textAlignment = UITextAlignmentCenter;
                decimal.textColor = [UIColor whiteColor];
                decimal.font = [UIFont fontWithName:@"Futura" size:95];
                xPos = xPos+60;
            }
            else{
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:digit];
            value = [value decimalNumberByMultiplyingByPowerOf10:((short)(-1*digitCount))];
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 60, 80) andValue:value];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
            newDigit.backgroundColor = [UIColor colorWithRed:119 green:232 blue:136 alpha:0];
            newDigit.textColor = [UIColor whiteColor];
            newDigit.font = [UIFont fontWithName:@"Futura" size:95];
            xPos = xPos+60;
            if([self.decimalNumberDigits count]>1 && ![digit isEqualToString:@"0"]){
                newDigit.userInteractionEnabled = YES;
                UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberTapped:)];
                [newDigit addGestureRecognizer:gesture2];
            }

            digitCount++;
            }
        }
    }
    
    [self setBackgroundColor:[UIColor colorWithRed:5/255.0 green:117/255.0 blue:165/255.0 alpha:1.0] ];
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
                UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(numberSwiped:)];
                
                [tappedNum addGestureRecognizer:gesture1];
//                UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc]
//                                                    initWithTarget:self
//                                                    action:@selector(numberSwiped:)];
//                
//                [tappedNum addGestureRecognizer:gesture2];
                [self.deselectTimer invalidate];
                self.movable = false;
            }
            else if (digit == tappedNum && digit.isDigitSelected) {
                [digit deselect];
            }
        }
    }
    
    self.deselectTimer = [NSTimer scheduledTimerWithTimeInterval:SECONDS_UNTIL_DESELECT
                                                              target:self
                                                            selector:@selector(timedDeselect)
                                                            userInfo:nil
                                                             repeats:NO];
    
    UIPanGestureRecognizer *dragger = [self.gestureRecognizers objectAtIndex:0];
    dragger.enabled = self.movable;
}

-(void) timedDeselect
{
    for (DigitView *digit in self.digitViews) {
        if (![digit.text isEqualToString: @"."]) {
            if (digit.isDigitSelected) {
                [digit deselect];
            }
        }
    }
    UIPanGestureRecognizer *dragger = [self.gestureRecognizers objectAtIndex:0];
    self.movable = true;
    dragger.enabled = self.movable;
}



- (void) numberSwiped:(UITapGestureRecognizer *)gesture
{
    DigitView *digit = (DigitView *)(gesture.view);
    int offset = 60*([self.digitViews indexOfObject:digit]);
    ViewController *mainViewController = (ViewController*)[self.superview nextResponder];
    [mainViewController decomposeBigNumberWithNewValue:digit.value andOrigNum:self andDir:@"down" andOffset:offset andDigit:digit.text];
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
