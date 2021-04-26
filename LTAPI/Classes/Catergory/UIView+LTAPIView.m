//
//  UIView+LTAPIView.m
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/30.
//

#import "UIView+LTAPIView.h"
#import <objc/runtime.h>
@interface UIView()

@property (nonatomic,strong) CAShapeLayer *borderLayer;
@end

@implementation UIView (LTAPIView)

- (void)setBorderLayer:(CAShapeLayer *)borderLayer {
    objc_setAssociatedObject(self, @selector(borderLayer), borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)borderLayer {
   return objc_getAssociatedObject(self, _cmd);
}

- (void)cornerRadi:(CGFloat)corner rectCorner:(UIRectCorner)corener borderColor:(UIColor *)borderColor {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corener cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    layer.masksToBounds = YES;
    //添加圆角
    self.layer.mask = layer;
    if (!self.borderLayer.superlayer) {
        self.borderLayer = [CAShapeLayer layer];
    }else {
        [self.borderLayer removeFromSuperlayer];
    }
    [self.layer addSublayer:self.borderLayer];
    self.borderLayer.frame = self.bounds;
    self.borderLayer.path = path.CGPath;
    self.borderLayer.lineWidth = 1.5;
    self.borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLayer.strokeColor = borderColor.CGColor;
}

@end
