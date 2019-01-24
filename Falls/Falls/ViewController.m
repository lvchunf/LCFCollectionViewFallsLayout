//
//  ViewController.m
//  Falls
//
//  Created by lvhe on 2018/12/14.
//  Copyright © 2018 lvhe. All rights reserved.
//

#import "ViewController.h"
#import "LCFCollectionViewFallsLayout.h"
#import "ShopCell.h"
#import "Shop.h"
#import "MJRefresh.h"
#import "MJExtension.h"

@interface ViewController ()<UICollectionViewDataSource,LCFCollectionViewFallsLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, strong) UICollectionView *colletionView;

@end

static NSString* const shopId = @"shop";

@implementation ViewController

- (NSMutableArray *)shops {
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    
    [self setupRefreshView];
}

- (void)setupCollectionView {
    LCFCollectionViewFallsLayout *layout = [[LCFCollectionViewFallsLayout alloc] initWithcolumnCount:2 columnMargin:20 rowMargin:20 edgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    layout.delegate = self;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    collection.dataSource = self;
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCell class]) bundle:nil] forCellWithReuseIdentifier:shopId];
    [self.view addSubview:collection];
    self.colletionView = collection;
    
    self.title = @"瀑布流";
}

- (void)setupRefreshView {
    self.colletionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.colletionView.header endRefreshing];
            [self.shops removeAllObjects];
            NSArray *shops = [Shop objectArrayWithFilename:@"1.plist"];
            [self.shops addObjectsFromArray:shops];
            [self.colletionView reloadData];
        });
    }];
    [self.colletionView.header beginRefreshing];
    
    self.colletionView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.colletionView.footer endRefreshing];
            NSArray *shops = [Shop objectArrayWithFilename:@"1.plist"];
            [self.shops addObjectsFromArray:shops];
            [self.colletionView reloadData];
        });
    }];
    self.colletionView.footer.hidden = YES;
}

#pragma mark ---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.colletionView.footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopId forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.row];
    return cell;
}

#pragma mark ---LCFCollectionViewFallsLayoutDelegate
- (CGFloat)collectionViewFallsLayout:(LCFCollectionViewFallsLayout *)fallsLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    Shop *shop = self.shops[index];
    return shop.h * itemWidth / shop.w;
}

@end
