
//
//  TJShareMoneyController.m
//  taojiamao
//
//  Created by yueyu on 2018/7/19.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJShareMoneyController.h"
#import "TJShareOneCell.h"
#import "TJShareTwoCell.h"
#import "TJGoodsCollectModel.h"
#import "TJKallAdImgModel.h"
#import "TJInvitationView.h"

@interface TJShareMoneyController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,ShareBtnDelegate>

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *bannerArr;

@property(nonatomic,strong)UITableView *tabelView;
@property (nonatomic, strong) SDCycleScrollView *scrollV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *shareurl;
@end

@implementation TJShareMoneyController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self requestAdImg];
    [self requestHomePageGoodsJingXuan];
    self.view.backgroundColor = RGB(245, 245, 245);
    self.title = @"分享赚钱";
    //    广告滑动
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, S_W, 160) delegate:self placeholderImage:[UIImage imageNamed:@"ad_img"]];
    cycleScrollView.showPageControl = NO;
    [self.view addSubview:cycleScrollView];
    self.scrollV = cycleScrollView;
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 160+64, S_W, S_H-160-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.tableHeaderView = img;
    [tableView registerNib:[UINib nibWithNibName:@"TJShareOneCell" bundle:nil] forCellReuseIdentifier:@"oneCell"];
    [tableView registerNib:[UINib nibWithNibName:@"TJShareTwoCell" bundle:nil] forCellReuseIdentifier:@"twoCell"];
    [self.view addSubview:tableView];
    self.tabelView = tableView;
    
}
- (void)requestAdImg{
    self.bannerArr = [NSMutableArray array];self.imgArr =
    [NSMutableArray array];
    
    [KConnectWorking requestNormalDataParam:@{ @"posid":@"18",} withRequestURL:[NSString stringWithFormat:@"%@18",KAllAdPosters] withMethodType:kXMHTTPMethodGET withSuccessBlock:^(id  _Nullable responseObject) {
        DSLog(@"---banner-%@",responseObject);
        self.bannerArr = [TJKallAdImgModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        for (TJKallAdImgModel *m in self.bannerArr) {
            [self.imgArr addObject:m.imgurl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollV.imageURLStringsGroup = self.imgArr;
        });
    } withFailure:^(NSError * _Nullable error) {
    }];
    
}
- (void)requestHomePageGoodsJingXuan{
    //    精选
    self.dataArr = [NSMutableArray array];
    NSDictionary *param = @{ @"page":@"1",
                             @"page_num":@"10",};
    [KConnectWorking requestNormalDataParam:param withRequestURL:HomePageGoods withMethodType:kXMHTTPMethodPOST withSuccessBlock:^(id  _Nullable responseObject) {
        self.dataArr = [TJGoodsCollectModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabelView reloadData];
        });
        
    } withFailure:^(NSError * _Nullable error) {
        DSLog(@"error--%@==",error);
    }];
    
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return self.dataArr.count;
    }
    return 1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 65;
    }
    return 188;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
       
        TJShareOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneCell"];
        return cell;
    }else{
        TJShareTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
        cell.model = self.dataArr[indexPath.row];
        [cell.btn_share addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)shareClick:(UIButton *)sender{
    TJShareTwoCell *cell = (TJShareTwoCell *)[[sender superview] superview];
    NSIndexPath  *index = [self.tabelView indexPathForCell:cell];
    TJGoodsCollectModel *model = self.dataArr[index.row];
    
    [KConnectWorking requestShareUrlData:@"1" withIDStr:model.itemid withSuccessBlock:^(id  _Nullable responseObject) {
        self.shareurl = responseObject[@"data"][@"share_url"];
    }];
    TJInvitationView *iview = [TJInvitationView invitationView];
    iview.backgroundColor = RGBA(1, 1, 1, 0.2);
    iview.frame = CGRectMake(0, 0, S_W, S_H);iview.delegate = self;
    [self.view addSubview:iview];
}


@end
