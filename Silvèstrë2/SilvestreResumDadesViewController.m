//
//  SilvestreResumDadesViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "SilvestreResumDadesViewController.h"
#import "SilvestreImatgeScrollViewController.h"
#import "SilvestreTraductorNumerosBDD.h"
#import "SilvestreXarxesSocialsViewController.h"
#import "SilvestreImageEditorViewController.h"
#import "Llocs.h"
#import "Imatges.h"


@interface SilvestreResumDadesViewController() <UIActionSheetDelegate>

@property (nonatomic,strong) NSString *xarxaSocialEscollida;

@end

@implementation SilvestreResumDadesViewController
@synthesize imatgeResumView = _imatgeResumView;
@synthesize ressenya = _ressenya;
@synthesize scrollView = _scrollView;
@synthesize dificultatLabel = _dificultatLabel;
@synthesize estilLabel = _estilLabel;
@synthesize encadenadaImageView = _encadenadaImageView;
@synthesize projecteImageView = _projecteImageView;
@synthesize botoProjecte = _botoProjecte;
@synthesize botoEncadenada = _botoEncadenada;
@synthesize llocView = _llocView;
@synthesize xarxaSocialEscollida =_xarxaSocialEscollida;
@synthesize BDDRessenyes = _BDDRessenyes;
@synthesize ferRessenyaControl = _ferRessenyaControl;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIImage *imatgeRessenya = self.ressenya.imatge.imatge;
    NSLog(@"orientacio %f",[self.ressenya.imatge.orientacio floatValue]);
    if([segue.identifier isEqualToString:@"Vista imatge en gran"]) {
        [segue.destinationViewController setImatgeInicial:imatgeRessenya];
    } else if ([segue.identifier isEqualToString:@"Pujar xarxes socials"]) {
        
        [segue.destinationViewController setRessenya:self.ressenya];
        [segue.destinationViewController setXarxaSocialEscollida:self.xarxaSocialEscollida];
    } else if([segue.identifier isEqualToString:@"Fer ressenya"]){
        [segue.destinationViewController setImatgeInicial:imatgeRessenya];
        [segue.destinationViewController setOrientacioOriginal:self.ressenya.imatge.orientacio];
        [segue.destinationViewController setImatgeDeLaBDD:YES];
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundInfoTexture.png"]]];
}


- (IBAction)encadenada:(UIButton *)sender {
    if(![self.ressenya.encadenada boolValue]) {
        self.ressenya.encadenada = [NSNumber numberWithBool:YES];
        if(self.ressenya.projecte.boolValue) {
            self.ressenya.projecte = [NSNumber numberWithBool:NO];
            self.projecteImageView.image = [UIImage imageNamed:@"delete.png"];

        }
        self.encadenadaImageView.image = [UIImage imageNamed:@"check.png"];
    } else {
        self.ressenya.encadenada = [NSNumber numberWithBool:NO];
        self.encadenadaImageView.image = [UIImage imageNamed:@"delete.png"];
    }
}

- (IBAction)afegirAProjectes:(UIButton *)sender {
    if(!self.ressenya.projecte.boolValue) {
        self.ressenya.projecte = [NSNumber numberWithBool:YES];
        self.projecteImageView.image = [UIImage imageNamed:@"check.png"];
    } else {
        self.ressenya.projecte = [NSNumber numberWithBool:NO];
        self.projecteImageView.image = [UIImage imageNamed:@"delete.png"];

    }
}

- (IBAction)compartir:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Accions" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"cancel·la" 
                                              destructiveButtonTitle:nil 
                                                   otherButtonTitles:@"Pujar a Twitter", @"Guardar al carret",nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)ferRessenya:(UIButton *)sender {
    
}



- (IBAction)eliminarRessenya:(UIButton *)sender {
    [self.BDDRessenyes.managedObjectContext deleteObject:self.ressenya];
    [self.navigationController popViewControllerAnimated:YES];    
}

-(void)pujarTwitter:(UIImage *)imatge
{
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweet = 
        [[TWTweetComposeViewController alloc] init];
        [tweet setInitialText:@"Silvestre"];
        [tweet addImage:imatge];
        [self presentModalViewController:tweet animated:YES];
    } else {
        //error
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImage *imatgeGuardar = self.ressenya.imatge.imatge;
    NSData *imgdata = UIImageJPEGRepresentation(imatgeGuardar,1.0);
    imatgeGuardar = [UIImage imageWithData:imgdata];
;
    
    switch (buttonIndex) {
        case 0:
            [self pujarTwitter:imatgeGuardar];
            break;
        case 1:
            UIImageWriteToSavedPhotosAlbum(imatgeGuardar, nil, nil, nil);

        default:
            break;
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.ressenya.lloc.nom;
    self.imatgeResumView.image = self.ressenya.miniatura.imatge;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);    
    self.llocView.image = self.ressenya.lloc.avatar.imatge;
    NSLog(@"%@",[SilvestreTraductorNumerosBDD traduirGrau:self.ressenya.dificultat]);
    self.dificultatLabel.text = [SilvestreTraductorNumerosBDD traduirGrau:self.ressenya.dificultat];
    self.dificultatLabel.textColor = [SilvestreTraductorNumerosBDD traduirColorGrau:self.ressenya.dificultat];
    self.estilLabel.text = [SilvestreTraductorNumerosBDD traduirEstil:self.ressenya.estil];
    //Determinar visibilitat botons
    if([self.ressenya.ressenyada boolValue]) {
        [self.ferRessenyaControl setHidden:YES];
    } else {
        [self.botoEncadenada setHidden:YES];
        [self.botoProjecte setHidden:YES];
    }
    //Inicialitzar botó encadenada i imageview encadenada
    if(!self.ressenya.encadenada.boolValue) {//NO ha encadenat
        self.encadenadaImageView.image = [UIImage imageNamed:@"delete.png"];
    } else {//SI ha encadenat
        self.encadenadaImageView.image = [UIImage imageNamed:@"check.png"];
    }
    //Inicialitzar botó afegir a projectes
    if(!self.ressenya.projecte.boolValue) {//NO és projecte
        self.projecteImageView.image = [UIImage imageNamed:@"delete.png"];
    } else {//SI és projecte
        self.projecteImageView.image = [UIImage imageNamed:@"check.png"];
        
    }
}

- (void)viewDidUnload {
    [self setImatgeResumView:nil];
    [self setScrollView:nil];
    [self setDificultatLabel:nil];
    [self setEstilLabel:nil];
    [self setLlocView:nil];
    [self setFerRessenyaControl:nil];
    [self setEncadenadaImageView:nil];
    [self setProjecteImageView:nil];
    [self setBotoProjecte:nil];
    [self setBotoEncadenada:nil];
    [super viewDidUnload];
}

@end
