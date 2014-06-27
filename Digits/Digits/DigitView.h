//
//  DigitView.h
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DigitView : UILabel

@property (nonatomic, strong) NSNumber *value;
@property BOOL isDigitSelected;

- (id)initWithFrame:(CGRect)frame andValue:(NSDecimalNumber *)value;

- (void)selected;
- (void)deselect;

@end