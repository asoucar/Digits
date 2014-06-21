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
        //NSMutableArray *wholeDigits = [[NSMutableArray alloc] init];
        for (int i =0; i < wholeValString.length; i++){
            NSString *charNum = [NSString stringWithFormat:@"%c",[wholeValString characterAtIndex:i]];
            self.wholeNumberDigits[i] = charNum;
        }

        NSLog(@"whole digits: %@", self.wholeNumberDigits);
        
        //pull apart decimal part into digits
        NSString *decValString = decPart.stringValue;
        //NSMutableArray *decDigits = [[NSMutableArray alloc] init];
        for (int i =0; i < decValString.length; i++){
            NSString *charNum = [NSString stringWithFormat:@"%c",[decValString characterAtIndex:i]];
            self.decimalNumberDigits[i] = charNum;
        }
        NSLog(@"decimal digits: %@", self.decimalNumberDigits);
        
        self.digitViews = [[NSMutableArray alloc] init];
        
        for (NSString *digit in self.wholeNumberDigits) {
            NSLog(@"digit: %@", digit);
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 35, 100) andValue:[NSDecimalNumber decimalNumberWithString:digit]];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
            NSLog(@"new digit: %@", newDigit.text);
            xPos = xPos+35;
        }
        
        for (NSString *digit in self.decimalNumberDigits) {
            NSLog(@"digit: %@", digit);
            if ([digit isEqualToString:@"0"]) {
                NSLog(@"no 0");
            }
            else if ([digit isEqualToString:@"."]) {
                UILabel *decimal = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, 35, 100)];
                [self.digitViews addObject:decimal];
                [self addSubview:decimal];
                decimal.text = digit;
                xPos = xPos+35;
            }
            else{
            DigitView *newDigit = [[DigitView alloc] initWithFrame:CGRectMake(xPos, 0, 35, 100) andValue:[NSDecimalNumber decimalNumberWithString:digit]];
            [self.digitViews addObject:newDigit];
            [self addSubview:newDigit];
            newDigit.text = digit;
                xPos = xPos+35;
            }
        
        }
    }
    
    
    return self;
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
