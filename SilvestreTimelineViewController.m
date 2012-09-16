//
//  SilvestreTimelineViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreTimelineViewController.h"
#import "SilvestreResumDadesViewController.h"
#import "SilvestreTraductorNumerosBDD.h"
#import "Ressenyes.h"
#import "Llocs+Create.h"
#import "Imatges.h"
#import "NSDate+Helper.h"

static dispatch_once_t once;

@interface SilvestreTimelineViewController()
@property(nonatomic) BOOL buidaTableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicadorCarrega;

@end

@implementation SilvestreTimelineViewController

@synthesize BDDRessenyes = _BDDRessenyes;
@synthesize buidaTableView = _buidaTableView;
@synthesize indicadorCarrega = _inicadorCarrega;


- (void)setupFetchedResultsController 
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ressenyes"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.BDDRessenyes.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    //Carreguem els llocs per defecte
    dispatch_once(&once, ^{
        NSLog(@"once");
        [Llocs crearLlocAmbNom:@"Can Romu" coordenades:NULL adreca:NULL avatar:[UIImage imageNamed:@"can romu.png"] inManagedObjectContext:self.BDDRessenyes.managedObjectContext];
        [Llocs crearLlocAmbNom:@"Climbat" coordenades:NULL adreca:NULL avatar:[UIImage imageNamed:@"climbat.png"] inManagedObjectContext:self.BDDRessenyes.managedObjectContext];
        [Llocs crearLlocAmbNom:@"La Panxa Del Bou" coordenades:NULL adreca:NULL avatar:[UIImage imageNamed:@"panxa del bou.png"] inManagedObjectContext:self.BDDRessenyes.managedObjectContext];
        [Llocs crearLlocAmbNom:@"Via Boulder" coordenades:NULL adreca:NULL avatar:[UIImage imageNamed:@"viaboulder.png"] inManagedObjectContext:self.BDDRessenyes.managedObjectContext];
    });
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
        [self.indicadorCarrega startAnimating];
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
    [self.indicadorCarrega stopAnimating];
    [self.indicadorCarrega setHidden:YES];

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
    [self setIndicadorCarrega:nil];
    [super viewDidUnload];
}
@end
