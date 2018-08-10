
//
//  TJOrderInfoController.m
//  taojiamao
//
//  Created by yueyu on 2018/8/8.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import "TJOrderInfoController.h"
#import "TJOrderHeadViewCell.h"//头
#import "TJOrderInfoCell.h"//四个info
#import "TJOrderTypeCell.h"//快递类型
#import "TJOrderInfoOneCell.h"//取件码，时间
#import "TJOrderPersonCell.h"//头像
#import "TJAdressCell.h"
#import "TJAdressTwoCell.h"

#import "TJKdOrderInfoModel.h"

@interface TJOrderInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TJOrderInfoController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DSLog(@"---status--%@",self.kdstatus);
    [self loadrequestOrderInfoList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.navigationController.navigationBar.barTintColor = RGB(81, 162, 249);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, S_W, S_H) style:UITableViewStylePlain];
    tableView.backgroundColor = KBGRGB;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    [tableView registerNib:[UINib nibWithNibName:@"TJOrderHeadViewCell" bundle:nil] forCellReuseIdentifier:@"OrderHeadViewCell"];
  [tableView registerNib:[UINib nibWithNibName:@"TJOrderInfoOneCell" bundle:nil] forCellReuseIdentifier:@"OrderInfoOneCell"];
    [tableView registerNib:[UINib nibWithNibName:@"TJOrderTypeCell" bundle:nil] forCellReuseIdentifier:@"OrderTypeCell"];
    [tableView registerNib:[UINib nibWithNibName:@"TJAdressCell" bundle:nil] forCellReuseIdentifier:@"AdressCell"];
    [tableView registerNib:[UINib nibWithNibName:@"TJAdressTwoCell" bundle:nil] forCellReuseIdentifier:@"AdressTwoCell"];
    [tableView registerNib:[UINib nibWithNibName:@"TJOrderPersonCell" bundle:nil] forCellReuseIdentifier:@"OrderPersonCell"];
   [tableView registerNib:[UINib nibWithNibName:@"TJOrderInfoCell" bundle:nil] forCellReuseIdentifier:@"OrderInfoCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)loadrequestOrderInfoList{
    self.dataArr = [NSMutableArray array];
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
                                @"id":self.kdid,
                                
                                }.mutableCopy;
    NSString *md5Str = [MD5 sortingAndMD5SignWithParam:md withSecert:SECRET];
    //        DSLog(@"--%@--sign",md5Str);
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.url = UserOrderDetail;
        request.headers = @{@"timestamp": timeStr,
                            @"app": @"ios",
                            @"sign":md5Str,
                            @"uid":userid,
                            };
        request.httpMethod = kXMHTTPMethodPOST;
        request.parameters = @{ @"id":self.kdid};
    } onSuccess:^(id  _Nullable responseObject) {
        DSLog(@"----kdorder=-success-===%@",responseObject);
        self.dataArr = [TJKdOrderInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } onFailure:^(NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.kdstatus intValue]==0||[self.kdstatus intValue]==5||[self.kdstatus intValue]==6) {
        return 6;
    }else{
        return 7;}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TJKdOrderInfoModel *model = self.dataArr[0];
    if ([self.kdstatus intValue]==0||[self.kdstatus intValue]==5||[self.kdstatus intValue]==6) {
    
        if (indexPath.row==0) {
            //        订单状态
            TJOrderHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeadViewCell"];
            cell.model = model;
            return cell;
        }else if (indexPath.row==1){
            //        订单信息
            TJOrderInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoOneCell"];
            return cell;
        }else if (indexPath.row==2){
            //        快递类型
            TJOrderTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTypeCell"];
            return cell;
        }else if (indexPath.row==3){
            //        送
            TJAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdressCell"];
            return cell;
        }else if (indexPath.row==4){
            //        取件
            TJAdressTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdressTwoCell"];
            return cell;
        }else{
            //        订单号
            TJOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
            return cell;
        }
    }else{
        if (indexPath.row==0) {
            //        订单状态
            TJOrderHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeadViewCell"];
            return cell;
        }else if (indexPath.row==1){
            //        订单信息
            TJOrderInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoOneCell"];
            return cell;
        }else if (indexPath.row==2){
            //        快递类型
            TJOrderTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTypeCell"];
            return cell;
        }else if (indexPath.row==3){
            //        人
            TJOrderPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPersonCell"];
            return cell;
        }else if (indexPath.row==4){
            //        取件
            TJAdressTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdressTwoCell"];
            return cell;
        }else if (indexPath.row==5){
            //        取件
            TJAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdressCell"];
            return cell;
        }else{
            //        订单号
            TJOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
            return cell;
        }
    }
    
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.kdstatus intValue]==0||[self.kdstatus intValue]==5||[self.kdstatus intValue]==6) {
        if (indexPath.row==0) {
            return 65;
        }else if (indexPath.row==1){
            return 85;
        }else if (indexPath.row==2){
            return 85;
        }else if (indexPath.row==3){
            return 100;
        }else if (indexPath.row==4){
            return 70;
        }else{
            return 147;
        }
    }else{
        if (indexPath.row==0) {
            return 65;
        }else if (indexPath.row==1){
            return 85;
        }else if (indexPath.row==2){
            return 85;
        }else if (indexPath.row==3){
            return 90;
        }else if (indexPath.row==4){
            return 100;
        }else if (indexPath.row==5){
            return 70;
        }else{
            return 147;
        }
    }
}


@end
