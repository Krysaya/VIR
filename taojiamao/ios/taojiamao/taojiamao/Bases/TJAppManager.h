//
//  TJAppManager.h
//  taojiamao
//
//  Created by yueyu on 2018/9/3.
//  Copyright © 2018年 yueyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "TJLoginController.h"


@interface TJAppManager : NSObject
singleton_interface(TJAppManager);


@property (nonatomic, weak) TJLoginController *loginVC;

@end