//
//  LTABaseView.m
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/26.
//

#import "LTABaseView.h"
#import "Masonry.h"
#import "TipView.h"
#import "PrefixHeader.h"
#import "UIView+LTAPIView.h"

@interface LTALoginTextField ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputTFView;

@end

@implementation LTALoginTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.rectCorner = UIRectCornerAllCorners;
        [self initUI];
        self.maxTextLenth = 20;
        [self.inputTFView addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)textFieldChange:(UITextField *)tf {
    !self.textFieldDidChange?:self.textFieldDidChange(tf);
    if (tf.text.length > 0 &&tf.text.length > self.maxTextLenth) {
        tf.text = [tf.text substringToIndex:self.maxTextLenth];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = HexColor(0xFFFFFF);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.inputTFView];
    [self.inputTFView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self).offset(5);
         make.top.equalTo(self).offset(5);
         make.right.equalTo(self).offset(-5);
         make.bottom.equalTo(self).offset(-5);
     }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

}

- (void)setLeftBtn:(UIView *)leftBtn {
    if (_leftBtn) {
        [_leftBtn removeFromSuperview];
    }
    _leftBtn = leftBtn;
    [self addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.size.equalTo(@(leftBtn.frame.size));
    }];
    [self.inputTFView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_rightBtn) {
            make.right.equalTo(_rightBtn.mas_left).offset(5);
        }else {
            make.right.equalTo(self).offset(-5);
        }
        make.top.equalTo(self).offset(5);
        make.left.equalTo(_leftBtn.mas_right).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
}

- (void)setRightBtn:(UIView *)rightBtn {
    if (_rightBtn) {
        [_rightBtn removeFromSuperview];
    }
    _rightBtn = rightBtn;
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.equalTo(@(rightBtn.frame.size));
        //make.width.height.equalTo(self.mas_height).offset(-2);
    }];
    [self.inputTFView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_leftBtn) {
            make.left.equalTo(_leftBtn.mas_right).offset(10);
        }else {
            make.left.equalTo(self).offset(10);
        }
        make.top.equalTo(self).offset(10);
        make.right.equalTo(_rightBtn.mas_left).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (UITextField *)inputTFView {
    if (!_inputTFView) {
        _inputTFView = [[UITextField alloc] init];
        _inputTFView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTFView.delegate = self;
        _inputTFView.textColor = TEXTNOMARLCOLOR;// UIColor.blackColor;
    }
    return _inputTFView;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    _inputTFView.secureTextEntry = secureTextEntry;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
}

- (void)setPlaceholderText:(NSAttributedString *)placeholderText {
    _placeholderText = placeholderText;
    self.inputTFView.attributedPlaceholder = placeholderText;
    self.inputTFView.adjustsFontSizeToFitWidth = YES;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    _delegate = delegate;
    self.inputTFView.delegate = delegate;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.inputTFView.keyboardType = keyboardType;
}

- (NSString *)text {
    return self.inputTFView.text;
}

- (void)setText:(NSString *)text {
    self.inputTFView.text = text;
}

- (void)setIsRedius:(BOOL)isRedius {
    _isRedius = isRedius;
    if (_isRedius) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = TEXTBorderCOLOR.CGColor;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

@interface LTABaseView ()


@end

@implementation LTABaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configNotify];
        self.backgroundColor = DEFAULTBGCOLOR;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configNotify];
    }
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = LTSDKFont(18);
        _title.textColor = TEXTNOMARLCOLOR;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (void)configNotify {
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.equalTo(self);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardManager:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardManager:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardManager:(NSNotification *)notify{
    CGFloat animation = [notify.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect kebordRect = [notify.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    id firstView =  [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    if (![firstView isKindOfClass:[UIView class]]) {
        return;
    }
    UIView * view = (UIView *)firstView;
    CGRect viewBonse = [firstView convertRect:view.frame toView:nil];
    if ([notify.name isEqualToString:UIKeyboardWillShowNotification]) {
        if (kebordRect.origin.y < CGRectGetMaxY(viewBonse)) {
            [UIView animateWithDuration:animation animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, kebordRect.origin.y - CGRectGetMaxY(viewBonse) - 10);
            }];
        }
    }else if ([notify.name isEqualToString:UIKeyboardWillHideNotification]){
        [UIView animateWithDuration:animation animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)hidenFastRegiestAction {}

- (void)hidenPhoneRegiestAction {}

@end
