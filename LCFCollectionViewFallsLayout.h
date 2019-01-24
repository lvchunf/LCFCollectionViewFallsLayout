//
//  LCFCollectionViewFallsLayout.h
//  Falls
//
//  Created by lvhe on 2018/12/14.
//  Copyright © 2018 lvhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LCFCollectionViewFallsLayout;
@protocol LCFCollectionViewFallsLayoutDelegate <NSObject>

- (CGFloat)collectionViewFallsLayout:(LCFCollectionViewFallsLayout *)collectionViewFallsLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat) itemWidth;

@end

@interface LCFCollectionViewFallsLayout : UICollectionViewLayout

@property (nonatomic, weak) id<LCFCollectionViewFallsLayoutDelegate>delegate;

- (instancetype)init;

/**
 provide layout info
 @param columnCount column count,default 2
 @param columnMargin column margin, default 10
 @param rowMargin row margin, default 10
 @param edgeInsets edgeInsets, default {10, 10, 10, 10}
 @return self
 */
- (instancetype)initWithcolumnCount:(NSUInteger)columnCount columnMargin:(NSUInteger)columnMargin rowMargin:(NSInteger)rowMargin edgeInsets:(UIEdgeInsets)edgeInsets;
@end

NS_ASSUME_NONNULL_END
