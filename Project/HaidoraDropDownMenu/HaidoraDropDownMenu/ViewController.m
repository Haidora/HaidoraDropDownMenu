//
//  ViewController.m
//  HaidoraDropDownMenu
//
//  Created by DaiLingchi on 14-10-22.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "ViewController.h"
#import "HDDropDownMenu.h"

@interface ViewController () <HDDropDownMenuDataSource>

@property (weak, nonatomic) IBOutlet HDDropDownMenu *menu;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _menu.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInHDDropDownMenu:(HDDropDownMenu *)dropDownMenu
{
    return 10;
}

- (NSInteger)dropDownMenu:(HDDropDownMenu *)dropDownMenu numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)dropDownMenu:(HDDropDownMenu *)dropDownMenu titleForSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"主标题%ld", section];
    return string;
}
- (NSString *)dropDownMenu:(HDDropDownMenu *)dropDownMenu titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [NSString stringWithFormat:@"标题%ld-%ld", indexPath.section, indexPath.row];
    return string;
}

@end
