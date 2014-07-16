//
//  itemDetailViewController.h
//  Checklists
//
//  Created by Daniel Fairbanks on 4/22/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;
@class ChecklistItem;

@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)ItemDetailViewControllerDidCancel:(ItemDetailViewController *)controller;

- (void)ItemDetailViewController:(ItemDetailViewController *)controller
          didFinishAddingItem:(ChecklistItem *)item;

- (void)ItemDetailViewController:(ItemDetailViewController *)controller
         didFinishEditingItem:(ChecklistItem *)item;
@end

@interface ItemDetailViewController : UITableViewController <UITextFieldDelegate>

- (IBAction)cancel;
- (IBAction)done;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) ChecklistItem *itemToEdit;

@property (nonatomic, weak) id <ItemDetailViewControllerDelegate>
delegate;

@end
