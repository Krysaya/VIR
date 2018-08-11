
//
//  TJClassicSecondController.m
//  taojiamao
//
//  Created by yueyu on 2018/7/18.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJClassicSecondController.h"
#import "TJFiltrateView.h"
#import "TJMultipleChoiceView.h"
#import "TJJHSuanCell.h"
#import "TJDefaultGoodsDetailController.h"
#import "TJGoodsListCell.h"
#import "TJJHSGoodsListModel.h"
#import "TJSearchScreenView.h"

@interface TJClassicSecondController ()<TJFiltrateViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,TJButtonDelegate,TJMultipleChoiceViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,strong)TJFiltrateView *filtrate;

@end

@implementation TJClassicSecondController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRequestClassicGoodsList:@"0"];

    self.view.backgroundColor = RGB(245, 245, 245);
    self.title = self.title_class;
    
    
    [self setNavgation];

    [self setUITableView];
    [self setUICollectionView];
    [self setFiltrateView];
    self.tableView.hidden = YES;
    //注册观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(horizontalVerticalTransform:) name:TJHorizontalVerticalTransform object:nil];
 
}
- (void)setFiltrateView{
    
        self.filtrate = [[TJFiltrateView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, S_W, 45) withMargin:22];
        self.filtrate.backgroundColor = [UIColor whiteColor];
        self.filtrate.deletage = self;
        [self.view addSubview:self.filtrate];
    
}
- (void)loadRequestClassicGoodsList:(NSString *)type{
    self.dataArr = [NSMutableArray array];
    NSString *userid = GetUserDefaults(UID);
    
    if (userid) {
    }else{
        userid = @"";
    }
    KSortingAndMD5 *MD5 = [[KSortingAndMD5 alloc]init];
    NSString *timeStr = [MD5 timeStr];
    NSString *str = [self.title_class stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *md = @{
                                @"timestamp": timeStr,
                                @"app": @"ios",
                                @"uid":userid,
                                @"keyword":str,
                                @"order":type,
                                }.mutableCopy;
    NSString *md5Str = [MD5 sortingAndMD5SignWithParam:md withSecert:SECRET];
    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.url = SearchGoodsList;
        request.headers = @{@"timestamp": timeStr,
                            @"app": @"ios",
                            @"sign":md5Str,
                            @"uid":userid,
                            };
        request.httpMethod = kXMHTTPMethodPOST;
        request.parameters = @{@"keyword":self.title_class,
                               @"order":type,
                               };
    } onSuccess:^(id  _Nullable responseObject) {
        //        NSLog(@"----search-success-===%@",responseObject);
        
        NSDictionary *dict = responseObject[@"data"];
        self.dataArr = [TJJHSGoodsListModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        DSLog(@"-%lu--arr==",(unsigned long)self.dataArr.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.collectionView reloadData];
        });
        
    } onFailure:^(NSError * _Nullable error) {
        //        NSData * errdata = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        //        NSDictionary *dic_err=[NSJSONSerialization JSONObjectWithData:errdata options:NSJSONReadingMutableContainers error:nil];
        //        DSLog(@"--搜索-≈≈error-msg%@=======dict%@",dic_err[@"msg"],dic_err);
    }];
}
- (void)setNavgation{

    //    1边按钮
    TJButton *button_left = [[TJButton alloc]initDelegate:self backColor:nil tag:885 withBackImage:@"search" withSelectImage:nil];
    
//    //    you2边按钮
//    TJButton *button_right = [[TJButton alloc]initDelegate:self backColor:nil tag:896 withBackImage:@"notice" withSelectImage:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button_left];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button_right];

    // 修改导航栏左边的item
    self.navigationItem.rightBarButtonItem = item1;

}
-(void)setUITableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight+45+15, S_W, S_H) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TJGoodsListCell class] forCellReuseIdentifier:@"tabListCell"];
    
    [self.view addSubview:self.tableView];
}

- (void)setUICollectionView{
    UICollectionViewFlowLayout *layou = [[UICollectionViewFlowLayout alloc]init];
    
    UICollectionView *collectV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight+45+15, S_W, S_H) collectionViewLayout:layou];
    collectV.delegate = self;
    collectV.dataSource = self;
    collectV.backgroundColor = RGB(245, 245, 245);
    [collectV registerNib:[UINib nibWithNibName:@"TJJHSuanCell" bundle:nil]
forCellWithReuseIdentifier:@"TJJHSuanCell"];
    [self.view addSubview:collectV];
    self.collectionView = collectV;
}
#pragma mark ---- UICollectionViewDataSource

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((S_W-5)/2, 275*H_Scale);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJJHSuanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TJJHSuanCell" forIndexPath:indexPath];
    cell.cell_type = @"search";
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //
    TJDefaultGoodsDetailController *goodVC = [[TJDefaultGoodsDetailController alloc]init];
    TJJHSGoodsListModel *model = self.dataArr[indexPath.row];
    goodVC.gid = model.itemid;
    [self.navigationController pushViewController:goodVC animated:YES];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TJGoodsListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tabListCell" forIndexPath:indexPath];
//        cell.model = self.dataArr[indexPath.row];
    [cell cellWithArr:self.dataArr forIndexPath:indexPath isEditing:NO withType:@"0"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TJDefaultGoodsDetailController *goodVC = [[TJDefaultGoodsDetailController alloc]init];
    TJJHSGoodsListModel *model = self.dataArr[indexPath.row];
    goodVC.gid = model.itemid;
    [self.navigationController pushViewController:goodVC animated:YES];
}
#pragma mark - TJFiltrateViewDelegate
-(void)requestWithKind:(NSString *)kind{
    if ([kind isEqualToString:@"综合"]) {
        DSLog(@"%@",kind);
        [self loadRequestClassicGoodsList:@"0"];
        
    }else if ([kind isEqualToString:@"销量"]){
        DSLog(@"%@",kind);
        [self loadRequestClassicGoodsList:@"6"];
    }else if ([kind isEqualToString:@"价格"]){
        DSLog(@"%@",kind);
        [self loadRequestClassicGoodsList:@"2"];//高--低
        
        
    }else if ([kind isEqualToString:@"优惠券"]){
        DSLog(@"%@",kind);
        [self loadRequestClassicGoodsList:@"4"];
        
    }else{
        DSLog(@"%@",kind);
        
    }
}

-(void)popupFiltrateView{
    DSLog(@"呼出筛选框");
    TJMultipleChoiceView * mcv = [[TJMultipleChoiceView alloc]initWithFrame:self.view.bounds];
    mcv.deletage = self;
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    [window addSubview:mcv];
}

- (void)buttonSureSelectString:(NSMutableDictionary *)sureDict{
//    筛选
}
#pragma mark - 通知
-(void)horizontalVerticalTransform:(NSNotification*)info{
    DSLog(@"%@",info.userInfo[@"hsBool"]);
    NSNumber * num = info.userInfo[@"hsBool"];
    BOOL hs = [num boolValue];
    self.tableView.hidden = !hs;
    self.collectionView.hidden = hs;
 
}
#pragma mark - btndelegte
- (void)buttonClick:(UIButton *)but{
    if (but.tag ==885) {
        
        //        搜索
    }else{
        //        TJNoticeController *noticeV = [[TJNoticeController alloc]init];
        //        [self.navigationController pushViewController:noticeV animated:YES];
    }
}



@end
