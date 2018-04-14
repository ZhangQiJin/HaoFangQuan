//
//  WSSearchViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSSearchViewController.h"
#import "WSSearchResultViewController.h"
@interface WSSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(strong,nonatomic)NSMutableArray *historyData;
@property(assign,nonatomic)int chooseSatatus;
@end

@implementation WSSearchViewController
#define chooseStatusDown 0
#define chooseStatusUp 1
-(NSMutableArray*)historyData{
    if (_historyData == nil) {
        _historyData = [NSMutableArray array];
    }
    return _historyData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchTF.delegate = self;
    [self.searchHistoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"historyCell"];
    //self.historyData = [NSMutableArray array];
    [self setUpAppearance];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *savedArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"searchHistoryArray"];
    self.historyData = [savedArray mutableCopy];
    [self.searchHistoryTableView reloadData];
}
-(void)setUpAppearance{
    self.chooseSatatus = chooseStatusUp;
    self.searchHistoryTableView.tableFooterView = [[UIView alloc]init];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.historyData.count>0) {
        return self.historyData.count;
    }else{
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    if (self.historyData.count>0) {
        cell.textLabel.text = self.historyData[indexPath.row];
    }else{
        cell.textLabel.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchTF.text = self.historyData[indexPath.row];
    
    WSSearchResultViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultVC"];
    resultVC.search = self.searchTF.text;
    NSString *typeString = self.currentTypeLabel.text;
    if ([typeString isEqualToString:@"新房"]) {
        resultVC.type = @"0";
    }else if ([typeString isEqualToString:@"二手房"]){
        resultVC.type = @"1";
    }else{
        resultVC.type = @"2";
    }
    [self.navigationController showViewController:resultVC sender:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    NSString *searchString = textField.text;
//    NSLog(@"searchString%@",searchString);
//    if (self.historyData.count <4) {
//        [self.historyData addObject:searchString];
//    }else{
//        [self.historyData removeObjectAtIndex:0];
//        [self.historyData addObject:searchString];
//    }
//    NSLog(@"BFsavedArray%@",self.historyData);
//    [self.searchHistoryTableView reloadData];
//    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
//    [defa setObject:self.historyData forKey:@"searchHistoryArray"];
//    [defa synchronize];
//    NSLog(@"savedArray%@",self.historyData);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelSearch:(id)sender {
    //self.searchTF.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteSearchHistory:(id)sender {
    [self.historyData removeAllObjects];
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    [defau setObject:nil forKey:@"searchHistoryArray"];
    [defau synchronize];
    [self.searchHistoryTableView reloadData];
}

- (IBAction)startSearch:(id)sender {
    //临时跳转查询结果页面
    WSSearchResultViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultVC"];
    resultVC.search = self.searchTF.text;
    NSString *typeString = self.currentTypeLabel.text;
    if ([typeString isEqualToString:@"新房"]) {
        resultVC.type = @"0";
    }else if ([typeString isEqualToString:@"二手房"]){
        resultVC.type = @"1";
    }else{
        resultVC.type = @"2";
    }
    [self.navigationController showViewController:resultVC sender:nil];
}
- (IBAction)chooseHouseType:(id)sender {
    if (self.chooseSatatus == chooseStatusDown) {
        self.houseTypeBackView.hidden = YES;
        self.chooseStateIndexButton.selected = NO;
        self.chooseSatatus = chooseStatusUp;
    }else{
        self.houseTypeBackView.hidden = NO;
        self.chooseStateIndexButton.selected = YES;
        self.chooseSatatus = chooseStatusDown;
    }
}
- (IBAction)selectdCurrentType:(id)sender {
    UIButton *currentButton = sender;
    currentButton.titleLabel.textColor = [UIColor orangeColor];
    NSString *currentType = currentButton.titleLabel.text;
    self.currentTypeLabel.text = currentType;
    self.houseTypeBackView.hidden = YES;
    self.chooseStateIndexButton.selected = NO;
}

- (IBAction)finishInput:(id)sender {
    NSString *searchString = self.searchTF.text;
    
    for (NSString *str in self.historyData) {
        if ([str isEqualToString:searchString]) {
            [self.historyData removeObject:str];
        }
    }
    [self.historyData addObject:searchString];
//    if (self.historyData.count <4) {
//        [self.historyData addObject:searchString];
//    }else{
//        [self.historyData removeObjectAtIndex:0];
//        [self.historyData addObject:searchString];
//    }
    
    [self.searchHistoryTableView reloadData];
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    [defa setObject:self.historyData forKey:@"searchHistoryArray"];
    [defa synchronize];
    
    WSSearchResultViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultVC"];
    resultVC.search = self.searchTF.text;
    NSString *typeString = self.currentTypeLabel.text;
    if ([typeString isEqualToString:@"新房"]) {
        resultVC.type = @"0";
    }else if ([typeString isEqualToString:@"二手房"]){
        resultVC.type = @"1";
    }else{
        resultVC.type = @"2";
    }
    [self.navigationController showViewController:resultVC sender:nil];
}
@end
