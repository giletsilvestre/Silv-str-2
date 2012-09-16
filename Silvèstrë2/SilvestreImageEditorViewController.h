//
//  SilvestreImageEditorViewController.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SilvestreImageEditorViewController : UIViewController

@property (nonatomic) UIImage *imatgeInicial;
@property (strong, nonatomic) IBOutlet UIImageView *imatgeView;
@property (nonatomic) BOOL haGuardat;
@property (nonatomic,strong) NSNumber *orientacioOriginal;
@property (nonatomic) BOOL imatgeDeLaBDD;

-(void)tap:(UITapGestureRecognizer *)gesture;
-(void)pan:(UIPanGestureRecognizer *)gesture;

-(IBAction)guardar:(UIButton *)sender;
- (IBAction)maDreta:(UIButton *)sender;
- (IBAction)maEsquerra:(UIButton *)sender;
- (IBAction)maJuntes:(UIButton *)sender;
- (IBAction)desferUltim:(UIButton *)sender;
- (IBAction)descartarImatge:(UIButton *)sender;

@end
