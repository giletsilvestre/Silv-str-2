//
//  SilvestreImageEditorViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define MIDAXMA 0.07
#define MIDAYMA 0.07
#define MIDAXMANS 0.14
#define MIDAYMANS 0.07
#define CORRECCIOX 0.05 /*Desviació X del toc(tap gesture) i on ha d'apareixer visualment*/
#define CORRECCIOY 0.02 /*Desviació Y del toc(tap gesture) i on ha d'apareixer visualment*/
#define MIDANUMEROS 0.0495 /*Numeros de les mans*/
#define MIDATEXTWATERMARK 0.08
#define MIDAYWATERMARK 0.07
#define COMPRESSIO 2
#define ARROSSEGAROFFSET 0.19 /*Desplaçament per arrossegar la mà i poder veurela sobre el dit*/


#import "SilvestreImageEditorViewController.h"
#import "SilvestreEditor.h"
#import "SilvestreThirdViewController.h"
#import "SilvestreDadesRessenyaViewController.h"
#import "UIImage+Transformacions.h"

@interface SilvestreImageEditorViewController ()
    
@property (nonatomic,strong) SilvestreEditor *editor;

@end

@implementation SilvestreImageEditorViewController

@synthesize imatgeView = _imatgeView;
@synthesize imatgeInicial = _imatgeInicial;
@synthesize imatgeDeLaBDD = _imatgeDeLaBDD;
@synthesize orientacioOriginal = _orientacioOriginal;
@synthesize haGuardat = _haGuardat;
@synthesize editor = _editor;


-(void)refrescaLaImatge:(UIImage *) imatge
{
    self.imatgeView.image = imatge;
}

-(CGPoint)coordenadesPantallaRetina:(CGPoint)punt
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGPoint puntAdaptat = CGPointMake(punt.x*scale, punt.y*scale);
    return puntAdaptat;
}

//funció que s'executa quan algú fa un toc a la pantalla
-(void)tap:(UITapGestureRecognizer *) gesture 
{
    CGPoint p = [gesture locationInView:self.imatgeView];
    p = [self coordenadesPantallaRetina:p];
    if(gesture.state == UIGestureRecognizerStateEnded) {
        [self refrescaLaImatge: [self.editor haFetUnToc:p aLaImatge: self.imatgeView.image]];
        
    }
}


//funció que s'executa quan algú arrossega el dit per la pantalla
-(void)pan:(UIPanGestureRecognizer *) gesture 
{
    if(!self.editor.haDesfetUlimPas) {
        
        CGPoint p = [gesture locationInView:self.imatgeView];
        p = [self coordenadesPantallaRetina:p];
        if(gesture.state == UIGestureRecognizerStateBegan && !self.editor.estaArrossegant) {
            [self refrescaLaImatge:[self.editor comencaArrossegar:p]];
    
        } else if(gesture.state == UIGestureRecognizerStateEnded) {
            [self refrescaLaImatge:[self.editor finalitzaArrossegar:p]];
        } else {
            [self refrescaLaImatge:[self.editor continuaArrossegar:p]];
        }
    }
}



- (IBAction)guardar:(UIButton *)sender {
    self.haGuardat = YES;
    [self.editor guardar];
    [self performSegueWithIdentifier:@"Dades ressenya" sender:self];

}

- (IBAction)maDreta:(UIButton *)sender 
{
    self.editor.maActual = @"Dreta";
}

- (IBAction)maEsquerra:(UIButton *)sender 
{
    self.editor.maActual = @"Esquerra";
}

- (IBAction)maJuntes:(UIButton *)sender 
{
    self.editor.maActual = @"Juntes";
}

- (IBAction)desferUltim:(UIButton *)sender 
{
    self.imatgeView.image = [self.editor desferUltimPasDesde:self.imatgeView.image];
}

- (IBAction)descartarImatge:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:0];
}

-(void)setImatgeView:(UIImageView *)im 
{
    _imatgeView = im;
    self.imatgeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapgr.numberOfTapsRequired = 1;
    tapgr.numberOfTouchesRequired = 1;
    [self.imatgeView addGestureRecognizer:tapgr];
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imatgeView addGestureRecognizer:pangr];
}


//Fem totes les inicialitzacions abans de que es carregui la vista
-(void) viewWillAppear:(BOOL)animated
{    
    if(self.haGuardat != YES){
        self.haGuardat = NO;
        self.editor = [[SilvestreEditor alloc]init];
        self.editor.imatgeInicial = self.imatgeInicial;
        self.editor.imatgeDeLaBDD = self.imatgeDeLaBDD;
        self.editor.orientacioOriginal = self.orientacioOriginal;
        //Per a dispositius amb pantalla retina torna 2.0, sino 1.0
        CGFloat proporcioPantalla = [[UIScreen mainScreen] scale];
        CGSize resolucio = CGSizeMake(self.imatgeView.frame.size.width*proporcioPantalla, self.imatgeView.frame.size.height*proporcioPantalla);
        [self.editor inicialitzar:resolucio];
        self.imatgeView.image = self.editor.imatgeInicialRedimensionada;
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Dades ressenya"]){  
        [segue.destinationViewController setImatgeEditadaPerPujar:self.editor.imatgeFinal];
        [segue.destinationViewController setOrientacio:self.editor.orientacioOriginal.floatValue];
        [segue.destinationViewController setDelegate:self];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.haGuardat) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
