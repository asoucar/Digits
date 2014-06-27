//
//  BigNumber.m
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "BigNumber.h"

@interface BigNumber()

@property (nonatomic, strong) NSMutableArray *wholeNumberDigits;
@property (nonatomic, strong) NSMutableArray *decimalNumberDigits;

@property (nonatomic, strong) NSMutableArray *digitViews;

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
        self.decimalPosition = [NSNumber numberWithInt:wholeValString.length*35];
        
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
            
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 35, 50) andValue:value];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
            newDigit.textColor = [UIColor whiteColor];
            newDigit.font = [UIFont fontWithName:@"Futura" size:50];
            xPos = xPos+35;
            newDigit.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberTapped:)];
            [newDigit addGestureRecognizer:gesture2];
            }
        
        for (NSString *digit in self.decimalNumberDigits) {
            if ([digit isEqualToString:@"."]) {
                UILabel *decimal = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, 35, 50)];
                [self.digitViews addObject:decimal];
                [self addSubview:decimal];
                decimal.text = digit;
                decimal.textAlignment = UITextAlignmentCenter;
                decimal.textColor = [UIColor whiteColor];
                decimal.font = [UIFont fontWithName:@"Futura" size:50];
                xPos = xPos+35;
            }
            else{
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:digit];
            value = [value decimalNumberByMultiplyingByPowerOf10:((short)(-1*[self.decimalNumberDigits indexOfObject:digit]))];
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 35, 50) andValue:value];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
            newDigit.textColor = [UIColor whiteColor];
            newDigit.font = [UIFont fontWithName:@"Futura" size:50];
            xPos = xPos+35;
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
    DigitView *tappedNum =(DigitView *)(gesture.view);
    NSLog(@"tap: %@", tappedNum.value);
    
    tappedNum.textColor = [UIColor blackColor];
    UIPanGestureRecognizer *dragger = [self.gestureRecognizers objectAtIndex:0];
    dragger.enabled = !dragger.enabled;
    
    UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(numberSwiped:)];
    
    [tappedNum addGestureRecognizer:gesture2];

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
        
        
    }
    else if (vel.y < 0) {
        //tell big number to tell view controller to create a new big number
        //with value of this digit
        //and subtract value from first big number
        //and remove this digit from big number
        NSLog(@"swipe up");
    
        
    }
    else if (vel.y > 0) {
        //tell big number to tell view controller to create a new big number
        //with value of this digit
        //and subtract value from first big number
        //and remove this digit from big number
        NSLog(@"swipe down");
        
        gesture.enabled = NO;
        
    }
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
