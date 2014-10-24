//
//  HDDropDownMenu.h
//  HaidoraDropDownMenu
//
//  Created by DaiLingchi on 14-10-22.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDDropDownMenuDataSource;
@protocol HDDropDownMenuDelegate;

#pragma mark
#pragma mark HDDropDownMenu

@interface HDDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<HDDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id<HDDropDownMenuDelegate> delegate;

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat sectionWidth;

@property (nonatomic, strong) UIColor *sectionNormalColor;
@property (nonatomic, strong) UIColor *sectionHighlightColor;
@property (nonatomic, strong) UIColor *cellNormalColor;
@property (nonatomic, strong) UIColor *cellHighlightColor;

@property (nonatomic, strong) UIColor *sectionTitleNormalColor;
@property (nonatomic, strong) UIColor *sectionTitleHighlightColor;
@property (nonatomic, strong) UIColor *cellTitleNormalColor;
@property (nonatomic, strong) UIColor *cellTitleHighlightColor;

@property (nonatomic, strong) UIFont *secionTitleFont;
@property (nonatomic, strong) UIFont *cellTitleFont;

@property (nonatomic, weak) UIView *mSuperView;
@property (nonatomic, readonly) UIButton *sectionBtn;

@end

#pragma mark
#pragma mark HDDropDownMenuDataSource

@protocol HDDropDownMenuDataSource <NSObject>

@required

- (NSInteger)dropDownMenu:(HDDropDownMenu *)dropDownMenu numberOfRowsInSection:(NSInteger)section;

- (NSString *)dropDownMenu:(HDDropDownMenu *)dropDownMenu titleForSection:(NSInteger)section;
- (NSString *)dropDownMenu:(HDDropDownMenu *)dropDownMenu
         titleForIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 *  Default is 1
 */
- (NSInteger)numberOfSectionsInHDDropDownMenu:(HDDropDownMenu *)dropDownMenu;

@end

#pragma mark
#pragma mark HDDropDownMenuDelegate

@protocol HDDropDownMenuDelegate <NSObject>

@optional

- (void)chooseAtSection:(NSInteger)section index:(NSInteger)index;

@end
