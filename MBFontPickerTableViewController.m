//
//  MBFontPickerTableViewController.m
//
//  Copyright (c) 2013 Matthias Bauch <dev@matthiasbauch.com>
//  This work is free. You can redistribute it and/or modify it under the
//  terms of the Do What The Fuck You Want To Public License, Version 2,
//  as published by Sam Hocevar. See the COPYING file for more details.

#import "MBFontPickerTableViewController.h"

@interface MBFontPickerTableViewController ()
@property (strong, nonatomic) NSArray *fontNames;
@property (strong, nonatomic) NSString *selectedFontFamily;
@end

@implementation MBFontPickerTableViewController {
    NSDictionary *_displayNamesDictionary;
    NSDictionary *_defaultFontsDictionary;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    NSIndexPath *selectedIndexPath = nil;
    if (self.fontFamilyName) {
        NSInteger index = [self.fontNames indexOfObject:self.selectedFont];
        if (index != NSNotFound) {
            selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        }
    }
    else {
        NSInteger index = [self.fontNames indexOfObject:self.selectedFontFamily];
        if (index != NSNotFound) {
            selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        }
    }
    if (selectedIndexPath) {
        [self.tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)fontNames {
    if (!_fontNames) {
        if (_fontFamilyName) {
            _fontNames = [UIFont fontNamesForFamilyName:_fontFamilyName];
        }
        else {
            _fontNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
    }
    return _fontNames;
}

- (void)setSelectedFont:(NSString *)selectedFont {
    _selectedFont = [selectedFont copy];
    _selectedFontFamily = nil;
    for (NSString *fontFamilyName in [UIFont familyNames]) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamilyName];
        if ([fontNames containsObject:selectedFont]) {
            _selectedFontFamily = fontFamilyName;
            break;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fontNames count];
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:2001];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:2002];
    
    NSString *fontName = nil;
    if (self.fontFamilyName) {
        fontName = self.fontNames[indexPath.row];
        NSString *displayName = [self displayNameForFontName:fontName];
        if (!displayName) {
            // display name not found in plist. use font name
            displayName = fontName;
        }
        label.text = displayName;
        label.font = [UIFont fontWithName:fontName size:20.f];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([fontName isEqualToString:self.selectedFont]) {
            imageView.image = [UIImage imageNamed:@"checkmark"];
        }
        else {
            imageView.image = nil;
        }
    }
    else {
        NSString *fontFamilyName = self.fontNames[indexPath.row];
        NSString *defaultFontName = [self defaultFontNameForFamilyName:fontFamilyName];
        if (!defaultFontName) {
            // default font not found in plist. use first font
            defaultFontName = [UIFont fontNamesForFamilyName:fontFamilyName][0];
        }
        label.text = fontFamilyName;
        label.font = [UIFont fontWithName:defaultFontName size:20.f];
        
        if ([[UIFont fontNamesForFamilyName:fontFamilyName] count] > 1) {
            // if there are at least two fonts show accessory button so we can choose them
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if ([fontFamilyName isEqualToString:self.selectedFontFamily]) {
            imageView.image = [UIImage imageNamed:@"checkmark"];
        }
        else {
            imageView.image = nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 14, 14)];
        imageView.tag = 2001;
        [cell.contentView addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 276, 43)];
        label.tag = 2002;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:label];
    }
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fontName = nil;
    NSString *fontFamilyName = nil;
    NSIndexPath *oldIndexPath = nil;
    if (self.fontFamilyName) {
        fontName = self.fontNames[indexPath.row];
        fontFamilyName = self.fontFamilyName;
        NSInteger index = [self.fontNames indexOfObject:self.selectedFont];
        if (index != NSNotFound) {
            oldIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        }
        
        MBFontPickerTableViewController *previousPicker = self.navigationController.viewControllers[[self.navigationController.viewControllers count]-2];
        if ([previousPicker isKindOfClass:[MBFontPickerTableViewController class]]) {
            previousPicker.selectedFontFamily = fontFamilyName;
        }
    }
    else {
        fontFamilyName = self.fontNames[indexPath.row];
        fontName = [self defaultFontNameForFamilyName:fontFamilyName];
        if (!fontName) {
            // if there is no default font just use the first font that UIFont gives us
            fontName = [UIFont fontNamesForFamilyName:fontFamilyName][0];
        }
        NSInteger index = [self.fontNames indexOfObject:self.selectedFontFamily];
        if (index != NSNotFound) {
            oldIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        }
    }
    self.selectedFont = fontName;
    self.selectedFontFamily = fontFamilyName;
    if (oldIndexPath) {
        [self configureCell:[tableView cellForRowAtIndexPath:oldIndexPath] forRowAtIndexPath:oldIndexPath];
    }
    [self configureCell:[tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
    
    [self.delegate fontPicker:self didSelectFontWithName:fontName];    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *fontFamilyName = self.fontNames[indexPath.row];
    
    MBFontPickerTableViewController *fontPicker = [[MBFontPickerTableViewController alloc] initWithStyle:self.tableView.style];
    fontPicker.fontFamilyName = fontFamilyName;
    fontPicker.delegate = self.delegate;
    fontPicker.title = self.title;
    fontPicker.selectedFont = self.selectedFont;
    fontPicker.contentSizeForViewInPopover = self.contentSizeForViewInPopover;
    [self.navigationController pushViewController:fontPicker animated:YES];
}

#pragma mark - Font Names

- (NSDictionary *)displayNamesDictionary {
    if (!_displayNamesDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"displayNameForFontName" ofType:@"plist"];
        if (path) {
            NSDictionary *displayNamesOnDisc = [NSDictionary dictionaryWithContentsOfFile:path];
            
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:200];
            for (NSString *fontFamilyName in displayNamesOnDisc) {
                NSDictionary *fontFamilyDictionary = displayNamesOnDisc[fontFamilyName];
                for (NSString *fontName in fontFamilyDictionary) {
                    [temp setObject:fontFamilyDictionary[fontName] forKey:fontName];
                }
            }
            _displayNamesDictionary = [temp copy];
        }
    }
    return _displayNamesDictionary;
}


- (NSString *)displayNameForFontName:(NSString *)fontName {
    return [self.displayNamesDictionary objectForKey:fontName];;
}

#pragma mark - Main Font for Family Name


- (NSDictionary *)defaultFontsDictionary {
    if (!_defaultFontsDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultFontForFamilyName" ofType:@"plist"];
        if (path) {
            _defaultFontsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        }
    }
    return _defaultFontsDictionary;
}

- (NSString *)defaultFontNameForFamilyName:(NSString *)familyName {
    return [self.defaultFontsDictionary objectForKey:familyName];
}

@end
