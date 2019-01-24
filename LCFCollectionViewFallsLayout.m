//
//  LCFCollectionViewFallsLayout.m
//  Falls
//
//  Created by lvhe on 2018/12/14.
//  Copyright © 2018 lvhe. All rights reserved.
//

#import "LCFCollectionViewFallsLayout.h"

@interface LCFCollectionViewFallsLayout ()
{
    CGFloat _rowMargin;
    CGFloat _columnMargin;
    CGFloat _columnCount;
    UIEdgeInsets _edgeInsets;
}

/** 布局属性数组 */
@property (nonatomic, strong) NSMutableArray *attrsArr;

/** 记录所有列的高度 */
@property (nonatomic, strong) NSMutableArray *columnMaxYs;

@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation LCFCollectionViewFallsLayout

- (instancetype)init {
    NSInteger defaultColumnCount = 2;
    CGFloat defaultColumnMargin = 10;
    CGFloat defaultRowMargin = 10;
    UIEdgeInsets defaultEdgeInsets = {10, 10, 10, 10};
    return [self initWithcolumnCount:defaultColumnCount columnMargin:defaultColumnMargin rowMargin:defaultRowMargin edgeInsets:defaultEdgeInsets];
}

- (instancetype)initWithcolumnCount:(NSUInteger)columnCount columnMargin:(NSUInteger)columnMargin rowMargin:(NSInteger)rowMargin edgeInsets:(UIEdgeInsets)edgeInsets {
    if (self = [super init]) {
        _columnCount = columnCount;
        _columnMargin = columnMargin;
        _rowMargin = rowMargin;
        _edgeInsets = edgeInsets;
    }
    return self;
}

/** 初始化 */
- (void)prepareLayout {
    [super prepareLayout];
    
    //初始化columnMaxYs
    [self.columnMaxYs removeAllObjects];
    for (NSInteger i = 0; i < _columnCount; i++) {
        [self.columnMaxYs addObject:@(_edgeInsets.top)];
    }
    
    [self.attrsArr removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArr addObject:attrs];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArr;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    // 设置布局属性的frame
    CGFloat w = (collectionViewW - _edgeInsets.left - _edgeInsets.right - (_columnCount - 1) * _columnMargin) / _columnCount;
    CGFloat h = 0;
    if ([self.delegate respondsToSelector:@selector(collectionViewFallsLayout:heightForItemAtIndex:itemWidth:)]) {
        h = [self.delegate collectionViewFallsLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    }else {
        h = w;
    }
    
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnMaxY = [self.columnMaxYs[0] doubleValue];
    for (NSInteger i = 1; i < _columnCount; i++) {
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        if (minColumnMaxY > columnMaxY) {
            minColumnMaxY = columnMaxY;
            destColumn = i;
        }
    }
    
    CGFloat x = _edgeInsets.left + destColumn * (w + _columnMargin);
    CGFloat y = minColumnMaxY;
    if (y != _edgeInsets.top) {
        y += _rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短那列的高度
    self.columnMaxYs[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnMaxYs[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.contentHeight + _edgeInsets.bottom);
}

#pragma mark ------ lazy
- (NSMutableArray *)columnMaxYs {
    if (!_columnMaxYs) {
        _columnMaxYs = [NSMutableArray array];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)attrsArr {
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

@end
