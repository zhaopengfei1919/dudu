//
//  JifenDetailTableViewCell.h
//  dudu
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JifenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JifenDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *CountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong,nonatomic) JifenModel * model;

@end

NS_ASSUME_NONNULL_END
