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

static NSString * CLIENT_ID_VALUE = @"5197208004815569";
static NSString * REDIRECT_URL_VALUE = @"https://www.example.com";

//@interface MeliDevSDKExampleViewController ()
//
//@property MeliDevIdentity *identity;
//
//@property (copy) NSString * result;
//@property (nonatomic) NSError * error;

@interface ViewController () {
    NSString *cellIdentifier;
}
@property MeliDevIdentity *identity;

@property (copy) NSString * result;
@property (nonatomic) NSError * error;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
    [Meli initializeSDK: CLIENT_ID_VALUE withRedirectUrl: REDIRECT_URL_VALUE error:&error];
    
//    [self ];
    if(error) {
        NSLog(@"Domain: %@", error.domain);
        NSLog(@"Error Code: %ld", error.code);
        NSLog(@"Description: %@", [error localizedDescription]);
    }
    
    [self getUsersItemsAsync];
    
    self.navigationItem.title = @"Test SearchBar";
//    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    self.elementos = [NSMutableArray arrayWithArray:@[@"Miguel",@"Erik",@"Pedro",@"Victor",@"Juanpe",@"Javi",@"Sendoa"]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
}

- (void) getUsersItemsAsync {
    
    MeliDevIdentity * identity = [Meli getIdentity];
    
    if(identity) {
        
        NSString *userPath = [@"/users/" stringByAppendingString: identity.userId];
        NSString *path = [userPath stringByAppendingString: @"/items/search"];
        
        AsyncHttpOperationSuccessBlock successBlock = ^(NSURLSessionTask *task, id responseObject) {
            [self parseData:responseObject];
        };
        
        AsyncHttpOperationFailBlock failureBlock = ^(NSURLSessionTask *operation, NSError *error) {
            if(error) {
                [self processError:operation error:error];
            }
        };
        
        [Meli asyncGetAuth:path withIdentity: identity successBlock:successBlock failureBlock:failureBlock];
    }
}

- (void) parseData: (id) responseObject {
    
    NSArray *jsonArray = (NSArray *) responseObject;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Result %@", result);
}

- (void) processError: (NSURLSessionTask *) operation error:(NSError *)error {
    
    if(operation) {
        NSURLRequest * request = operation.currentRequest;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        
        NSString * requestError = [NSString stringWithFormat: HTTP_REQUEST_ERROR_MESSAGE, [request URL],
                                   (long)[httpResponse statusCode] ];
        
        NSLog(@"Http request error %@", requestError);
    } else {
        NSLog(@"Error: %@ ", [error userInfo] );
    }
}

# pragma mark - methods
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
