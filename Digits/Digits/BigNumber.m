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
        NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *wholePart = [value decimalNumberByRoundingAccordingToBehavior:behavior];
        NSDecimalNumber *decPart = [value decimalNumberBySubtracting:wholePart];
        
        //pull apart whole part into digits
        NSString *wholeValString = wholePart.stringValue;
        NSMutableArray *wholeDigits = [[NSMutableArray alloc] init];
        for (int i =0; i < wholeValString.length; i++){
            NSString *charNum = [NSString stringWithFormat:@"%c",[wholeValString characterAtIndex:wholeValString.length - i]];
            wholeDigits[i] = charNum;
        }
        self.wholeNumberDigits = wholeDigits;
        
        //pull apart decimal part into digits
        NSString *decValString = decPart.stringValue;
        NSMutableArray *decDigits = [[NSMutableArray alloc] init];
        for (int i =0; i < decValString.length; i++){
            NSString *charNum = [NSString stringWithFormat:@"%c",[decValString characterAtIndex:i]];
            decDigits[i] = charNum;
        }
        self.decimalNumberDigits = decDigits;
        
        self.digitViews = [[NSMutableArray alloc] init];
        
        for (NSNumber *digi in self.wholeNumberDigits) {
            //create new DigitView
            //add new DigitView to self.digitViews array
            //add to view at correct position
        }
        
        for (NSNumber *digi in self.decimalNumberDigits) {
            //create new DigitView
            //add new DigitView to self.digitViews array
            //add to view at correct position
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
