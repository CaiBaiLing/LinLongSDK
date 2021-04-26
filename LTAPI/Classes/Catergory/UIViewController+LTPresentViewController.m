//
//  UIViewController+LTPresentViewController.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/8.
//

#import "UIViewController+LTPresentViewController.h"

#import <objc/runtime.h>

@implementation UIViewController (LTPresentViewController)

+ (void)load {
    SEL sel = @selector(presentViewController:animated:completion:);
    SEL customSel = @selector(LT_presentViewController:animated:completion:);
    method_exchangeImplementations(class_getClassMethod(self, customSel), class_getClassMethod(self, sel));
}

- (void)LT_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [self LT_presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
