//
//  SearchTableViewController.h
//  SearchApp
//
//  Created by Tomas Moran on 30/06/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *elementos;
@property (nonatomic, strong) NSMutableArray *elementosFiltrados;

@property (strong, nonatomic) UISearchController *searchController;

@end

NS_ASSUME_NONNULL_END
