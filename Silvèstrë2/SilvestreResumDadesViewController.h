//
//  SilvestreResumDadesViewController.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <twitter/twitter.h>
#import "Ressenyes.h"

@interface SilvestreResumDadesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imatgeResumView;
@property (strong, nonatomic) Ressenyes *ressenya;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *dificultatLabel;
@property (strong, nonatomic) IBOutlet UILabel *estilLabel;
@property (strong, nonatomic) IBOutlet UIImageView *encadenadaImageView;
@property (strong, nonatomic) IBOutlet UIImageView *projecteImageView;
@property (strong, nonatomic) IBOutlet UIButton *botoProjecte;
@property (strong, nonatomic) IBOutlet UIButton *botoEncadenada;


@property (strong, nonatomic) IBOutlet UIImageView *llocView;
@property (nonatomic, strong) UIManagedDocument *BDDRessenyes;
@property (strong, nonatomic) IBOutlet UIButton *ferRessenyaControl;

- (IBAction)encadenada:(UIButton *)sender;
- (IBAction)afegirAProjectes:(UIButton *)sender;
- (IBAction)compartir:(UIBarButtonItem *)sender;
- (IBAction)ferRessenya:(UIButton *)sender;
- (IBAction)eliminarRessenya:(UIButton *)sender;

@end
