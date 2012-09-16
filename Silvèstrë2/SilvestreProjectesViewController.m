//
//  SilvestreProjectesViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreProjectesViewController.h"
#import "SilvestreResumDadesViewController.h"
#import "SilvestreTraductorNumerosBDD.h"
#import "Ressenyes.h"
#import "Llocs.h"
#import "Imatges.h"
#import "NSDate+Helper.h"

@interface SilvestreProjectesViewController()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicadorCarregant;

@property(nonatomic) BOOL buidaTableView;

@end

@implementation SilvestreProjectesViewController

@synthesize BDDRessenyes = _BDDRessenyes;
@synthesize indicadorCarregant = _indicadorCarregant;
@synthesize buidaTableView = _buidaTableView;

- (void)setupFetchedResultsController 
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ressenyes"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"projecte == 1"];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.BDDRessenyes.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.rowHeight = 100;
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
    self.buidaTableView = YES;
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
    cell.imageView.image = ressenya.thumbnail.imatge;
    
    cell.detailTextLabel.text = [[[SilvestreTraductorNumerosBDD traduirGrau:ressenya.dificultat] stringByAppendingString:@" - "]stringByAppendingString:[SilvestreTraductorNumerosBDD traduirEstil:ressenya.estil]];
    cell.detailTextLabel.textColor = [SilvestreTraductorNumerosBDD traduirColorGrau:ressenya.dificultat];
    [self.indicadorCarregant stopAnimating];
    [self.indicadorCarregant setHidden:YES];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    self.buidaTableView = NO;
    Ressenyes *ressenya = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"Detalls ressenya"]) {
        [segue.destinationViewController setRessenya:ressenya];
        [segue.destinationViewController setBDDRessenyes:self.BDDRessenyes];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}
- (void)viewDidUnload {
    [self setIndicadorCarregant:nil];
    [super viewDidUnload];
}
@end
