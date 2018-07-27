
//
//  TJDafultGoodsTitlesCell.m
//  taojiamao
//
//  Created by yueyu on 2018/7/12.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJDafultGoodsTitlesCell.h"
#import "TJJHSGoodsListModel.h"
@interface TJDafultGoodsTitlesCell()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_Ad;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (weak, nonatomic) IBOutlet UILabel *lab_price;
@property (weak, nonatomic) IBOutlet UILabel *lab_prime;
@property (weak, nonatomic) IBOutlet UILabel *lab_totalprenson;
@property (weak, nonatomic) IBOutlet UILabel *lab_couponmoneny;

@property (weak, nonatomic) IBOutlet UIButton *btn_coupon;

@end

@implementation TJDafultGoodsTitlesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel_detail:(TJJHSGoodsListModel *)model_detail{
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, S_W, 375)];
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",model_detail.long_pic]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    [self.scroll_Ad addSubview:img];
    
    self.lab_title.text = model_detail.sub_title;
    
    self.lab_prime.text = model_detail.price;
    self.lab_couponmoneny.text = [NSString stringWithFormat:@"%@元优惠券",model_detail.coupon_money];
    
}
@end
