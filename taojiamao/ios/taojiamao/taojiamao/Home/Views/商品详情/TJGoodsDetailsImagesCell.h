//
//  TJGoodsDetailsImagesCell.h
//  taojiamao
//
//  Created by yueyu on 2018/5/17.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJJHSGoodsListModel;

@interface TJGoodsDetailsImagesCell : TJBaseTableCell

@property(nonatomic,copy)NSString * urlStr;
@property (nonatomic, strong) TJJHSGoodsListModel *model_detail;

@end
