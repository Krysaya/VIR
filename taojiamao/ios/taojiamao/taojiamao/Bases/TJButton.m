//
//  TJButton.m
//  taojiamao
//
//  Created by yueyu on 2018/5/4.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJButton.h"

@interface TJButton()
@property(nonatomic,weak)id<TJButtonDelegate>delegate;
@property(nonatomic,strong)UIButton * button;
@end

@implementation TJButton

-(instancetype)initDelegate:(id<TJButtonDelegate>)dele backColor:(UIColor*)bc tag:(NSInteger)tag withBackImage:(NSString*)image withSelectImage:(NSString*)selectimage{
    return [self initWith:nil delegate:dele font:0.0 titleColor:nil backColor:bc tag:tag cornerRadius:0.0 borderColor:nil  borderWidth:0.0 withBackImage:image withSelectImage:nil];
}

-(instancetype)initWith:(NSString*)title delegate:(id<TJButtonDelegate>)dele font:(CGFloat)font titleColor:(UIColor*)color backColor:(UIColor*)bc tag:(NSInteger)tag{
    
    return [self initWith:title delegate:dele font:font titleColor:color backColor:bc tag:tag cornerRadius:0.0 borderColor:nil  borderWidth:0.0 withBackImage:nil withSelectImage:nil];
}

-(instancetype)initWith:(NSString*)title delegate:(id<TJButtonDelegate>)dele font:(CGFloat)font titleColor:(UIColor*)color backColor:(UIColor*)bc tag:(NSInteger)tag cornerRadius:(CGFloat)cor{
    
    return [self initWith:title delegate:dele font:font titleColor:color backColor:bc tag:tag cornerRadius:cor borderColor:nil  borderWidth:0.0 withBackImage:nil withSelectImage:nil];
}
-(instancetype)initWith:(NSString*)title delegate:(id<TJButtonDelegate>)dele font:(CGFloat)font titleColor:(UIColor*)color  tag:(NSInteger)tag   withBackImage:(NSString*)image withEdgeType:(NSString *)type
{
    self = [super init];
    if (self) {
        UIButton * but = [[UIButton alloc]init];
        but.tag = tag;
        self.delegate = dele;

        [but addTarget:self action:@selector(logregClick:) forControlEvents:UIControlEventTouchUpInside];
        [but setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        but.imageView.frame = CGRectMake(0, 0, 50, 50);
        [but setTitle:title forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:font];
         [but setTitleColor:color forState:UIControlStateNormal];
       
        UIImage *img = but.imageView.image;
        UILabel *lab = but.titleLabel;
        if ([type isEqualToString:@"top"]) {
            
        }else if ([type isEqualToString:@"bottom"]){
//            文字在下
            but.imageEdgeInsets = UIEdgeInsetsMake(-but.titleLabel.intrinsicContentSize.height-15, 0, 0, -but.titleLabel.intrinsicContentSize.width);
            but.titleEdgeInsets = UIEdgeInsetsMake(0, -but.imageView.frame.size.width, -but.imageView.frame.size.height-15, 0);
        }else if ([type isEqualToString:@"left"]){
            
            [but setTitleEdgeInsets:UIEdgeInsetsMake(0, -img.size.width-10, 0, img.size.width)];
            
            [but setImageEdgeInsets:UIEdgeInsetsMake(0, lab.bounds.size.width, 0, -lab.bounds.size.width-10)];
        }else{
//            [but setTitleEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
//            文字在右--默认
            [but setImageEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
        }
       
        self.button = but;

        [self addSubview:but];
        WeakSelf
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(weakSelf);
        }];
    }
    return self;
}
-(instancetype)initWith:(NSString*)title delegate:(id<TJButtonDelegate>)dele font:(CGFloat)font titleColor:(UIColor*)color backColor:(UIColor*)bc tag:(NSInteger)tag cornerRadius:(CGFloat)cor borderColor:(UIColor*)bcolor  borderWidth:(CGFloat)bw withBackImage:(NSString*)image withSelectImage:(NSString*)selectimage{
    
    self = [super init];
    if (self) {
        self.delegate = dele;
        UIButton * but = [[UIButton alloc]init];
        but.tag = tag;
        [but addTarget:self action:@selector(logregClick:) forControlEvents:UIControlEventTouchUpInside];
//        [but setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:selectimage] forState:UIControlStateSelected];

        [but setBackgroundColor:bc];
        [but setTitle:title forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:font];
        but.titleLabel.lineBreakMode = 0;
        [but setTitleColor:color forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        but.layer.borderWidth = bw;
        but.layer.cornerRadius = cor;
        but.layer.masksToBounds = YES;
        but.layer.borderColor = bcolor.CGColor;
        but.titleLabel.lineBreakMode = 0;
        self.button = but;
        [self addSubview:but];
        WeakSelf
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(weakSelf);
        }];
    }
    return self;
}


-(void)logregClick:(UIButton*)tj{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:tj];
    }
}
-(void)setTitle:(NSString *)title{
    _title = title;
    [self.button setTitle:title forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
