//
//  TJPopularizeController.m
//  taojiamao
//
//  Created by yueyu on 2018/5/21.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJPopularizeController.h"
#import "TJPopularizeCollectCell.h"

static NSString * const PopularizeCollectionCell = @"PopularizeCollectionCell";

@interface TJPopularizeController ()<TJButtonDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIView * headView;
@property(nonatomic,strong)TJLabel * headLabel;

@property(nonatomic,strong)UIView * imagePicker;
@property(nonatomic,strong)TJLabel * chooseLabel;
@property(nonatomic,strong)TJLabel * numberLabel;
@property(nonatomic,strong)NSMutableArray * selectImages;
@property(nonatomic,strong)UICollectionView * collView;
//
@property(nonatomic,strong)NSMutableArray * record;

@property(nonatomic,strong)UIView * infoView;
@property(nonatomic,strong)UIView * texts;
@property(nonatomic,strong)TJButton * shareBut;

@property(nonatomic,strong)UIView * bottomShare;

@end

@implementation TJPopularizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIhead];
    [self setUIimagePicker];
    [self setUIInfoView];
    [self setUIbottom];
    if (self.imagesData.count==0) {
        DSLog(@"再次请求下数据（此时用的是上个界面的图片,测试用）");
    }

    [self.selectImages addObject:self.imagesData[0]];
}
-(void)setUIbottom{
    WeakSelf
    self.bottomShare = [[UIView alloc]init];
    self.bottomShare.backgroundColor = RandomColor;
    [self.view addSubview:self.bottomShare];
    [self.bottomShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.infoView.mas_bottom);
    }];
}
-(void)setUIInfoView{
    WeakSelf
    self.infoView = [[UIView alloc]init];
    self.infoView.backgroundColor = RandomColor;
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imagePicker.mas_bottom).offset(25);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(255);
    }];
    
    self.texts = [[UIView alloc]initWithFrame:CGRectMake(20, 0, S_W-40, 200)];
    self.texts.backgroundColor = RandomColor;
    [self.infoView addSubview:self.texts];
    [self addBorderToLayer:self.texts];
    
    self.shareBut = [[TJButton alloc]initWith:@"一键复制分享方案" delegate:self font:16 titleColor:[UIColor whiteColor] backColor:[UIColor redColor] tag:111 cornerRadius:15];
    [self.infoView addSubview:self.shareBut];
    [self.shareBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.texts);
        make.top.mas_equalTo(weakSelf.texts.mas_bottom).offset(20);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(35);
    }];
}
- (void)addBorderToLayer:(UIView *)view
{
    CAShapeLayer *border = [CAShapeLayer layer];

    border.strokeColor = [UIColor redColor].CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:15].CGPath;
    
    border.frame = view.bounds;
  
    border.lineWidth = 1;
    
    border.lineCap = @"square";
   
    border.lineDashPattern = @[@4, @3];
    
    [view.layer addSublayer:border];
}
-(void)buttonClick:(UIButton *)but{
    DSLog(@"一键复制");
    DSLog(@"%@",self.selectImages);
}
-(void)setUIimagePicker{
    WeakSelf
    self.imagePicker = [[UIView alloc]init];
    self.imagePicker.backgroundColor = RandomColor;
    [self.view addSubview:self.imagePicker];
    
    [self.imagePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.headView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(142);
    }];
    
    self.chooseLabel = [TJLabel setLabelWith:@"选择图片" font:15 color:RGB(51, 51, 51)];
    [self.imagePicker addSubview:self.chooseLabel];
    [self.chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(20);
    }];
    
    self.numberLabel = [TJLabel setLabelWith:@"" font:15 color:RGB(51, 51, 51)];
    self.numberLabel.attributedText = [self textChangeColor:@"已选择01张"];
    [self.imagePicker addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.chooseLabel);
        make.right.mas_equalTo(-20);
    }];
    
    [self.imagePicker addSubview:self.collView];
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.testData.count > 0) {
//            [weakSelf.collView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//        }
//    });
}
-(void)setUIhead{
    WeakSelf
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight+10, S_W, 50)];
    self.headView.backgroundColor = RandomColor;
    [self.view addSubview:self.headView];
    
    self.headLabel = [TJLabel setLabelWith:@"您的佣金预计为￥2.8" font:15 color:RGB(255, 71, 119)];
    [self.headView addSubview:self.headLabel];
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.headView);
        make.left.mas_equalTo(20);
    }];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesData.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TJPopularizeCollectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PopularizeCollectionCell forIndexPath:indexPath];
    
    cell.imageUrl = self.imagesData[indexPath.item];
  
    if (indexPath.item==0 || [self.record containsObject:[NSNumber numberWithInteger:indexPath.item]]) {
        cell.xz.hidden = NO;
    }else{
        cell.xz.hidden = YES;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item==0) return;
    
    TJPopularizeCollectCell * cell = (TJPopularizeCollectCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.record containsObject:[NSNumber numberWithInteger:indexPath.item]]){
        [self.record removeObject:[NSNumber numberWithInteger:indexPath.item]];
        cell.xz.hidden = YES;
        [self.selectImages removeObject:self.imagesData[indexPath.item]];
//        self.numberLabel.text = [NSString stringWithFormat:@"已选择%02lu张",(unsigned long)self.selectImages.count];
        self.numberLabel.attributedText = [self textChangeColor:[NSString stringWithFormat:@"已选择%02lu张",(unsigned long)self.selectImages.count]];
        return;
    };
    
    NSNumber * index = [NSNumber numberWithInteger:indexPath.item];
    
    [self.record addObject:index];
    
    cell.xz.hidden = NO;
    
    [self.selectImages addObject:self.imagesData[indexPath.item]];
    self.numberLabel.attributedText = [self textChangeColor:[NSString stringWithFormat:@"已选择%02lu张",(unsigned long)self.selectImages.count]];
    
}
#pragma mark - 文字变色
-(NSMutableAttributedString*)textChangeColor:(NSString*)str{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,2)];
    
    return attr;
}
#pragma mark - lazyloading
-(UICollectionView *)collView{
    if (_collView==nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.itemSize = CGSizeMake(95, 95);
        layout.minimumLineSpacing= 15;
        layout.minimumInteritemSpacing = 0;
        
        _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 47, S_W, 95) collectionViewLayout:layout];
        _collView.backgroundColor = RandomColor;
        _collView.showsHorizontalScrollIndicator = NO;
        _collView.delegate=self;
        _collView.dataSource=self;
        [_collView registerClass:[TJPopularizeCollectCell class] forCellWithReuseIdentifier:PopularizeCollectionCell];
    }
    return _collView;
}
-(NSMutableArray *)selectImages{
    if (!_selectImages) {
        _selectImages = [NSMutableArray array];
    }
    return _selectImages;
}

-(NSMutableArray *)record{
    if (!_record) {
        _record = [NSMutableArray array];
    }
    return _record;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
//    DSLog(@"%s",__func__);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
