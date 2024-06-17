//
//  ModalViewController.m
//  BottomSheet
//
//  Created by ZB on 2024/6/13.
//

#import "ModalViewController.h"
#import "ZBChangeNetWorkCell.h"
#import <Masonry.h>
#define scrollHeight 240 + kBottomSafeHeight

@interface ModalViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIControl *maskView;
@property (nonatomic, strong) UIView *contentViews;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSArray *detailArray;
@property (assign, nonatomic) NSIndexPath *selIndex;      //单选选中的行

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.view.frame)-30, 300)];
    lab.text = @"描述：如果自定义停留点的外部输入（例如捕获的属性）发生变化，调用此方法通知表单在下一个布局传递中重新评估停留点。如果 detents 仅包含系统停留点，或者自定义停留点仅使用传入的上下文信息，则无需调用此方法。在 animateChanges: 块中调用此方法以动画方式将自定义停留点调整到新高度。";
    lab.font = [UIFont systemFontOfSize:18];
    lab.numberOfLines = 0;
    lab.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:lab];
    
    NSInteger indx = 0;
    self.selIndex = [NSIndexPath indexPathForRow:indx inSection:0];
    self.dataArray = @[@"测试环境", @"正式环境"];
    self.detailArray = @[@"https://api-test.crazeid.com", @"https://neptune.crazeid.com"];
    [self createUI];
}

- (void)createUI {
    self.contentViews = ({
        UIView *aView = [[UIView alloc] init];
        aView.backgroundColor = UIColor.whiteColor;
        aView.layer.cornerRadius = 25;
        aView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        aView;
    });
    [self.view addSubview:self.contentViews];
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(scrollHeight);
    }];
    
    [self.contentViews addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.leading.mas_equalTo(18);
        make.height.mas_equalTo(44);
    }];
    
    [self.contentViews addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(5);
        make.leading.mas_equalTo(18);
        make.trailing.mas_equalTo(-18);
    }];
    
    [self.contentViews addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(5);
        make.leading.mas_equalTo(18);
        make.trailing.mas_equalTo(-18);
        make.bottom.mas_equalTo(self.contentViews).offset(-30 -kBottomSafeHeight);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZBChangeNetWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZBChangeNetWorkCell"];
    cell.titleLab.text = self.dataArray[indexPath.row];
    cell.detailLab.text = self.detailArray[indexPath.row];
    if (self.selIndex == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.imageView.backgroundColor = UIColor.greenColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消之前的选择
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:self.selIndex];
    celled.accessoryType = UITableViewCellAccessoryNone;

    //记录当前的选择的位置
    self.selIndex = indexPath;
    
    //当前选择的打钩
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)doneButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.text = @"选择网络环境";
    }
    return _titleLab;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = UIColor.whiteColor;
        table.estimatedRowHeight = 44;
        table.sectionHeaderHeight = 0.01;
        [table registerClass:ZBChangeNetWorkCell.class forCellReuseIdentifier:@"ZBChangeNetWorkCell"];
        table.tableFooterView = [[UIView alloc]init];
        if (@available(iOS 15.0, *)) {
            table.sectionHeaderTopPadding = 0.0;
        } else {
            // Fallback on earlier versions
        }
        _tableView = table;
    }
    return _tableView;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.systemBlueColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 22;
        _doneBtn = btn;
    }
    return _doneBtn;
}

- (void)dealloc{
    NSLog(@"喔！我死了");
}

@end