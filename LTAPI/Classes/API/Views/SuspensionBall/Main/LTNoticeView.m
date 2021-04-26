//
//  LTNoticeView.m
//  LTAPI
//
//  Created by 徐广江 on 2020/11/20.
//

#import "LTNoticeView.h"
#import "PrefixHeader.h"
#import "NetServers.h"
#import "NoticeModel.h"

@interface LTNoticeView()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArr;
}
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation LTNoticeView
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationTitle = @"活动公告";
        [self initData];
    }
    return self;
}
-(void)initData
{
    _dataArr = [[NSMutableArray alloc]init];
    [TipView showPreloader];
    [NetServers getActivityListWithCompletedHandler:^(NSInteger code, NSInteger debug, NSArray *infoArr, NSString *msg) {
        [TipView hidePreloader];
        if (code == 1) {
            if (infoArr.count>0) {
                NSArray *arr = [NSArray arrayWithArray:infoArr];
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NoticeModel *model = [[NoticeModel alloc]initWithDic:arr[idx]];
                    [self->_dataArr addObject:model];
                }];
                [self loadUI];
            }else{
//                UILabel *titleLab = [UILabel new];
//                titleLab.text = @"暂无公告";
//                titleLab.font = LTSDKFont(18);
//                titleLab.textColor = TEXTNOMARLCOLOR;
//                [self addSubview:titleLab];
//                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.offset(0);
//                    make.top.offset(0);
//                    make.width.equalTo(@80);
//                    make.height.equalTo(@25);
//                }];
                [self addSubview:self.emptyView];
                [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(LTSDKScale(170), LTSDKScale(120)));
                }];
            }
            
        }else{
            [TipView toast:msg supView:nil];
        }
    }];
    
    
}
-(void)loadUI
{
    
    UITableView *noticeTableView = [[UITableView alloc]init];
    noticeTableView.delegate = self;
    noticeTableView.dataSource = self;
    noticeTableView.backgroundColor = [UIColor clearColor];
    noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:noticeTableView];
    [noticeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.left.bottom.right.offset(0);
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 84;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row<_dataArr.count) {
            
            NoticeModel *model = _dataArr[indexPath.row];
            UIView *bgV = [UIView new];
            [bgV setBackgroundColor:[UIColor whiteColor]];
            bgV.layer.cornerRadius = 8;
            bgV.layer.masksToBounds = YES;
            [cell addSubview:bgV];
            [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(16);
                make.right.offset(-16);
                make.top.offset(8);
                make.bottom.offset(-8);
            }];
            
            UILabel *titleLab = [UILabel new];
            titleLab.textColor = TEXTNOMARLCOLOR;
            titleLab.text = model.title;
            titleLab.font = LTSDKFont(14);
            [bgV addSubview:titleLab];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.offset(16);
                make.right.offset(-16);
                make.height.equalTo(@20);
            }];
            
            UILabel *timeLab = [UILabel new];
            timeLab.textColor = TEXTDEFAULTCOLOR;
            timeLab.text = model.publish_time;
            timeLab.font = LTSDKFont(10);
            [bgV addSubview:timeLab];
            [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(16);
                make.top.equalTo(titleLab.mas_bottom).offset(6);
                
            }];
            
            UIImageView *rightImg = [[UIImageView alloc]initWithImage:SDK_IMAGE(@"icon_wode_more")];
            [bgV addSubview:rightImg];
            [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-16);
            }];
        }
        if(indexPath.row == _dataArr.count){
            UIView *bottomView = [[UIView alloc] init];
            [cell addSubview:bottomView];
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
            UILabel *bottomLab =[UILabel new];
            bottomLab.text =@"   全部加载完毕~ ";
            bottomLab.font = LTSDKFont(14);
            bottomLab.textColor =TEXTDEFAULTCOLOR;
            bottomLab.backgroundColor = HexColor(0xF6F6F6);
            [bottomView addSubview:bottomLab];
            
            bottomLab.layer.cornerRadius = 12;
            bottomLab.layer.masksToBounds = YES;
            
            [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-32);
                make.centerX.offset(0);
                make.height.equalTo(@24);
                make.width.equalTo(@120);
            }];
        }
        
        
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<_dataArr.count) {
        NoticeModel *model = _dataArr[indexPath.row];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(selectNoticeDetailWithModel:)]) {
            [self.delegate performSelector:@selector(selectNoticeDetailWithModel:) withObject:model];
        }
    }
    
    
    
    
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.layer.contents = (id)SDK_IMAGE(@"bg_kongbai").CGImage;
    }
    return _emptyView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
