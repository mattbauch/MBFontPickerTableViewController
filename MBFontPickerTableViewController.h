//
//  MBFontPickerTableViewController.h
//
//  Copyright (c) 2013 Matthias Bauch <dev@matthiasbauch.com>
//  This work is free. You can redistribute it and/or modify it under the
//  terms of the Do What The Fuck You Want To Public License, Version 2,
//  as published by Sam Hocevar. See the COPYING file for more details.

#import <UIKit/UIKit.h>

@class MBFontPickerTableViewController;

@protocol MBFontPickerDelegate <NSObject>
- (void)fontPicker:(MBFontPickerTableViewController *)fontPicker didSelectFontWithName:(NSString *)fontName;
@end

@interface MBFontPickerTableViewController : UITableViewController
@property (weak, nonatomic) id <MBFontPickerDelegate> delegate;

// if fontFamilyName is nil FontPicker will show family names
@property (copy, nonatomic) NSString *fontFamilyName;

@property (copy, nonatomic) NSString *selectedFont;

+ (NSString *)displayNameForFontName:(NSString *)fontName;
@end
