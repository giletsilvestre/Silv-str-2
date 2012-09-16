//
//  SilvestreXarxesSocialsViewController.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <twitter/twitter.h>
#import "Ressenyes.h"
#import "Imatges.h"

@interface SilvestreXarxesSocialsViewController : UIViewController

@property (strong,nonatomic) Ressenyes *ressenya;
@property (strong,nonatomic) NSDecimalNumber *xarxaSocial;
@property (strong, nonatomic) NSString *xarxaSocialEscollida;
@property (strong, nonatomic) IBOutlet UIImageView *imatgeView;
@property (strong, nonatomic) IBOutlet UIImageView *imatgeXarxaSocial;

- (IBAction)cancelButton:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

@end
