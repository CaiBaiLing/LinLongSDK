//
//  LTUserCenterUserAccountCell.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/7.
//

#import <UIKit/UIKit.h>
#import "LTMeMainView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LTUserCenterUserAccountCell: UITableViewCell

- (void)setAccontName:(NSString *)accontName headImage:(NSString *)headImage chenageAccountBlock:(void(^)(void))changAccontBlock;

@end

NS_ASSUME_NONNULL_END
