//
//  TJGoodsDetailsLFCCell.h
//  taojiamao
//
//  Created by yueyu on 2018/5/17.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJJHSGoodsListModel;

@interface TJGoodsDetailsLFCCell : TJBaseTableCell
@property (nonatomic, strong) TJJHSGoodsListModel *model_detail;

@property(nonatomic,copy)NSString * LFC;

@property(nonatomic,copy)NSString * content;

@property(nonatomic,assign)BOOL isTKL;

@end
