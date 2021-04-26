//
//  PayStyleView.h
//  Pods
//
//  Created by Zaoym on 2020/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//typedef void(^SelectedPaySytleBlock)(void);
@interface PayStyleView : UIView

@property (nonatomic,copy)NSString *payStyleNameStr;
//@property (nonatomic,copy)SelectedPaySytleBlock payStyleBlock;
@property (nonatomic,strong)UIButton *rightSelectedBtn;
@property (nonatomic,strong)UIImageView *leftImgView;
@property (nonatomic,strong)UILabel *payStyleLabel;
@end

NS_ASSUME_NONNULL_END
