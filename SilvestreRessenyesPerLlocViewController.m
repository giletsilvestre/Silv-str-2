//
//  SilvestreRessenyesPerLlocViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreRessenyesPerLlocViewController.h"
#import "SilvestreResumDadesViewController.h"
#import "Ressenyes.h"
#import "NSDate+Helper.h"

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
    cell.textLabel.text = [[[NSDate stringForDisplayFromDate:ressenya.data] stringByAppendingString:@" per "] stringByAppendingString: ressenya.autor];
    
    cell.detailTextLabel.alpha = 0.8;
    
    switch (ressenya.dificultat.integerValue) {
        case 0:
            cell.detailTextLabel.text = @"Facil";
            cell.detailTextLabel.textColor = [UIColor greenColor];
            break;
        case 1:
            cell.detailTextLabel.text = @"Moderat";
            cell.detailTextLabel.textColor = [UIColor blueColor];
            break; 
        case 2:
            cell.detailTextLabel.text = @"Dificil";
            cell.detailTextLabel.textColor = [UIColor redColor];
            break;
        default:
            cell.detailTextLabel.text = @"Facil";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            break;
    }
    switch (ressenya.estil.integerValue) {
        case 0:
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString: @" - Lliure"];
            break;
        case 1:
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString: @" - Mà peu"];
            break;
        case 2:
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString: @" - Sense peus"];
            break;
        default:
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString: @" - Lliure"];
            break;
    }
    
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

