//
//  ShopCell.h
//  Falls
//
//  Created by lvhe on 2018/12/14.
//  Copyright © 2018 lvhe. All rights reserved.
//

#import "ShopCell.h"
#import "Shop.h"
#import "UIImageView+WebCache.h"

@interface ShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation ShopCell

- (void)setShop:(Shop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:nil];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}
@end
