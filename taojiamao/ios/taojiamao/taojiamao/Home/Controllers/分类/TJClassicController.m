
//
//  TJClassicController.m
//  taojiamao
//
//  Created by yueyu on 2018/7/17.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJClassicController.h"
#import "TJClassicSecondController.h"

#import "TJClassicSecondCell.h"
#import "TJClassicFirstCell.h"
#import "TJGoodCatesMainListModel.h"
#import "TJKallAdImgModel.h"

#import "UIViewController+Extension.h"

@interface TJClassicController ()<UITableViewDataSource,UITableViewDelegate,TabCollectCellDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong)UITableView *tableView_left;
@property (nonatomic, strong) UITableView *tableView_right;
@property (nonatomic, strong) SDCycleScrollView *scrollV;
@property (nonatomic, strong) NSMutableArray *dataArr_left;
@property (nonatomic, strong) NSMutableArray *dataArr_right;
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray *imgArr;


@property (nonatomic, strong) NSString *select_index;
@property (nonatomic, strong) NSString *index;

@end

@implementation TJClassicController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    self.select_index = @"0";
    //设置全局状态栏字体颜色为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetSystemNavibar];
    [self loadGoodsCatesList];[self requestAdImg];
    self.title = @"商品分类";
    self.view.backgroundColor = RGB(245, 245, 245);
    UITableView *tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, S_H) style:UITableViewStylePlain];
    tableV.tag = 1000;
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.tableFooterView = [UIView new];
    [tableV registerNib:[UINib nibWithNibName:@"TJClassicFirstCell" bundle:nil] forCellReuseIdentifier:@"classicFirstCell"];
   
   
    [self.view addSubview:tableV];
    self.tableView_left = tableV;
    
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(110, SafeAreaTopHeight+10, S_W-120, 100) delegate:self placeholderImage:[UIImage imageNamed:@"ad_img"]];
    cycleScrollView2.showPageControl = NO;
    cycleScrollView2.layer.cornerRadius = 10;cycleScrollView2.layer.masksToBounds = YES;
    [self.view addSubview:cycleScrollView2];
    self.scrollV = cycleScrollView2;
   
    
    UITableView *tableV2 = [[UITableView alloc]initWithFrame:CGRectMake(100, 110+SafeAreaTopHeight, S_W-100, S_H-110-64) style:UITableViewStylePlain];
    tableV2.tag = 2000;
    tableV2.delegate = self;
    tableV2.dataSource = self;
    tableV2.separatorStyle = UITableViewCellSeparatorStyleNone;

    [tableV2 registerClass:[TJClassicSecondCell class] forCellReuseIdentifier:@"classicCell"];
    [self.view addSubview:tableV2];
    self.tableView_right= tableV2;
}
- (void)requestAdImg{
    self.bannerArr = [NSMutableArray array];self.imgArr = [NSMutableArray array];
    KSortingAndMD5 *MD5 = [[KSortingAndMD5 alloc]init];
    NSString *timeStr = [MD5 timeStr];
    NSString *userid = GetUserDefaults(UID);
    if (userid) {
    }else{
        userid = @"";
    }
    NSMutableDictionary *md = @{
                                @"timestamp": timeStr,
                                @"app": @"ios",
                                @"uid":userid,
                                @"posid":@"1",
                                }.mutableCopy;
    NSString *md5Str = [MD5 sortingAndMD5SignWithParam:md withSecert:SECRET];
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.url = [NSString stringWithFormat:@"%@1",KAllAdPosters];
        request.headers = @{@"timestamp": timeStr,
                            @"app": @"ios",
                            @"sign":md5Str,
                            @"uid":userid,
                            };
        request.httpMethod = kXMHTTPMethodGET;
    } onSuccess:^(id  _Nullable responseObject) {
        DSLog(@"---banner-%@",responseObject);
        self.bannerArr = [TJKallAdImgModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        for (TJKallAdImgModel *m in self.bannerArr) {
            [self.imgArr addObject:m.imgurl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollV.imageURLStringsGroup = self.imgArr;

        });
        
    } onFailure:^(NSError * _Nullable error) {
        DSLog(@"---banner-%@",error);
        
    }];
}
- (void)loadGoodsCatesList{
    self.dataArr_left = [NSMutableArray array];
    self.dataArr_right = [NSMutableArray array];

    NSString *userid = GetUserDefaults(UID);
    
    if (userid) {
    }else{
        userid = @"";
    }
    KSortingAndMD5 *MD5 = [[KSortingAndMD5 alloc]init];
    NSString *timeStr = [MD5 timeStr];
    NSMutableDictionary *md = @{
                                @"timestamp": timeStr,
                                @"app": @"ios",
                                @"uid":userid,
                                
                                }.mutableCopy;
    NSString *md5Str = [MD5 sortingAndMD5SignWithParam:md withSecert:SECRET];
    DSLog(@"--sign==%@",md5Str);

    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.url = GoodsClassicList;
        request.headers = @{@"timestamp": timeStr,
                            @"app": @"ios",
                            @"sign":md5Str,
                            @"uid":userid,
                            };
        request.httpMethod = kXMHTTPMethodGET;
    
    } onSuccess:^(id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        for (int i=1; i<dict.count+1; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            TJGoodCatesMainListModel *model = [TJGoodCatesMainListModel mj_objectWithKeyValues:dict[str]];
            [self.dataArr_left addObject:model];
    
        }
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView_left reloadData];
            [self.tableView_right reloadData];

        });
        
    } onFailure:^(NSError * _Nullable error) {

    }];
}
#pragma mark - icarouseldelegte
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    TJHomePageModel *m = self.imgDataArr[index];
//    TJAdWebController *vc = [[TJAdWebController alloc]init];vc.url = m.flag;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark  - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==1000) {
        return 1;
    }
    
    return self.dataArr_left.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1000) {
        return self.dataArr_left.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1000) {
        return 45;
    }else{
    
        
        TJGoodCatesMainListModel *model = self.dataArr_left[indexPath.section];
        NSArray * childsArray = [model._childs componentsSeparatedByString:@","];
        NSInteger i = ceilf(childsArray.count/3.0);
        DSLog(@"0-arr-%ld===%ld",childsArray.count,i);
        if (i==0||i==1) {
            
            return 140;
        }else{
            return 125*i;
        }
    }
   
}

//section间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView.tag==1000) {
//        left
         TJClassicFirstCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"classicFirstCell"];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.model = self.dataArr_left[indexPath.row];
        if (indexPath.row==0) {//指定第一行为选中状态
            
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }
        

        return cell1;
    }else{
//        right
    
        TJGoodCatesMainListModel *model = self.dataArr_left[indexPath.section];
        TJClassicSecondCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"classicCell"];
        cell2.model = model;
        cell2.mineCellDelegate = self;
        cell2.indexSection = indexPath.section;
        return cell2;
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1000) {
        self.select_index = [NSString stringWithFormat:@"%ld",indexPath.row];
//        [self.tableView_right reloadData];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [self.tableView_right scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }else{
        
        
    }
}

-(void)collectionCell:(TJClassicSecondCell *)cell didSelectItemIndexPath:(NSIndexPath *)indexPath{
    
    TJGoodCatesMainListModel *model = self.dataArr_left[cell.indexSection];
    TJGoodCatesMainListModel *model2 = model.managedSons[indexPath.row];

    TJClassicSecondController *vc = [[TJClassicSecondController alloc]init] ;
    vc.title_class = model2.catname;
    [self.navigationController pushViewController:vc animated:YES];
   
}
@end
