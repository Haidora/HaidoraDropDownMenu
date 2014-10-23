//
//  HDDropDownMenu.m
//  HaidoraDropDownMenu
//
//  Created by DaiLingchi on 14-10-22.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDDropDownMenu.h"

#define kTag_Section 800
#define kTag_Cell 801

#pragma mark
#pragma mark HDDropDownMenu

@interface HDDropDownMenu ()

@property (nonatomic, strong) UIView *mSuperView;

@property (nonatomic, assign) NSInteger currentSectionIndex;
@property (nonatomic, assign) NSInteger currentCellIndex;

@property (nonatomic, assign) NSInteger tempSectionIndex;
@property (nonatomic, assign) NSInteger tempCellIndex;

@property (nonatomic, strong) UIButton *sectionBtn;
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UITableView *sectionTableView;
@property (nonatomic, strong) UITableView *cellTableView;

@property (nonatomic, assign) BOOL show;

@end

@implementation HDDropDownMenu

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    // private
    _currentSectionIndex = 0;
    _currentCellIndex = 0;
    _tempSectionIndex = 0;
    _tempCellIndex = 0;
    _show = NO;
    // public
    _contentHeight = 200;
    _sectionWidth = 100;

    _sectionNormalColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    _sectionHighlightColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    _cellNormalColor = _sectionHighlightColor;
    _cellHighlightColor = _sectionHighlightColor;

    _sectionTitleNormalColor = [UIColor blackColor];
    _sectionTitleHighlightColor = [UIColor blackColor];
    _cellTitleNormalColor = _sectionTitleHighlightColor;
    _cellTitleHighlightColor = _sectionTitleHighlightColor;

    _secionTitleFont = [UIFont systemFontOfSize:14];
    _cellTitleFont = [UIFont systemFontOfSize:12];

    _sectionBtn = [[UIButton alloc] init];
    [_sectionBtn addTarget:self
                    action:@selector(sectionBtnTouch:)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sectionBtn];

    _hudView = [[UIView alloc] init];
    _hudView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudTapAction:)];
    [_hudView addGestureRecognizer:tap];

    _sectionTableView = [[UITableView alloc] init];
    _sectionTableView.dataSource = self;
    _sectionTableView.delegate = self;
    _sectionTableView.tag = kTag_Section;
    _sectionTableView.backgroundColor = _sectionNormalColor;

    _cellTableView = [[UITableView alloc] init];
    _cellTableView.dataSource = self;
    _cellTableView.delegate = self;
    _cellTableView.tag = kTag_Cell;
    _cellTableView.backgroundColor = _cellNormalColor;
}

#pragma mark
#pragma mark Render

- (void)layoutSubviews
{
    self.currentCellIndex = _currentCellIndex;
    // button
    _sectionBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    _sectionBtn.backgroundColor = self.backgroundColor;
    _sectionBtn.titleLabel.font = _secionTitleFont;
    [_sectionBtn setTitleColor:_sectionTitleNormalColor forState:UIControlStateNormal];
    [_sectionBtn setTitleColor:_sectionTitleHighlightColor forState:UIControlStateHighlighted];

    CGFloat superWidth = CGRectGetWidth(self.mSuperView.bounds);
    CGFloat superHeight = CGRectGetHeight(self.mSuperView.bounds);

    CGRect hudFrame =
        CGRectMake(0, self.frame.origin.y + CGRectGetHeight(self.bounds), superWidth, 0);
    CGRect sectionFrame = hudFrame;
    CGRect cellFrame = hudFrame;
    if (_show)
    {
        _tempSectionIndex = _currentSectionIndex;
        [self.superview addSubview:_hudView];
        [self.superview addSubview:_sectionTableView];
        [self.superview addSubview:_cellTableView];

        _hudView.frame = hudFrame;
        _sectionTableView.frame = sectionFrame;
        _cellTableView.frame = cellFrame;

        [_sectionTableView reloadData];
        [_cellTableView reloadData];

        [_sectionTableView
            selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSectionIndex inSection:0]
                        animated:YES
                  scrollPosition:UITableViewScrollPositionNone];
        [_cellTableView
            selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentCellIndex inSection:0]
                        animated:YES
                  scrollPosition:UITableViewScrollPositionNone];

        hudFrame =
            CGRectMake(0, self.frame.origin.y + CGRectGetHeight(self.bounds), superWidth,
                       superHeight - (CGRectGetMinY(self.bounds) + CGRectGetHeight(self.bounds)));
        sectionFrame = CGRectMake(0, self.frame.origin.y + CGRectGetHeight(self.bounds),
                                  _sectionWidth, _contentHeight);
        cellFrame = CGRectMake(_sectionWidth, self.frame.origin.y + CGRectGetHeight(self.bounds),
                               superWidth - _sectionWidth, _contentHeight);
        [UIView animateWithDuration:0.3
                         animations:^{
                             _hudView.frame = hudFrame;
                             _sectionTableView.frame = sectionFrame;
                             _cellTableView.frame = cellFrame;
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.3
            animations:^{
                _hudView.frame = hudFrame;
                _sectionTableView.frame = sectionFrame;
                _cellTableView.frame = cellFrame;
            }
            completion:^(BOOL finished) {
                if (finished)
                {
                    [_hudView removeFromSuperview];
                    [_sectionTableView removeFromSuperview];
                    [_cellTableView removeFromSuperview];
                }
            }];
    }
}

