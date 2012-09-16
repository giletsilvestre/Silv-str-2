//
//  SilvestreLlocsViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreLlocsViewController.h"
#import "SilvestreRessenyesPerLlocViewController.h"
#import "Llocs.h"
#import "Imatges.h"
#import "Ressenyes.h"

@implementation SilvestreLlocsViewController

@synthesize BDDRessenyes = _BDDRessenyes;

- (void)setupFetchedResultsController 
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Llocs"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nom" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.BDDRessenyes.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performFetch];
}

-(void)viewDidLoad {
    self.tableView.rowHeight = 100;
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
    
    if (!self.BDDRessenyes) { 
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"BDDRessenyes"];
        self.BDDRessenyes = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Lloc";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Llocs *lloc = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = lloc.nom;
    
    if(lloc.avatar.imatge != Nil) {
        cell.imageView.image = lloc.avatar.imatge;
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[lloc.ressenyes count]];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    Llocs *lloc = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"Ressenyes per lloc"]) {
        
        [segue.destinationViewController setLloc:lloc];
    }
}

@end

