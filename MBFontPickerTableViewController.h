//
//  MBFontPickerTableViewController.h
//  MBFontPickerTableViewControllerDemo
//
//  Created by Matthias Bauch on 2/28/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

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
