//
//  PMTextField.m
//  PampMe
//
//  Created by Rupam Mitra on 15/09/15.
//  Copyright (c) 2015 Indus Net. All rights reserved.
//

#import "HRMTextField.h"

@implementation HRMTextField

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDictionary *attributes = (NSMutableDictionary *)[(NSAttributedString *)self.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
        NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        if ([self.attributedPlaceholder length])
        {
            if (self.tag == 0 || self.tag == 3 || self.tag == 4) {
                
//                [newAttributes setObject:UIColorRGB(165.0, 23.0, 162.0) forKey:NSForegroundColorAttributeName];
//                [newAttributes setObject:IS_IPAD ? FONT_REGULAR(18) : FONT_LIGHT(15) forKey:NSFontAttributeName];
                if (_LeftViewImage) {
                    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? 36 : 16, IS_IPAD ? 36 : 15)];
                    leftView.image = _LeftViewImage;
                    self.leftViewMode = UITextFieldViewModeAlways;
                    self.leftView = leftView;
                }
                if (_RightViewImage) {
                    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? 36 : 16, IS_IPAD ? 36 : 15)];
                    rightView.image = _RightViewImage;
                    self.leftViewMode = UITextFieldViewModeAlways;
                    self.leftView = rightView;
                }
            }else if(self.tag == 1) {
                
                // Setting Left View for Search
                UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? 36 : 16, IS_IPAD ? 36 : 15)];
                if ([self.placeholder isEqualToString:@"Company Name"])
                    leftView.image = [UIImage imageNamed:@"Company~iPnone"];
                else if ([self.placeholder isEqualToString:@"User Name"])
                    leftView.image = [UIImage imageNamed:@"UserId"];
                else if ([self.placeholder isEqualToString:@"Password"])
                    leftView.image = [UIImage imageNamed:@"Lock"];
                
                self.leftViewMode = UITextFieldViewModeAlways;
                self.leftView = leftView;
                
                [newAttributes setObject:UIColorRGB(36.0, 144.0, 207.0, 1.0) forKey:NSForegroundColorAttributeName];
//                [newAttributes setObject:IS_IPAD ? FONT_LIGHT(18) : FONT_LIGHT(15) forKey:NSFontAttributeName];
            }else if (self.tag == 2) {
                
                // Setting Right View for Calendar
                UIButton *rightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? 42 : 18, IS_IPAD ? 42 : 18)];
                [rightView addTarget:self action:@selector(actionCalendar) forControlEvents:UIControlEventTouchUpInside];
                [rightView setImage:[UIImage imageNamed:@"CalenderIcon"] forState:UIControlStateNormal];
                self.rightViewMode = UITextFieldViewModeAlways;
                self.rightView = rightView;
                
                [newAttributes setObject:UIColorRGB(165.0, 23.0, 162.0, 1.0) forKey:NSForegroundColorAttributeName];
                [newAttributes setObject:IS_IPAD ? FONT_REGULAR(18) : FONT_LIGHT(15) forKey:NSFontAttributeName];
            }
                
            // Set new text with extracted attributes
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.attributedPlaceholder string] attributes:newAttributes];
        }
    }
    return self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    if (self.tag == 1) {
        if (IS_IPAD) {
            return CGRectMake(16, (bounds.size.height / 2) - 18, 36, 36);
        }else
            return CGRectMake(8, (bounds.size.height / 2) - 7.5, 16, 15);
    }else if(_LeftViewImage)
        return _LeftViewRect;
    else
        return [super leftViewRectForBounds:bounds];
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
    if (self.tag == 2) {
        if (IS_IPAD) {
            return CGRectMake(CGRectGetWidth(self.frame) - 52, (bounds.size.height / 2) - 21, 42, 42);
        }else
            return CGRectMake(CGRectGetWidth(self.frame) - 28, (bounds.size.height / 2) - 9, 18, 18);
    }else if(_RightViewImage)
        return _RightViewRect;
    else
        return [super rightViewRectForBounds:bounds];
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    if (self.tag == 1) {
        if (IS_IPAD) {
            return CGRectMake(bounds.origin.x + 68, bounds.origin.y, bounds.size.width, bounds.size.height);
        }else
            return CGRectMake(bounds.origin.x + 32, bounds.origin.y, bounds.size.width, bounds.size.height);
    }else if (self.tag == 2) {
        if (IS_IPAD) {
            return CGRectMake(bounds.origin.x + 16, bounds.origin.y, bounds.size.width - 70, bounds.size.height);
        }else
            return CGRectMake(bounds.origin.x + 8, bounds.origin.y, bounds.size.width - 40, bounds.size.height);
    }
    return CGRectMake(bounds.origin.x + IS_IPAD ? 16.0 : 8.0, bounds.origin.y, bounds.size.width, bounds.size.height);
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

-(void)actionCalendar
{
    if (_calendarHandler != nil) {
        _calendarHandler();
    }
}

@end