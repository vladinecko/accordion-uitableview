//
//  AccordionTableViewController.h
//  AccordionTableView
//
//  Created by Vladimir Olexa on 3/29/13.
//  Copyright (c) 2013 Vladimir Olexa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccordionTableViewController : UITableViewController {
    NSArray *topItems;
    NSMutableArray *subItems; // array of arrays
    
    int currentExpandedIndex;
}

@end
