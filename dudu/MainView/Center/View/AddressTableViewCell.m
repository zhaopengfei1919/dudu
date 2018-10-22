//
//  AddressTableViewCell.m
//  dudu
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(addressModel *)model{
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.consignee,model.phone];
//    NSDictionary * areaInfo =model.areaInfo;
    self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.address];
}
@end
