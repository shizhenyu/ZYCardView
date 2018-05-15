//
//  ViewController.m
//  ZYCardView
//
//  Created by youyun on 2018/4/14.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import "ViewController.h"
#import "ZYCardView.h"
#import "BottomView.h"
#import "PasserbyModel.h"

@interface ViewController ()<ZYCardViewDelegate, BottomViewDelegate>

@property (nonatomic, strong) ZYCardView *cardView;

@property (nonatomic, strong) BottomView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
    
    [self fetchListData];
}

- (void)setupUI {
    
    [self.view addSubview:self.cardView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.trailing.bottom.mas_equalTo(0);
        
        make.top.equalTo(self.cardView.mas_bottom);
        
    }];
}

#pragma mark - Load Data
- (void)fetchListData {
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PasserbyListData" ofType:@"plist"];
    
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSDictionary *dic in arr) {
        
        PasserbyModel *model = [PasserbyModel mj_objectWithKeyValues:dic];
        
        [self.dataSource addObject:model];
    }
    
    self.cardView.dataArr = self.dataSource;
    
    [self.cardView reloadData];
    
}

#pragma mark - ZYCardViewDelegate
- (void)cardView:(ZYCardView *)cardView didClickHeaderImageViewAtIndex:(NSInteger)index cardItem:(ZYCardItem *)cardItem {
    
    NSLog(@"点击%@的图片", cardItem.model.name);
}

- (void)didClickDetailEventAtIndex:(NSInteger)index {
    
    PasserbyModel *model = [self.dataSource objectAtIndex:index];
    
    NSLog(@"查看%@的详细信息", model.name);
}

- (void)cardItem:(ZYCardItem *)cardItem didSwipedDirectionLorR:(BOOL)isLike {
    
    NSString *likeStatus = isLike ? @"喜欢":@"不喜欢";
    
    NSLog(@"%@%@", likeStatus, cardItem.model.name);
}

#pragma mark - BottomViewDelegate
- (void)bottomViewActionToDo:(NSInteger)tag {
    
    switch (tag) {
        case 10:
        {
            [self.cardView refreshAllCards];
        }
            break;
            
        case 11:
        {
            [self.cardView unlikeCurrentCard];
        }
            break;
            
        case 12:
        {
            [self.cardView likeCurrentCard];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载
- (ZYCardView *)cardView {
    
    if (!_cardView) {
        
        _cardView = [[ZYCardView alloc] initWithFrame:CGRectMake(16, 80, kScreenWidth - 32, kScreenWidth - 32 + 92)];
        
        _cardView.delegate = self;
        
    }
    
    return _cardView;
}

- (BottomView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[BottomView alloc] init];
        
        _bottomView.delegate = self;
        
        [self.view addSubview:_bottomView];
    }
    
    return _bottomView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
