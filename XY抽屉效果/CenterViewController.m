//
//  CenterViewController.m
//  XY抽屉效果
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "CenterViewController.h"
#import "XYItemModel.h"
#import "XYHomeCell.h"
#import "DetailViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#define kItemW ((XYScreenW - 20)/2)

@interface CenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic ,strong)NSMutableArray *dataArr;

@property (nonatomic ,strong)UICollectionView *collectionView;

@property (nonatomic  )    NSInteger pageIndex;

@property (nonatomic )      BOOL isChange;
@property (nonatomic )      BOOL  isH;

@end

@implementation CenterViewController

static NSString * identifier = @"homeCell";

-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setUpTheRequst];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self setUpTheMJ];
    
    [self setUpTheGestureRecognizer];
    // Do any additional setup after loading the view.
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kItemW,180);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        layout.minimumInteritemSpacing = 5;
        
        layout.minimumLineSpacing = 10;
        
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XYHomeCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}
#pragma mark ---collectionView代理、数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XYHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    XYItemModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XYItemModel *model = self.dataArr[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    detailVC.model = model;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.collectionView.contentOffset.y >= self.collectionView.contentSize.height - XYScreenH-180) {
        _pageIndex += 2;
        NSString * urlStr = [NSString stringWithFormat:@"%@%@%@",HomeUrlH,@(_pageIndex),HomeUrlF];
        self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
           [self setMoreRequst:urlStr];
        }];
        
    }
    
}
#pragma mark ---网络请求

-(void)setUpTheRequst{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",HomeUrlH,@1,HomeUrlF];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *itemDict = obj[@"data"];
            NSArray *arr = itemDict[@"rooms"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
                XYItemModel *model = [XYItemModel itemModelWithDictionary:dict];
                [mArr addObject:model];
            }
            weakSelf.dataArr = mArr;
        }
        [weakSelf.collectionView reloadData];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)setMoreRequst:(NSString *)str{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *itemDict = obj[@"data"];
            NSArray *arr = itemDict[@"rooms"];
            for (NSDictionary *dict in arr) {
                XYItemModel *model = [XYItemModel itemModelWithDictionary:dict];
                [weakSelf.dataArr addObject:model];
            }
        }
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

#pragma mark ----下拉刷新
-(void)setUpTheMJ{
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf setUpTheRequst];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];

}

#pragma mark ----设置轻扫手势

-(void)setUpTheGestureRecognizer{
    // 轻扫手势
    UISwipeGestureRecognizer *leftswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftswipeGestureAction:)];
    
    // 设置清扫手势支持的方向
    leftswipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    // 添加手势
    [self.view addGestureRecognizer:leftswipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightswipeGestureAction:)];
    
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipeGesture];
}

/**
 *  左轻扫
 */
- (void)leftswipeGestureAction:(UISwipeGestureRecognizer *)sender {
    
    UINavigationController *centerNC = self.navigationController;
    
    LeftViewController *leftVC  = self.navigationController.parentViewController.childViewControllers[0];
    RightViewController *rightVC = self.navigationController.parentViewController.childViewControllers[1];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            _isChange = !_isChange;
            return;
        }else {
            
            centerNC.view.frame = CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            leftVC.view.frame =CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        }
    }];
}

/**
 *  右轻扫
 */
- (void)rightswipeGestureAction:(UISwipeGestureRecognizer *)sender {
    UINavigationController *centerNC = self.navigationController;
    
    RightViewController *rightVC = self.navigationController.parentViewController.childViewControllers[1];
    
    LeftViewController *leftVC  = self.navigationController.parentViewController.childViewControllers[0];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            
        }else{
            centerNC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
        }
    }];
    
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