#pragma mark
#pragma mark Setter

- (void)setDataSource:(id<HDDropDownMenuDataSource>)dataSource
{
    _dataSource = dataSource;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    [self setNeedsLayout];
}

- (void)setCurrentCellIndex:(NSInteger)currentCellIndex
{
    _currentCellIndex = currentCellIndex;
    [_sectionBtn setTitle:[self titleForSection:_currentSectionIndex cell:_currentCellIndex]
                 forState:UIControlStateNormal];
}

#pragma mark
#pragma mark Getter

- (UIView *)mSuperView
{
    return self.superview;
}

- (NSInteger)numberOfSections
{
    NSInteger number = 1;
    if (_dataSource &&
        [_dataSource respondsToSelector:@selector(numberOfSectionsInHDDropDownMenu:)])
    {
        number = [_dataSource numberOfSectionsInHDDropDownMenu:self];
    }
    return number;
}
- (NSInteger)numberOfCells:(NSInteger)section
{
    NSInteger number = 0;
    if (_dataSource &&
        [_dataSource respondsToSelector:@selector(dropDownMenu:numberOfRowsInSection:)])
    {
        number = [_dataSource dropDownMenu:self numberOfRowsInSection:section];
    }
    return number;
}

- (NSString *)titleForSection:(NSInteger)section
{
    NSString *title;
    if (_dataSource && [_dataSource respondsToSelector:@selector(dropDownMenu:titleForIndexPath:)])
    {
        title = [_dataSource dropDownMenu:self titleForSection:section];
    }
    return title;
}

- (NSString *)titleForSection:(NSInteger)section cell:(NSInteger)cell
{
    NSString *title;
    if (_dataSource && [_dataSource respondsToSelector:@selector(dropDownMenu:titleForIndexPath:)])
    {
        title = [_dataSource dropDownMenu:self
                        titleForIndexPath:[NSIndexPath indexPathForRow:cell inSection:section]];
    }
    return title;
}

#pragma mark
#pragma mark Action

- (void)sectionBtnTouch:(UIButton *)button
{
    self.show = !_show;
}

- (void)hudTapAction:(UITapGestureRecognizer *)ges
{
    self.show = NO;
}

#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView.tag == kTag_Section)
    {
        count = [self numberOfSections];
    }
    else if (tableView.tag == kTag_Cell)
    {
        count = [self numberOfCells:_tempSectionIndex];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierString = @"HDDropDownMenuIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifierString];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    }
    if (tableView.tag == kTag_Section)
    {
        cell.backgroundColor = _sectionNormalColor;
        cell.selectedBackgroundView.backgroundColor = _sectionHighlightColor;

        cell.textLabel.text = [self titleForSection:indexPath.row];
        cell.textLabel.font = _secionTitleFont;
        cell.textLabel.textColor = _sectionTitleNormalColor;
        cell.textLabel.highlightedTextColor = _sectionTitleHighlightColor;
    }
    else if (tableView.tag == kTag_Cell)
    {
        cell.backgroundColor = _cellNormalColor;
        cell.selectedBackgroundView.backgroundColor = _cellHighlightColor;
        cell.textLabel.text = [self titleForSection:_tempSectionIndex cell:indexPath.row];
        cell.textLabel.font = _cellTitleFont;
        cell.textLabel.textColor = _cellTitleNormalColor;
        cell.textLabel.highlightedTextColor = _cellTitleHighlightColor;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kTag_Section)
    {
        _tempSectionIndex = indexPath.row;
        [_cellTableView reloadData];

        [_cellTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    else if (tableView.tag == kTag_Cell)
    {
        _currentSectionIndex = _tempSectionIndex;
        self.currentCellIndex = indexPath.row;
        self.show = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(chooseAtSection:index:)])
        {
            [_delegate chooseAtSection:_currentSectionIndex index:_currentCellIndex];
        }
    }
}

@end
