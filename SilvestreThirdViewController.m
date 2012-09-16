//
//  SilvestreThirdViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreThirdViewController.h"
#import "SilvestreImageEditorViewController.h"
#import "SilvestreDadesRessenyaViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Ressenyes+Create.h"
#import "UIImage+Transformacions.h"
#import "SilvestreEditor.h"

@interface SilvestreThirdViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate>

@property(nonatomic) NSNumber *orientacioImatge;
@property(nonatomic) UIImage *imatge;


@end

@implementation SilvestreThirdViewController

@synthesize imatge = _imatge;
@synthesize BDDRessenyes = _BDDRessenyes;
@synthesize orientacioImatge = _orientacioImatge;


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Editor"]) {        
        [segue.destinationViewController setImatgeInicial:self.imatge];
        [segue.destinationViewController setOrientacioOriginal:self.orientacioImatge];
        [segue.destinationViewController setImatgeDeLaBDD:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.editing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:picker animated:YES];
            
        }
    } else {
        NSLog(@"haentratA");
    }
    //Si hem pres una foto però no esta editada, preparem el handler de la BDD
    if(self.imatge) {
        if (!self.BDDRessenyes) {  
            NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            url = [url URLByAppendingPathComponent:@"BDDRessenyes"];
            self.BDDRessenyes = [[UIManagedDocument alloc] initWithFileURL:url];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundInfoTexture.png"]]];
}

-(void)viewWillDisappear:(BOOL)animated 
{
    self.hidesBottomBarWhenPushed = NO;
}

-(void)dismissImagePicker
{
    [self dismissModalViewControllerAnimated:YES];
}



-(void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imatge = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.orientacioImatge = [NSNumber numberWithFloat:self.imatge.imageOrientation];
    self.imatge = [self.imatge imageByScalingProportionallyToSize:CGSizeMake(self.imatge.size.width, self.imatge.size.height)];
    [self dismissImagePicker];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker];
    [self.tabBarController setSelectedIndex:0];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.BDDRessenyes.fileURL path]]) {
        // does not exist on disk, so create it
        [self.BDDRessenyes saveToURL:self.BDDRessenyes.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        }];
    } else if (self.BDDRessenyes.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.BDDRessenyes openWithCompletionHandler:^(BOOL success) {
        }];
    } else if (self.BDDRessenyes.documentState == UIDocumentStateNormal) {
        // already open and ready to use
    }
}

// 2. Make the photoDatabase's setter start using it

- (void)setBDDRessenyes:(UIManagedDocument *)BDDRessenyes
{
    if (_BDDRessenyes != BDDRessenyes) {
        _BDDRessenyes = BDDRessenyes;
        [self useDocument];
    }
}

- (IBAction)guardarImatge:(UIButton *)sender {

    
    [self.BDDRessenyes.managedObjectContext performBlock:^{         
        
        [Ressenyes ressenyaAlLloc:@"Nd" 
                            autor:@"default"
                       dificultat:[NSDecimalNumber decimalNumberWithString:@"10"]
                            estil:[NSDecimalNumber decimalNumberWithString:@"10"]
                           imatge:self.imatge
                        miniatura:[SilvestreEditor ferMiniaturaQuadradaDe:self.imatge ambMida:CGSizeMake(300, 300)]
                        thumbnail:[SilvestreEditor ferMiniaturaQuadradaDe:self.imatge ambMida:CGSizeMake(100, 100)]
                       orientacio:self.orientacioImatge.floatValue
                             data:[NSDate date] 
                    idRessenyaWEB:NULL 
                           pujada:NO 
                       ressenyada:NO 
                       encadenada:NO 
                         projecte:NO 
                       esTemporal:NO 
           inManagedObjectContext:self.BDDRessenyes.managedObjectContext];
        
        [self.BDDRessenyes saveToURL:self.BDDRessenyes.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }];
    [self.tabBarController setSelectedIndex:0];
}
@end
