//
//  SilvestreDadesRessenyaViewController.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SilvestreDadesRessenyaViewController : UIViewController <UITableViewDelegate, UITextFieldDelegate> 
{
    UIImage *imatgeEditadaPerPujar;
    NSMutableArray *autoCompleteArray; 
    NSMutableArray *elementArray, *lowerCaseElementArray;
    UITextField *txtField;
    UITableView *autoCompleteTableView;
}
@property (strong, nonatomic) IBOutlet UIImageView *imatgeEditadaView;
@property (nonatomic) UIImage *imatgeEditadaPerPujar;
@property (nonatomic,strong) UIManagedDocument *BDDRessenyes;
@property (nonatomic,assign) id delegate;
@property (nonatomic) float orientacio;

- (IBAction)ferLlocPerDefecte:(UISwitch *)sender;
- (IBAction)cancelar:(UIButton *)sender;
- (IBAction)triarDificultat:(UISegmentedControl *)sender;
- (IBAction)triarEstil:(UISegmentedControl *)sender;
- (IBAction)pujarRessenya:(UIButton *)sender;
@end
