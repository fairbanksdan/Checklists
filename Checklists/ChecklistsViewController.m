//
//  ChecklistsViewController.m
//  Checklists
//
//  Created by Daniel Fairbanks on 4/15/14.
//  Copyright (c) 2014 Fairbanksdan. All rights reserved.
//

#import "ChecklistsViewController.h"
#import "ChecklistItem.h"
#import "ItemDetailViewController.h"

@interface ChecklistsViewController ()

@end

@implementation ChecklistsViewController

{
    NSMutableArray *_items; //creates a mutable Array with the variable "_items"
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}
- (NSString *)dataFilePath
{
    return [[self documentsDirectory]
            stringByAppendingPathComponent:@"Checklists.plist"];
}

- (void)saveChecklistItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:_items forKey:@"ChecklistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklistItems {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        _items = [unarchiver decodeObjectForKey:@"ChecklistItems"];
        [unarchiver finishDecoding];
        
    } else {
        _items = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])){
        [self loadChecklistItems];
    }
    return self;
}

- (void)viewDidLoad //What will happen when the view is loaded the first time
{
    [super viewDidLoad]; //???inherets all ViewDidLoad protocols???
//    
//    _items = [[NSMutableArray alloc] initWithCapacity:20]; //instantiating "_items" array with a capacity of 20
//    ChecklistItem *item;                    //creates an object of the class type ChecklistItem with the variable "item"
//    item = [[ChecklistItem alloc] init];    //allocates  and initializes space for the object
//    item.text = @"Walk the dog";            //sets the ChecklistItem instantiated object's text to "Walk the dog"
//    item.checked = NO;                      //sets the ChecklistItem instantiated object's accessory checkmark to NO, or not checked
//    [_items addObject:item];
//    item = [[ChecklistItem alloc] init];
//    item.text = @"Brush my teeth";
//    item.checked = YES;
//    [_items addObject:item];
//    item = [[ChecklistItem alloc] init];
//    item.text = @"Learn iOS development";
//    item.checked = YES;
//    [_items addObject:item];
//    item = [[ChecklistItem alloc] init];
//    item.text = @"Soccer practice";
//    item.checked = NO;
//    [_items addObject:item];
//    item = [[ChecklistItem alloc] init];
//    item.text = @"Eat ice cream";
//    item.checked = YES;
//    [_items addObject:item];
//    item = [[ChecklistItem alloc] init];
//    item.text = @"Go to CrossFit";
//    item.checked = NO;
//    [_items addObject:item];
//    item = [[ChecklistItem alloc] init];
//    item.text = @"Eat Nachos";
//    item.checked = NO;
//    [_items addObject:item];
//    item = [[ChecklistItem alloc] init];
//    item.text = @"Drink Red Bull";
//    item.checked = NO;
//    [_items addObject:item];
//    
//    NSLog(@"Documents folder is %@", [self documentsDirectory]);
//    NSLog(@"Data file path is %@", [self dataFilePath]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section { //required method for a TableView asking for the number of rows per section.
    return  [_items count];  //How many rows we want per TableView section
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell
                withChecklistItem:(ChecklistItem *)item //methods for checking and unchecking a cell/row
{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}

- (void)configureTextForCell:(UITableViewCell *)cell
           withChecklistItem:(ChecklistItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath { //method for what is in each cell/row of the tableView
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"]; //a variable named "cell" of the type UITableViewCell that is defined as the the reusable cells that are identified by the string "ChecklistItem", which was defined in the storyboard.
    
    ChecklistItem *item = _items[indexPath.row];
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    return cell; //returns what is in each "cell" as defined in this method
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath //method for what happens when selecting a row in a tableView
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //creates a ???pointer or variable??? of type TableViewCell that is defined as the cell for the row that is selected in the tableView
    
    ChecklistItem *item = _items[indexPath.row];
    [item toggleChecked];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    [self saveChecklistItems];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_items removeObjectAtIndex:indexPath.row];
    
    [self saveChecklistItems];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths
                     withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)ItemDetailViewControllerDidCancel:(ItemDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ItemDetailViewController:(ItemDetailViewController *)controller
          didFinishAddingItem:(ChecklistItem *)item
{
    NSInteger newRowIndex = [_items count];
    [_items addObject:item];
    NSIndexPath *indexPath = [NSIndexPath
                              indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self saveChecklistItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        // 1
        UINavigationController *navigationController =
        segue.destinationViewController;
        // 2
        ItemDetailViewController *controller =
        (ItemDetailViewController *)
        navigationController.topViewController;
        // 3
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EditItem"])
    {
        UINavigationController *navigationController =
        segue.destinationViewController;
        ItemDetailViewController *controller =
        (ItemDetailViewController *)
        navigationController.topViewController;
        controller.delegate = self;
        NSIndexPath *indexPath = [self.tableView
                                  indexPathForCell:sender];
        controller.itemToEdit = _items[indexPath.row];
    }
}

- (void)ItemDetailViewController:
(ItemDetailViewController *)controller
         didFinishEditingItem:(ChecklistItem *)item
{
    NSInteger index = [_items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    UITableViewCell *cell = [self.tableView
                             cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    
    [self saveChecklistItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
