//
//  SearchTableViewController.m
//  SearchApp
//
//  Created by Tomas Moran on 30/06/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

#import "SearchTableViewController.h"
#import "MeliDevLoginViewController.h"
#import "Meli.h"
#import "MeliDevIdentity.h"
#import "MeliDevAsyncHttpOperation.h"
#import "MeliDevSyncHttpOperation.h"
#import "MeliDevErrors.h"
#import "MBProgressHUD.h"

static NSString * CLIENT_ID_VALUE = @"5197208004815569";
static NSString * REDIRECT_URL_VALUE = @"https://www.example.com";

@interface SearchTableViewController () {
    NSString *cellIdentifier;
}

@property MeliDevIdentity *identity;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (copy) NSString * result;
@property (nonatomic) NSError * error;

@end


@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([self initMeli]) {
        
        //        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        self.HUD.layer.zPosition = 1;
        
        [self makeGetRequestWithLoops:10]; // Quantity of elements to search
        
        [self initSearchController];
        
        self.elementos = [NSMutableArray arrayWithArray:@[@"Miguel",@"Erik",@"Pedro",@"Victor",@"Juanpe",@"Javi",@"Sendoa",@"Miguel",@"Erik",@"Pedro",@"Victor",@"Juanpe",@"Javi",@"Sendoa",@"Miguel",@"Erik",@"Pedro",@"Victor",@"Juanpe",@"Javi",@"Sendoa",@"Miguel",@"Erik",@"Pedro",@"Victor",@"Juanpe",@"Javi",@"Sendoa"]];
        self.elementosFiltrados = [NSMutableArray arrayWithArray:self.elementos];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
    } else {
        
    }
}

# pragma mark - SDK Meli
- (BOOL) initMeli {
    NSError *error;
    
    [Meli initializeSDK: CLIENT_ID_VALUE withRedirectUrl: REDIRECT_URL_VALUE error:&error];
    
    if(error) {
        NSLog(@"Domain: %@", error.domain);
        NSLog(@"Error Code: %ld", error.code);
        NSLog(@"Description: %@", [error localizedDescription]);
    }
    
    return error ? NO : YES;
}

- (void) makeGetRequestWithLoops:(NSInteger)Loops {
    
    long numberForItems = 778950852;
    NSString *path = @"/items?ids=MLA778950852";
    //    /items?ids=MLA778950852,MLA778950853
    
    for ( int i = 1; i < Loops; i++) {
        numberForItems += i;
        NSString* newInt = [NSString stringWithFormat:@"%li", numberForItems];
        path = [NSString stringWithFormat:@"%@,MLA%@", path, newInt];
    }
    
    NSError *error2;
    NSString * result = [Meli get:path error:&error2];
    
    [self processOut:result withError: &error2];
    
}

- (void) processOut:(NSString *)result withError:(NSError **)error {
    
    if(*error != nil) {
        NSLog(@"Http request error %@", [*error userInfo]);
        
    } else {
        NSLog(@"Result %@", result);
        [self resultToTableViewArray:result];
        
    }
}

# pragma mark - methods
- (void) resultToTableViewArray:(NSString*)result {
    
    // Convert to JSON object:
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    NSLog(@"jsonObject=%@", jsonObject);
    
    self.elementos = [NSMutableArray arrayWithArray:jsonObject];
}

- (void)searchFilter:(NSString*)searchText {
    NSPredicate *predicateSearch = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.elementosFiltrados = [NSMutableArray arrayWithArray:[self.elementos filteredArrayUsingPredicate:predicateSearch]];
}

# pragma mark - Implements UISearchController
- (void) initSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Buscar Productos";
    
    [self.searchController.searchBar sizeToFit];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = TRUE;
    } else { self.tableView.tableHeaderView = self.searchController.searchBar; }
    
    [self.searchController.searchBar becomeFirstResponder];
    self.definesPresentationContext = YES;
}

#pragma mark - TableView - DataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.elementosFiltrados.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.elementosFiltrados[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSDictionary *credit = [self.creditosPermitidos objectAtIndex:indexPath.row];
    //    NSArray *copyOfLegends = [SRioCommonMethods dictionaryArrayFromDictionary:[self.prestamosPermitidos objectForKey:tagListaLeyendas] withItemKey:tagLeyenda];
    //
    //    SetupCreditViewController *setupCreditVC = [[SetupCreditViewController alloc] init];
    //    if ([[credit valueForKey:@"indicadorUVA"] isEqualToString:@"S"]) {
    //        setupCreditVC.isUVACredit = YES;
    //    } else {
    //        setupCreditVC.isUVACredit = NO;
    //    }
    //    setupCreditVC.impDispPrest = [[self.solicitudCrediticia objectForKey:tagDatosCalifCred] objectForKey:tagImpDispPrest];
    //    setupCreditVC.creditData = credit;
    //    setupCreditVC.generalCreditData = self.prestamosPermitidos;
    //    setupCreditVC.leyenda = [self getCaptionForSetupPage];
    //    setupCreditVC.creditCopyOfLegends = copyOfLegends;
    //    setupCreditVC.accountAssociatedToCredit = self.accountAssociatedToCredit;
    //    setupCreditVC.leyendaLinkSeguro = self.leyendaLinkSeguro;
    //    setupCreditVC.revealViewController = self.revealViewController;
    //    [self.navigationController pushViewController:setupCreditVC animated:YES];
    //
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

# pragma mark - UISearchBarDelegate
- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    
    NSString *searchString = searchController.searchBar.text;
    if (!searchString.length) {
        self.elementosFiltrados = self.elementos;
        
    } else {
        
        // strip out all the leading and trailing spaces
        NSString *strippedString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", strippedString];
        NSArray *filtered = [self.elementos filteredArrayUsingPredicate:predicate];
        self.elementosFiltrados = [NSMutableArray arrayWithArray:filtered];
        
    }
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
