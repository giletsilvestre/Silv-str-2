//
//  SilvestreRessenyesInternesViewConoller.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 26/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreRessenyesInternesViewConoller.h"
#import "SilvestreResumDadesViewController.h"
#import "SilvestreTraductorNumerosBDD.h"
#import "Ressenyes.h"
#import "Llocs.h"
#import "Imatges.h"
#import "NSDate+Helper.h"

@interface SilvestreRessenyesInternesViewConoller()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicadorCarregant;

@property(nonatomic) BOOL buidaTableView;

@end

@implementation SilvestreRessenyesInternesViewConoller

@synthesize BDDRessenyes = _BDDRessenyes;
@synthesize indicadorCarregant = _indicadorCarregant;
@synthesize buidaTableView = _buidaTableView;

- (void)setupFetchedResultsController 
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ressenyes"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"ressenyada == 0"];   
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.BDDRessenyes.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.buidaTableView) {
        self.BDDRessenyes = nil;
        self.fetchedResultsController = nil;
    }
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.BDDRessenyes.fileURL path]]) {
        // does not exist on disk, so create it
        [self.BDDRessenyes saveToURL:self.BDDRessenyes.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];            
        }];
    } else if (self.BDDRessenyes.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.BDDRessenyes openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.BDDRessenyes.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self setupFetchedResultsController];
    }
}


- (void)setBDDRessenyes:(UIManagedDocument *)BDDRessenyes
{
    if (_BDDRessenyes != BDDRessenyes) {
        _BDDRessenyes = BDDRessenyes;
        [self useDocument];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.buidaTableView = YES;
    self.fetchedResultsController = nil;
    self.BDDRessenyes = nil;
    if (!self.BDDRessenyes) { 
        [self.indicadorCarregant startAnimating];
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"BDDRessenyes"];
        self.BDDRessenyes = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Ressenya";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Ressenyes *ressenya = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    NSLog(@"LLoc.Nom : %@",ressenya.lloc.nom);
    cell.textLabel.text = [[[NSDate stringForDisplayFromDate:ressenya.data] stringByAppendingString:@" a "]stringByAppendingString: ressenya.lloc.nom];
    
    NSLog(@"%d",ressenya.dificultat.integerValue);
    cell.detailTextLabel.alpha = 0.8;
    
    
    cell.detailTextLabel.text = [SilvestreTraductorNumerosBDD traduirEstil:ressenya.estil];
    cell.detailTextLabel.text = [SilvestreTraductorNumerosBDD traduirGrau:ressenya.dificultat];
    cell.detailTextLabel.textColor = [SilvestreTraductorNumerosBDD traduirColorGrau:ressenya.dificultat];
    [self.indicadorCarregant stopAnimating];
    [self.indicadorCarregant setHidden:YES];

    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    Ressenyes *ressenya = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"Detalls ressenya"]) {
        self.buidaTableView = NO;
        [segue.destinationViewController setRessenya:ressenya];
        [segue.destinationViewController setBDDRessenyes:self.BDDRessenyes];
    }
}
- (void)viewDidUnload {
    [self setIndicadorCarregant:nil];
    [super viewDidUnload];
}
@end
