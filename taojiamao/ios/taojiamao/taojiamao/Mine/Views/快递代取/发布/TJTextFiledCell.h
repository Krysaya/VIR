//
//  TJTextFiledCell.h
//  taojiamao
//
//  Created by yueyu on 2018/8/7.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJTextFiledCell : UITableViewCell
@property (nonatomic, strong) NSString *type;
@property (weak, nonatomic) IBOutlet UITextField *tf;

@end
