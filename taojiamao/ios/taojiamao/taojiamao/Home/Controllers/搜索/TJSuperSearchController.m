
//
//  TJSuperSearchController.m
//  taojiamao
//
//  Created by yueyu on 2018/8/1.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJSuperSearchController.h"
#import "TJHomeFootShowCell.h"
#import "TJGoodsListCell.h"
#import "TJJHSuanCell.h"
#import "TJJHSGoodsListModel.h"
#import "TJDefaultGoodsDetailController.h"
#import "TJSearchScreenView.h"
#import "TJMultipleChoiceView.h"

static NSString *TJSearchContentFootShowCell = @"TJSearchContentFootShowCell";
static NSString *TJSearchContentCollectionCell = @"TJSearchContentCollectionCell";

@interface TJSuperSearchController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZJScrollPageViewChildVcDelegate,TJSearchScreenViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)TJSearchScreenView * superView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,strong)UICollectionView * collectionView;
@end

@implementation TJSuperSearchController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestSuperSearchListWithSuperSort:@"0"];

    self.superView = [[TJSearchScreenView alloc]initWithFrame:CGRectMake(0, 0, S_W, 45) withMargin:20];
    self.superView.backgroundColor  = [UIColor whiteColor];
    self.superView.deletage = self;
    [self.view addSubview:self.superView];
    
    [self setUITableView];
    [self setUICollectionView];
    self.tableView.hidden = YES;
    //注册观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(horizontalVerticalTransform:) name:TJHorizontalVerticalTransform object:nil];
}
- (void)requestSuperSearchListWithSuperSort:(NSString *)sort{
    self.dataArr = [NSMutableArray array];[SVProgressHUD show];
    NSString *userid = GetUserDefaults(UID);
    
    if (userid) {
    }else{
        userid = @"";
    }
    KSortingAndMD5 *MD5 = [[KSortingAndMD5 alloc]init];
    NSString *timeStr = [MD5 timeStr];
    NSString *str = [self.strsearch stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *md = @{
                                @"timestamp": timeStr,
                                @"app": @"ios",
                                @"uid":userid,
                                @"keyword":str,
                                @"sort":sort,
                                }.mutableCopy;
    NSString *md5Str = [MD5 sortingAndMD5SignWithParam:md withSecert:SECRET];
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.url = SuperSearchGoodsList;
        request.headers = @{@"timestamp": timeStr,
                            @"app": @"ios",
                            @"sign":md5Str,
                            @"uid":userid,
                            };
        request.httpMethod = kXMHTTPMethodPOST;
        request.parameters = @{@"keyword":self.strsearch,                                @"sort":sort};
    } onSuccess:^(id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = responseObject[@"data"];
        self.dataArr = [TJJHSGoodsListModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
            [self.collectionView reloadData];
        });
        
    } onFailure:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"加载失败，请重试~"];

    }];
}
-(void)setUITableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, S_W, S_H-SafeAreaTopHeight-50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TJGoodsListCell" bundle:nil] forCellReuseIdentifier:TJSearchContentFootShowCell];
    
    [self.view addSubview:self.tableView];
}
-(void)setUICollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((S_W-5)*0.5, 275);
    layout.minimumLineSpacing= 5;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, S_W, S_H-SafeAreaTopHeight-50) collectionViewLayout:layout];
    self.collectionView.backgroundColor = KBGRGB;
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TJJHSuanCell" bundle:nil] forCellWithReuseIdentifier:TJSearchContentCollectionCell];
    
    [self.view addSubview:self.collectionView];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TJGoodsListCell * cell = [tableView dequeueReusableCellWithIdentifier:TJSearchContentFootShowCell forIndexPath:indexPath];
    //    cell.model = self.dataArr[indexPath.row];
    [cell cellWithArr:self.dataArr forIndexPath:indexPath isEditing:NO withType:@"0"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TJDefaultGoodsDetailController *goodVC = [[TJDefaultGoodsDetailController alloc]init];
    TJJHSGoodsListModel *model = self.dataArr[indexPath.row];
    goodVC.gid = model.itemid;
    [self.navigationController pushViewController:goodVC animated:YES];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TJJHSuanCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TJSearchContentCollectionCell forIndexPath:indexPath];
    cell.cell_type = @"search";
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((S_W-5)/2, 275);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TJDefaultGoodsDetailController *goodVC = [[TJDefaultGoodsDetailController alloc]init];
    TJJHSGoodsListModel *model = self.dataArr[indexPath.row];
    goodVC.gid = model.itemid;
    [self.navigationController pushViewController:goodVC animated:YES];
}
-(void)superPopupFiltrateView{
    DSLog(@"呼出筛选框");
    TJMultipleChoiceView * mcv = [[TJMultipleChoiceView alloc]initWithFrame:self.view.bounds];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:mcv];
}
- (void)buttonSureSelectString:(NSMutableDictionary *)sureDict{
    //    判断超级/本地
    
}
-(void)superRequestWithKind:(NSString *)kind{
    if ([kind isEqualToString:@"综合"]) {
        DSLog(@"%@",kind);
        [self requestSuperSearchListWithSuperSort:@"0"];
        
    }else if ([kind isEqualToString:@"销量"]){
        DSLog(@"%@",kind);
        [self requestSuperSearchListWithSuperSort:@"2"];
        
    }else if ([kind isEqualToString:@"价格"]){
        DSLog(@"%@",kind);
        [self requestSuperSearchListWithSuperSort:@"5"];
        
    }else if ([kind isEqualToString:@"有券"]){
        DSLog(@"%@",kind);
        
    }else{
        DSLog(@"%@",kind);
    }
}

#pragma mark - 通知
-(void)horizontalVerticalTransform:(NSNotification*)info{
    DSLog(@"%@",info.userInfo[@"hsBool"]);
    NSNumber * num = info.userInfo[@"hsBool"];
    BOOL hs = [num boolValue];
    self.tableView.hidden = !hs;
    self.collectionView.hidden = hs;
}

@end
