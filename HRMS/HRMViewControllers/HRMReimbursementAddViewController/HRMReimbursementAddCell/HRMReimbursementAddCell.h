//
//  HRMReimbursementAddCell.h
//  
//
//  Created by Priyam Dutta on 13/10/15.
//
//

#import <UIKit/UIKit.h>

@interface HRMReimbursementAddCell : UICollectionViewCell

@property (nonatomic, strong)id dataSource;
@property (nonatomic, strong)void((^imageHandler)());

@property (weak, nonatomic) IBOutlet UIImageView *imgAttached;

@end
