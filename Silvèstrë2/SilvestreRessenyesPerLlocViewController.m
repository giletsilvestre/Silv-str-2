//
//  SilvestreRessenyesPerLlocViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreRessenyesPerLlocViewController.h"
#import "SilvestreResumDadesViewController.h"
#import "SilvestreTraductorNumerosBDD.h"
#import "Ressenyes.h"
#import "Imatges.h"
#import "NSDate+Helper.h"

@interface SilvestreRessenyesPerLlocViewController()

@end

@implementation SilvestreRessenyesPerLlocViewController

@synthesize lloc = _lloc;


- (void)setupFetchedResultsController 
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ressenyes"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"data"
                                                                                     ascending:NO]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"lloc.nom = %@", self.lloc.nom];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.lloc.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)viewDidLoad {
    self.tableView.rowHeight = 100;
}

- (void)setLloc:(Llocs *)lloc
{
    _lloc = lloc;
    self.title = lloc.nom;
    [self setupFetchedResultsController];
}

// 18. Load up our cell using the NSManagedObject retrieved using NSFRC's objectAtIndexPath:
// (back to PhotographersTableViewController.m for next step, segueing)

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
    
    return cell;
}

// 20. Add segue to show the photo (ADDED AFTER LECTURE)

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    Ressenyes *ressenya = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"Detalls ressenya"]) {
        
        [segue.destinationViewController setRessenya:ressenya];
    }
}



@end

