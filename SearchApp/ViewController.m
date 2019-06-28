//
//  ViewController.m
//  SearchApp
//
//  Created by Tomas Moran on 23/06/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

#import "ViewController.h"
#import "MeliDevLoginViewController.h"
#import "Meli.h"
#import "MeliDevIdentity.h"
#import "MeliDevAsyncHttpOperation.h"
#import "MeliDevSyncHttpOperation.h"
#import "MeliDevErrors.h"
#import "MBProgressHUD.h"

static NSString * CLIENT_ID_VALUE = @"5197208004815569";
static NSString * REDIRECT_URL_VALUE = @"https://www.example.com";

@interface ViewController () {
    NSString *cellIdentifier;
}

@property MeliDevIdentity *identity;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (copy) NSString * result;
@property (nonatomic) NSError * error;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self initMeli]) {
        
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.layer.zPosition = 1;
        
        [self makeGetRequestWithLoops:10]; // Quantity of elements to search
        
        self.navigationItem.title = @"Test SearchBar";
        //    self.navigationController.navigationBar.prefersLargeTitles = YES;
        
        self.elementos = [NSMutableArray arrayWithArray:@[@"Miguel",@"Erik",@"Pedro",@"Victor",@"Juanpe",@"Javi",@"Sendoa"]];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
    } else {
        
    }
}

#pragma Mark: SDK Meli
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
    
    for ( int i = 1
         ; i < Loops; i++) {
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

- (void)searchFilter:(NSString*)searchText
{
    NSPredicate *predicateSearch = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.elementosFiltrados = [NSMutableArray arrayWithArray:[self.elementos filteredArrayUsingPredicate:predicateSearch]];
}



# pragma mark - UITableViewDataSource: UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.elementos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.elementos[indexPath.row];
    return cell;
}


# pragma mark - UITableViewDelegate: UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    return 50;
}

# pragma mark - UISearchBarDelegate
@end
