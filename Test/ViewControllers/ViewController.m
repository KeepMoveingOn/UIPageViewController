//
//  ViewController.m
//  Test
//
//  Created by wcq on 2017/4/18.
//  Copyright © 2017年 Aspire. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerA.h"
#import "ViewControllerB.h"
#import "ViewControllerC.h"
#import "ViewControllerD.h"

#import "WCQSegmentView.h"

//#define usingPageViewController

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ViewController()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WCQSegmentView *segmentView;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIViewController *pengdingViewController;
@property (nonatomic, strong) NSArray<UIViewController *> *childViewControllersArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIScrollView *scrollerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _currentIndex = 0;
    
#ifdef usingPageViewController
    
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view addSubview:self.pageViewController.view];
#else

    [self.view addSubview:self.scrollerView];
#endif
    [self.view addSubview:self.segmentView];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger beforeIndex = _currentIndex - 1;
    if (beforeIndex < 0) return nil;
    
    return self.childViewControllersArray[beforeIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger afterIndex = _currentIndex + 1;
    if (afterIndex > self.childViewControllersArray.count - 1) return nil;

    return self.childViewControllersArray[afterIndex];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    _pengdingViewController = pendingViewControllers.firstObject;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        
        [self.childViewControllersArray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (_pengdingViewController == obj) {
                
                _currentIndex = idx;
                *stop = YES;
            }
        }];
    }
}

#pragma mark - Getter Methods

- (WCQSegmentView *)segmentView {
    
    __weak typeof(self) weakSelf = self;
    if (!_segmentView) {
        
        _segmentView = [[WCQSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)
                                                  itemsCount:self.childViewControllersArray.count];
        [_segmentView setSelectedItemBlock:^(NSIndexPath *indexPath) {
            
#ifdef usingPageViewController

            if (indexPath.row > weakSelf.currentIndex) {
                [weakSelf.pageViewController setViewControllers:@[weakSelf.childViewControllersArray[indexPath.row]]
                                                      direction:UIPageViewControllerNavigationDirectionForward
                                                       animated:YES
                                                     completion:nil];
            }else {
                [weakSelf.pageViewController setViewControllers:@[weakSelf.childViewControllersArray[indexPath.row]]
                                                      direction:UIPageViewControllerNavigationDirectionReverse
                                                       animated:YES
                                                     completion:nil];
            }
#else
            
            [weakSelf.scrollerView setContentOffset:CGPointMake(indexPath.row * SCREEN_WIDTH, 0) animated:YES];
#endif
            
            weakSelf.currentIndex = indexPath.row;
        }];
        
    }
    return _segmentView;
}

- (UIPageViewController *)pageViewController {
    
    if (!_pageViewController) {
        
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        _pageViewController.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        [_pageViewController setViewControllers:@[self.childViewControllersArray[_currentIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageViewController;
}

- (NSArray<UIViewController *> *)childViewControllersArray {
    
    if (!_childViewControllersArray) {
        
        _childViewControllersArray = @[[[ViewControllerA alloc] init],
                                       [[ViewControllerB alloc] init],
                                       [[ViewControllerC alloc] init],
                                       [[ViewControllerD alloc] init]];
    }
    return _childViewControllersArray;
}

- (UIScrollView *)scrollerView {
    
    if (!_scrollerView) {
        
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH * self.childViewControllersArray.count, SCREEN_HEIGHT - 64);
        _scrollerView.pagingEnabled = YES;
        __weak typeof(self) weakSelf = self;
        [self.childViewControllersArray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.view.frame = CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            [weakSelf addChildViewController:obj];
            [obj didMoveToParentViewController:weakSelf];
            [_scrollerView addSubview:obj.view];
        }];
    }
    return _scrollerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
