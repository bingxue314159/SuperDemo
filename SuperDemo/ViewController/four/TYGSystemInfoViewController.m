//
//  TYGSystemInfoViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 2017/12/28.
//  Copyright © 2017年 TYG. All rights reserved.
//

#import "TYGSystemInfoViewController.h"
#import "TYGBatteryInfo.h"
#import "TYGDeviceInfo.h"
#import "CommonHeader.h"
#import "TYGNetworkUtility.h"
#import "TYGSimInfo.h"

@interface TYGSystemInfoViewController (){
    
    NSArray *headerTitles;
    NSMutableArray *titlesArray;
    NSMutableArray *detailTitlesArray;
}

@end

@implementation TYGSystemInfoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"print");
        titlesArray = [NSMutableArray arrayWithCapacity:10];
        detailTitlesArray = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self createData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化数据
- (void)createData {
    
    headerTitles = @[@"基本信息",@"电池",@"CPU",@"内存",@"存储",@"其它",@"网络(en0)",@"SIM"];
    
    //基本信息
    const NSString *deviceName = [[TYGDeviceInfo sharedManager] getDeviceName];//设备名称
    NSString *deviceModel = [[TYGDeviceInfo sharedManager] getDeviceModel];//设备Model，e.g. @"iPhone7,2"
    NSString *iPhoneName = [UIDevice currentDevice].name;//获取iPhone名称，e.g. "My iPhone"
    NSString *systemModel = [[UIDevice currentDevice] model];//本机类型--e.g. @"iPhone", @"iPod, @"iPhone Simulator"
    NSString *localizedModel = [UIDevice currentDevice].localizedModel;//localized version of model
    NSString *systemName = [[UIDevice currentDevice] systemName];//IOS系统名称 e.g. @"iPhone OS",@"iOS"
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];//IOS系统版本号 e.g. 7.0.3
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//UUID--MacUUID(App重装后UUID会改变)
    NSString *idfa = [[TYGDeviceInfo sharedManager] getIDFA];//广告标识
    NSString *systemLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];//获取当前语言
    NSDate *systemUpdate = [[TYGDeviceInfo sharedManager] getSystemUptime];//获取设备上次重启的时间
    
    NSArray *baseinfoTitleArray = @[@"deviceName",@"deviceModel",@"iPhoneName",@"systemModel",@"localizedModel",@"systemName",@"systemVersion",@"UUID",@"IDFA",@"systemLanguage",@"systemUpdate"];
    NSArray *baseinfoDetailArray = @[deviceName,deviceModel,iPhoneName,systemModel,localizedModel,systemName,systemVersion,uuid,idfa,systemLanguage,systemUpdate];
    
    [titlesArray addObject:baseinfoTitleArray];
    [detailTitlesArray addObject:baseinfoDetailArray];
    
    //电池
    NSArray *batteryTitleArray = @[@"capacity",@"voltage",@"levelPercent(%)",@"levelMAH",@"batteryStatus"];
    __block NSMutableArray *batteryDetailArray = [NSMutableArray arrayWithCapacity:batteryTitleArray.count];
    
    [titlesArray addObject:batteryTitleArray];
    [detailTitlesArray addObject:batteryDetailArray];
    
    WeekSelf(weakSelf)
    [[TYGBatteryInfo sharedManager] startBatteryMonitoringCallback:^(TYGBatteryInfo *sender) {
        StrongSelf(strongSelf)
        
        NSUInteger capacity = [sender capacity];
        CGFloat voltage = [sender voltage];
        NSUInteger levelPercent = [sender levelPercent];
        NSUInteger levelMAH = [sender levelMAH];
        NSString *batteryStatus = [sender status];
        
        [batteryDetailArray addObjectsFromArray:@[[NSNumber numberWithUnsignedInteger:capacity],[NSNumber numberWithFloat:voltage],[NSString stringWithFormat:@"%lu%%",(unsigned long)levelPercent],[NSNumber numberWithUnsignedInteger:levelMAH],batteryStatus]];
        
        [sender stopBatteryMonitoring];
        
        [strongSelf.tableView reloadData];
    }];
    
    //CPU
    NSUInteger CPUFrequency = [[TYGDeviceInfo sharedManager] getCPUFrequency];//CPU频率
    NSUInteger BusFrequency = [[TYGDeviceInfo sharedManager] getBusFrequency];//获取总线程频率
    NSUInteger RamSize = [[TYGDeviceInfo sharedManager] getRamSize];//获取当前设备主存
    NSString *CPUProcessor = [[TYGDeviceInfo sharedManager] getCPUProcessor];//获取CPU名称
    NSUInteger CPUCount = [[TYGDeviceInfo sharedManager] getCPUCount];//获取CPU数量
    CGFloat CPUUsage = [[TYGDeviceInfo sharedManager] getCPUUsage];//获取CPU总的使用百分比
    NSArray *PerCPUUsage = [[TYGDeviceInfo sharedManager] getPerCPUUsage];//获取单个CPU使用百分比
    
    NSArray *cpuTitleArray = @[@"CPU频率",@"总线程频率",@"当前设备主存",@"CPU",@"CPU数量",@"CPU总的使用百分比",@"单个CPU使用百分比"];
    NSArray *cpuDetailArray = @[[NSNumber numberWithUnsignedInteger:CPUFrequency],[NSNumber numberWithUnsignedInteger:BusFrequency],[[TYGDeviceInfo sharedManager] fileSizeToString:RamSize],SAFE_STRING(CPUProcessor),[NSNumber numberWithUnsignedInteger:CPUCount],[NSNumber numberWithFloat:CPUUsage],[PerCPUUsage componentsJoinedByString:@"~~"]];
    
    [titlesArray addObject:cpuTitleArray];
    [detailTitlesArray addObject:cpuDetailArray];
    
    //内存
    int64_t TotalMemory = [[TYGDeviceInfo sharedManager] getTotalMemory];//获取总内存空间
    int64_t ActiveMemory = [[TYGDeviceInfo sharedManager] getActiveMemory];//获取活跃的内存空间
    int64_t InActiveMemory = [[TYGDeviceInfo sharedManager] getInActiveMemory];//获取不活跃的内存空间
    int64_t FreeMemory = [[TYGDeviceInfo sharedManager] getFreeMemory];//获取空闲的内存空间
    int64_t UsedMemory = [[TYGDeviceInfo sharedManager] getUsedMemory];//获取正在使用的内存空间
    int64_t WiredMemory = [[TYGDeviceInfo sharedManager] getWiredMemory];//获取存放内核的内存空间
    int64_t PurgableMemory = [[TYGDeviceInfo sharedManager] getPurgableMemory];//获取可释放的内存空间
    
    NSArray *memoryTitleArray = @[@"总内存空间",@"活跃的内存空间",@"不活跃的内存空间",@"空闲的内存空间",@"正在使用的内存空间",@"存放内核的内存空间",@"可释放的内存空间"];
    NSArray *memoryDetailArray = @[[[TYGDeviceInfo sharedManager] fileSizeToString:TotalMemory],[[TYGDeviceInfo sharedManager] fileSizeToString:ActiveMemory],[[TYGDeviceInfo sharedManager] fileSizeToString:InActiveMemory],[[TYGDeviceInfo sharedManager] fileSizeToString:FreeMemory],[[TYGDeviceInfo sharedManager] fileSizeToString:UsedMemory],[[TYGDeviceInfo sharedManager] fileSizeToString:WiredMemory],[[TYGDeviceInfo sharedManager] fileSizeToString:PurgableMemory]];
    
    [titlesArray addObject:memoryTitleArray];
    [detailTitlesArray addObject:memoryDetailArray];
    
    //存储
    NSString *ApplicationSize = [[TYGDeviceInfo sharedManager] getApplicationSize];//获取本 App 所占磁盘空间
    int64_t TotalDiskSpace = [[TYGDeviceInfo sharedManager] getTotalDiskSpace];//获取磁盘总空间
    int64_t FreeDiskSpace = [[TYGDeviceInfo sharedManager] getFreeDiskSpace];//获取未使用的磁盘空间
    int64_t UsedDiskSpace = [[TYGDeviceInfo sharedManager] getUsedDiskSpace];//获取已使用的磁盘空间
    
    NSArray *diskTitleArray = @[@"本App所占磁盘空间",@"磁盘总空间",@"未使用的磁盘空间",@"已使用的磁盘空间"];
    NSArray *diskDetailArray = @[SAFE_STRING(ApplicationSize),[[TYGDeviceInfo sharedManager] fileSizeToString:TotalDiskSpace],[[TYGDeviceInfo sharedManager] fileSizeToString:FreeDiskSpace],[[TYGDeviceInfo sharedManager] fileSizeToString:UsedDiskSpace]];
    
    [titlesArray addObject:diskTitleArray];
    [detailTitlesArray addObject:diskDetailArray];
    
    //其它
    NSString *deviceSize = NSStringFromCGSize([[TYGDeviceInfo sharedManager] getScreenSize]);
    NSString *DeviceColor = [[TYGDeviceInfo sharedManager] getDeviceColor];
    NSString *DeviceEnclosureColor = [[TYGDeviceInfo sharedManager] getDeviceEnclosureColor];
    NSString *MacAddress = [[TYGDeviceInfo sharedManager] getMacAddress];
    NSString *canMakePhoneCall = [[TYGDeviceInfo sharedManager] canMakePhoneCall] ? @"是" : @"否";
    
    NSArray *otherTitleArray = @[@"分辨率",@"设备颜色(私有API)",@"设备外壳颜色(私有API)",@"mac地址",@"是否可打电话"];
    NSArray *otherDetailArray = @[deviceSize,DeviceColor,DeviceEnclosureColor,MacAddress,canMakePhoneCall];
    
    [titlesArray addObject:otherTitleArray];
    [detailTitlesArray addObject:otherDetailArray];
    
    //网络en0
    NSMutableArray *netTitleArray = [NSMutableArray arrayWithObjects:@"SSID",@"BSSID",@"SSIDDATA", nil];
    NSMutableArray *netDetailArray = [NSMutableArray arrayWithCapacity:10];
    
    NSDictionary *wifiSSIDDic = [TYGNetworkUtility fetchSSIDInfo];
    NSString *SSID = [wifiSSIDDic objectForKey:@"SSID"];
    NSString *BSSID = [wifiSSIDDic objectForKey:@"BSSID"];
    NSString *SSIDData = [wifiSSIDDic objectForKey:@"SSIDDATA"];
    
    [netDetailArray addObject:SAFE_STRING(SSID)];
    [netDetailArray addObject:SAFE_STRING(BSSID)];
    [netDetailArray addObject:SAFE_STRING(SSIDData)];
    
    
    NSDictionary *currentWiFiDic = [TYGNetworkUtility getLocalInfoForCurrentWiFi];
    for (NSString *key in [currentWiFiDic allKeys]) {
        NSString *value = [currentWiFiDic objectForKey:key];
        
        [netTitleArray addObject:key];
        [netDetailArray addObject:value];
    }
    
    [titlesArray addObject:netTitleArray];
    [detailTitlesArray addObject:netDetailArray];
    
    //SIM
    NSMutableArray *simTitleArray = [NSMutableArray arrayWithObjects:@"网络类型",@"网络环境",@"手机号码(私有API)",@"手机号码", nil];
    NSMutableArray *simDetailArray = [NSMutableArray arrayWithCapacity:10];
    
    NSString *networktype = [[TYGSimInfo sharedManager] getCurrentRadioAccessTechnology];//获取当前网络的类型
    NSString *networktype2 = [TYGSimInfo networktype];//获取网络环境
    [simDetailArray addObject:SAFE_STRING(networktype)];
    [simDetailArray addObject:SAFE_STRING(networktype2)];

    NSDictionary *carrierInfo = [[TYGSimInfo sharedManager] getcarrierInfo];//获取sim卡信息
    for (NSString *key in [carrierInfo allKeys]) {
        NSString *value = [carrierInfo objectForKey:key];
        [simTitleArray addObject:key];
        [simDetailArray addObject:value];
    }
    
    [titlesArray addObject:simTitleArray];
    [detailTitlesArray addObject:simDetailArray];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return headerTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (titlesArray.count > section) {
        NSArray *titleArray = [titlesArray objectAtIndex:section];
        
        return titleArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdetify = @"TYGSystemInfoViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell...
    NSArray *titleArray = [titlesArray objectAtIndex:indexPath.section];
    NSArray *detailArray = [detailTitlesArray objectAtIndex:indexPath.section];
    
    if (titleArray.count > indexPath.row) {
        cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    }
    
    if (detailArray.count > indexPath.row) {
        
        NSString *detailTitle = [NSString stringWithFormat:@"%@",[detailArray objectAtIndex:indexPath.row]];
        
        cell.detailTextLabel.text = detailTitle;
        //cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        if ([detailTitle hasPrefix:@"#"]) {
            //颜色
            detailTitle = [detailTitle substringFromIndex:1];
            
            NSScanner *scanner = [NSScanner scannerWithString:detailTitle];
            unsigned hexNum;
            if([scanner scanHexInt:&hexNum]) {
                //cell.detailTextLabel.textColor = Color_RGB_OxH(hexNum);
                cell.backgroundColor = Color_RGB_OxH(hexNum);
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TYGSystemInfoViewController"];
    if (nil == headview) {
        headview = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"TYGSystemInfoViewController"];
    }
    
    NSString *title = [headerTitles objectAtIndex:section];
    
    headview.textLabel.text = title;
    
    return headview;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end
