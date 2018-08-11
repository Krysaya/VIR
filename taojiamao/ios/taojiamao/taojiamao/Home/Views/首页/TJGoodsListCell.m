
//
//  TJGoodsListCell.m
//  taojiamao
//
//  Created by yueyu on 2018/7/12.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJGoodsListCell.h"
#import "TJJHSGoodsListModel.h"
#import "TJGoodsCollectModel.h"
@interface TJGoodsListCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *btn_quan;
@property (weak, nonatomic) IBOutlet UILabel *lab_quanh;
@property (weak, nonatomic) IBOutlet UILabel *lab_yuanjia;
@property (weak, nonatomic) IBOutlet UILabel *lab_yimai;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnLeading;
// 如果要整体右移这个值也改下
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewTrailing;

@end

@implementation TJGoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWithArr:(NSArray *)arr forIndexPath:(NSIndexPath *)indexPath isEditing:(BOOL)editing withType:(NSString *)type
{
    if (editing) {

        _checkBtnLeading.constant = 20.f;
        
        _rightViewTrailing.constant = -49.f;
    }else
    {
        _checkBtnLeading.constant = -29.f;
        
        _rightViewTrailing.constant = 0.f;
    }

    // 这里取出model， 根据model的是否选中属性，标记checkBtn的select状态，图标会自动转换
    if ([type intValue]==0) {

        TJJHSGoodsListModel *model = [arr objectAtIndex:indexPath.row];
        DSLog(@"--bian----%@",model.itemtitle);

//        _selectBtn.selected = model.isChecked;
        [self.img sd_setImageWithURL:[NSURL URLWithString:model.itempic] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        NSAttributedString *str_tb = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
            make.insertImage([UIImage imageNamed:@"tb_bs"], 0, CGPointMake(0, 0), CGSizeMake(27, 13));
            make.insertText(@" ", 1);
            make.insertText(model.itemtitle, 2);
        });
        self.titleLab.attributedText = str_tb;
        self.lab_quanh.text = model.itemprice;
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribt_yuanj = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@",model.itemendprice] attributes:attribtDic];
        
        self.lab_yuanjia.attributedText = attribt_yuanj;
        self.lab_yimai.text = [NSString stringWithFormat:@"%@人已买",model.itemsale];
        NSString *str_coupon = [NSString stringWithFormat:@"领券减%@",model.couponmoney];
        [self.btn_quan setTitle:str_coupon forState:UIControlStateNormal];
//        NSAttributedString *attrStr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
//            make.font([UIFont systemFontOfSize:12.f]).textColor([UIColor whiteColor]);
//            make.append(str_coupon);
//            make.rangeEdit(NSMakeRange(3, model.itemprice.length), ^(SJAttributesRangeOperator * _Nonnull make) {
//                make.font([UIFont systemFontOfSize:19.f]).textColor([UIColor whiteColor]);
//            });
//        });
//        [self.btn_quan setAttributedTitle:str_coupon forState:UIControlStateNormal];
    }else{
        TJGoodsCollectModel *model = [arr objectAtIndex:indexPath.row];
        _selectBtn.selected = model.isChecked;
        [self.img sd_setImageWithURL:[NSURL URLWithString:model.itempic] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        NSAttributedString *str_tb = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
            make.insertImage([UIImage imageNamed:@"tb_bs"], 0, CGPointMake(0, 0), CGSizeMake(27, 13));
            make.insertText(@" ", 1);
            make.insertText(model.itemtitle, 2);
        });
        self.titleLab.attributedText = str_tb;
        self.lab_quanh.text = model.itemprice;
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribt_yuanj = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@",model.itemendprice] attributes:attribtDic];
        
        self.lab_yuanjia.attributedText = attribt_yuanj;
        self.lab_yimai.text = [NSString stringWithFormat:@"%@人已买",model.itemsale];
        NSString *str_coupon = [NSString stringWithFormat:@"领券减%@",model.couponmoney];
        NSAttributedString *attrStr = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
            make.font([UIFont systemFontOfSize:12.f]).textColor([UIColor whiteColor]);
            make.append(str_coupon);
            make.rangeEdit(NSMakeRange(3, model.itemprice.length), ^(SJAttributesRangeOperator * _Nonnull make) {
                make.font([UIFont systemFontOfSize:19.f]).textColor([UIColor whiteColor]);
            });
        });
        [self.btn_quan setAttributedTitle:attrStr forState:UIControlStateNormal];
    }
  
    
}

@end
