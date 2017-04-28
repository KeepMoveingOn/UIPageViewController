//
//  WCQSegmentView.m
//  Test
//
//  Created by wcq on 2017/4/26.
//  Copyright © 2017年 Aspire. All rights reserved.
//

#import "WCQSegmentView.h"

NSString * const ReuseIdentifier = @"ReuseIdentifier";

@interface WCQSegmentView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger itemsCount;

@end

@implementation WCQSegmentView

- (instancetype)initWithFrame:(CGRect)frame itemsCount:(NSInteger)itemsCount {

    if (self = [super initWithFrame:frame]) {
        
        _itemsCount = itemsCount;
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectedItemBlock) _selectedItemBlock(indexPath);
}

#pragma mark - Getter Methods

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    
    if (!_layout) {
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 5;
        _layout.minimumInteritemSpacing = 5;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(80, self.bounds.size.height - 10);
    }
    return _layout;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
