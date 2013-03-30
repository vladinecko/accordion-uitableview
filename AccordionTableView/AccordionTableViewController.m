//
//  AccordionTableViewController.m
//  AccordionTableView
//
//  Created by Vladimir Olexa on 3/29/13.
//  Copyright (c) 2013 Vladimir Olexa. All rights reserved.
//

#import "AccordionTableViewController.h"

#define NUM_TOP_ITEMS 20
#define NUM_SUBITEMS 6

@implementation AccordionTableViewController

- (id)init {
    self = [super init];
    
    if (self) {
        topItems = [[NSArray alloc] initWithArray:[self topLevelItems]];
        subItems = [NSMutableArray new];
        currentExpandedIndex = -1;
        
        for (int i = 0; i < [topItems count]; i++) {
            [subItems addObject:[self subItems]];
        }
    }
    return self;
}

#pragma mark - Data generators

- (NSArray *)topLevelItems {
    NSMutableArray *items = [NSMutableArray array];
    
    for (int i = 0; i < NUM_TOP_ITEMS; i++) {
        [items addObject:[NSString stringWithFormat:@"Item %d", i + 1]];
    }
    
    return items;
}

- (NSArray *)subItems {
    NSMutableArray *items = [NSMutableArray array];
    int numItems = arc4random() % NUM_SUBITEMS + 2;
    
    for (int i = 0; i < numItems; i++) {
        [items addObject:[NSString stringWithFormat:@"SubItem %d", i + 1]];
    }
    
    return items;
}

#pragma mark - View management

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [topItems count] + ((currentExpandedIndex > -1) ? [[subItems objectAtIndex:currentExpandedIndex] count] : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ParentCellIdentifier = @"ParentCell";
    static NSString *ChildCellIdentifier = @"ChildCell";
    
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[subItems objectAtIndex:currentExpandedIndex] count];
    
    UITableViewCell *cell;
    
    if (isChild) {
        cell = [tableView dequeueReusableCellWithIdentifier:ChildCellIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:ParentCellIdentifier];
    }
    
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ParentCellIdentifier] autorelease];
    }
    
    if (isChild) {
        cell.detailTextLabel.text = [[subItems objectAtIndex:currentExpandedIndex] objectAtIndex:indexPath.row - currentExpandedIndex - 1];
    }
    else {
        int topIndex = (currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex)
        ? indexPath.row - [[subItems objectAtIndex:currentExpandedIndex] count]
        : indexPath.row;
        
        cell.textLabel.text = [topItems objectAtIndex:topIndex];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[subItems objectAtIndex:currentExpandedIndex] count];
    
    if (isChild) {
        NSLog(@"A child was tapped, do what you will with it");
        return;
    }
    
    [self.tableView beginUpdates];
    
    if (currentExpandedIndex == indexPath.row) {
        [self collapseSubItemsAtIndex:currentExpandedIndex];
        currentExpandedIndex = -1;
    }
    else {
        
        BOOL shouldCollapse = currentExpandedIndex > -1;
        
        if (shouldCollapse) {
            [self collapseSubItemsAtIndex:currentExpandedIndex];
        }
        
        currentExpandedIndex = (shouldCollapse && indexPath.row > currentExpandedIndex) ? indexPath.row - [[subItems objectAtIndex:currentExpandedIndex] count] : indexPath.row;
        
        [self expandItemAtIndex:currentExpandedIndex];
    }
    
    [self.tableView endUpdates];
    
}

- (void)expandItemAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *currentSubItems = [subItems objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [indexPaths release];
}

- (void)collapseSubItemsAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = index + 1; i <= index + [[subItems objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [indexPaths release];
}

- (void)dealloc
{
    [topItems release];
    [subItems release];
    [super dealloc];
}

@end
