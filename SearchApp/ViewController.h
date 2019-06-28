//
//  ViewController.h
//  SearchApp
//
//  Created by Tomas Moran on 23/06/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController: UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *elementos;
@property (nonatomic, strong) NSMutableArray *elementosFiltrados;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

