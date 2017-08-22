//
//  HRMSearchField.m
//  
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMSearchField.h"

@implementation HRMSearchField

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Tag: 1 for normal Textfields
        if (self.tag == 1)
        {
            
        }
        else
        {
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        leftView.image = [UIImage imageNamed:@"SearchTimesheet"];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = leftView;
        }
    }
    return self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(16, (bounds.size.height / 2) - 18, 36, 36);
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    if(self.tag == 1)
        return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width, bounds.size.height);
    else
        return CGRectMake(bounds.origin.x + 58, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end
