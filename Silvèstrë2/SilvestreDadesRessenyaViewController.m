//
//  SilvestreDadesRessenyaViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreDadesRessenyaViewController.h"
#import "SilvestreImageEditorViewController.h"
#import "Ressenyes+Create.h"
#import "Configuracio+Create.h"
#import "Llocs.h"
#import "SilvestreEditor.h"

@interface SilvestreDadesRessenyaViewController ()

@property(nonatomic,strong) NSDecimalNumber *dificultat;
@property(nonatomic,strong) NSDecimalNumber *estil;
@property(nonatomic) BOOL ferPerDefecte;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SilvestreDadesRessenyaViewController

@synthesize imatgeEditadaView = _imatgeEditadaView;
@synthesize imatgeEditadaPerPujar = _imatgeEditadaPerPujar;
@synthesize dificultat = _dificultat;
@synthesize estil = _estil;
@synthesize scrollView = _scrollView;
@synthesize BDDRessenyes =_BDDRessenyes;
@synthesize delegate = _delegate;
@synthesize ferPerDefecte = _ferPerDefecte;
@synthesize orientacio =_orientacio;



float tableHeight = 30;


- (void) finishedSearching {
	[txtField resignFirstResponder];
	autoCompleteTableView.hidden = YES;
}

-(NSString *)llocPerDefecte 
{
    NSString *llocDefecte = [[NSString alloc]initWithString:@""];
    NSString *string=[[NSString alloc]initWithString:@"default"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Configuracio"];
    request.predicate = [NSPredicate predicateWithFormat:@"nomUsuari = %@",string];
    
    NSError *error = nil;
    NSArray *matches = [self.BDDRessenyes.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches) {
        // handle error
        NSLog(@"error");
    } else {
        Configuracio *config = [matches lastObject];
        llocDefecte = config.llocPerDefecte.nom;
        
    }
    return llocDefecte;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundInfoTexture.png"]]];
    
    self.dificultat = [[NSDecimalNumber alloc] initWithInt:0];
    self.estil = [[NSDecimalNumber alloc] initWithInt:0];
	//Pull the content from the file into memory
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"elements.txt" ofType:nil];
	NSData* data = [NSData dataWithContentsOfFile:filePath];
    
	//Convert the bytes from the file into a string
	NSString* string = [[NSString alloc] initWithBytes:[data bytes]
												 length:[data length] 
											   encoding:NSUTF8StringEncoding];
	
	//Split the string around newline characters to create an array
	NSString* delimiter = @"\n";
	NSArray *item = [string componentsSeparatedByString:delimiter];
	elementArray = [[NSMutableArray alloc] initWithArray:item];
	autoCompleteArray = [[NSMutableArray alloc] init];

	//Search Bar
	txtField = [[UITextField alloc] initWithFrame:CGRectMake(30, 60, 261, 41)];
	txtField.borderStyle = 3; // rounded, recessed rectangle
	txtField.autocorrectionType = UITextAutocorrectionTypeNo;
	txtField.textAlignment = UITextAlignmentLeft;
	txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	txtField.returnKeyType = UIReturnKeyDone;
	//txtField.font = [UIFont fontWithName:@"Trebuchet MS" size:22];
	txtField.textColor = [UIColor blackColor];
	[txtField setDelegate:self];
	[self.scrollView addSubview:txtField];
    
    
	//Autocomplete Table
	autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(31, 96, 259, tableHeight) style:UITableViewStylePlain];
	autoCompleteTableView.delegate = self;
	autoCompleteTableView.dataSource = self;
	autoCompleteTableView.scrollEnabled = YES;
	autoCompleteTableView.hidden = YES; 
	autoCompleteTableView.rowHeight = tableHeight;
	[self.scrollView addSubview:autoCompleteTableView];
	
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    txtField.text = [self llocPerDefecte];
}

// Take string from Search Textfield and compare it with autocomplete array
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
	
	// Put anything that starts with this substring into the autoCompleteArray
	// The items in this array is what will show up in the table view
	
	[autoCompleteArray removeAllObjects];
    
	for(NSString *curString in elementArray) {
        
		NSRange substringRangeLowerCase = [[curString lowercaseString]rangeOfString:[substring lowercaseString]];
        NSRange substringRangeUpperCase = [[curString uppercaseString]rangeOfString:[substring uppercaseString]];        
		
        if (substringRangeLowerCase.length != 0 || substringRangeUpperCase.length != 0) {
			[autoCompleteArray addObject:curString];
		}
	}
	
	autoCompleteTableView.hidden = NO;
	[autoCompleteTableView reloadData];
}

// Close keyboard if the Background is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.scrollView endEditing:YES];
	[super touchesBegan:touches withEvent:event];
	[self finishedSearching];
}

#pragma mark UITextFieldDelegate methods

// Close keyboard when Enter or Done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
	BOOL isDone = YES;
	if (isDone) {
		[self finishedSearching];
		return YES;
	} else {
		return NO;
	}
   
} 

// String in Search textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    txtField.backgroundColor = [UIColor whiteColor];
	NSString *substring = [NSString stringWithString:textField.text];
	substring = [substring stringByReplacingCharactersInRange:range withString:string];
	[self searchAutocompleteEntriesWithSubstring:substring];
	return YES;
}

#pragma mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    
	//Resize auto complete table based on how many elements will be displayed in the table
	if (autoCompleteArray.count >=3) {
		autoCompleteTableView.frame = CGRectMake(31, 96, 259, tableHeight*3);
		return autoCompleteArray.count;
	}
	
	else if (autoCompleteArray.count == 2) {
		autoCompleteTableView.frame = CGRectMake(31, 96, 259, tableHeight*2);
		return autoCompleteArray.count;
	}	
	
	else {
		autoCompleteTableView.frame = CGRectMake(31, 96, 259, tableHeight);
		return autoCompleteArray.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
	}
    
	cell.textLabel.text = [autoCompleteArray objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	txtField.text = selectedCell.textLabel.text;
	[self finishedSearching];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidUnload
{
    [self setImatgeEditadaView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)ferLlocPerDefecte:(UISwitch *)sender {
    self.ferPerDefecte = sender.on;
}

- (IBAction)cancelar:(UIButton *)sender 
{
    [self.delegate setHaGuardat:NO];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)triarDificultat:(UISegmentedControl *)sender 
{
    NSDecimalNumber *actualitzarValor = [[NSDecimalNumber alloc] initWithFloat:sender.selectedSegmentIndex];
    self.dificultat = actualitzarValor;
}

- (IBAction)triarEstil:(UISegmentedControl *)sender 
{
    NSDecimalNumber *actualitzarValor = [[NSDecimalNumber alloc] initWithFloat:sender.selectedSegmentIndex];
    self.estil = actualitzarValor;
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


- (IBAction)pujarRessenya:(UIButton *)sender {

    if([txtField.text isEqualToString:@""]) {
        txtField.backgroundColor = [UIColor redColor];
        self.scrollView.bounds = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        UIImage *miniatura = [[UIImage alloc]init];
        UIImage *thumbnail = [[UIImage alloc]init];
        CGFloat scale = [[UIScreen mainScreen] scale];//adaptació pantalles retina

        miniatura = [SilvestreEditor ferMiniaturaQuadradaDe:self.imatgeEditadaPerPujar ambMida:CGSizeMake(300*scale, 300*scale)];
        thumbnail = [SilvestreEditor ferMiniaturaQuadradaDe:self.imatgeEditadaPerPujar ambMida:CGSizeMake(150*scale, 150*scale)];
        [self.BDDRessenyes.managedObjectContext performBlock:^{         
            
            [Ressenyes ressenyaAlLloc:txtField.text 
                                autor:@"default"
                           dificultat:self.dificultat 
                                estil:self.estil 
                               imatge:self.imatgeEditadaPerPujar
                            miniatura:miniatura
                            thumbnail:thumbnail
                           orientacio:self.orientacio
                                 data:[NSDate date] 
                        idRessenyaWEB:NULL 
                               pujada:NO 
                           ressenyada:YES 
                           encadenada:NO 
                             projecte:NO 
                           esTemporal:NO 
               inManagedObjectContext:self.BDDRessenyes.managedObjectContext];
            if(self.ferPerDefecte) {
                [Configuracio crearConfiguracioAmbUsuari:@"default" 
                                            contrassenya:@"default" 
                                          llocPerDefecte:txtField.text
                                                  avatar:NULL 
                                  inManagedObjectContext:self.BDDRessenyes.managedObjectContext];
            }
            [self.BDDRessenyes saveToURL:self.BDDRessenyes.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        }];
        [self.delegate setHaGuardat:YES];
        [self dismissModalViewControllerAnimated:YES];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.delegate setHaGuardat:NO];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    self.imatgeEditadaView.image = self.imatgeEditadaPerPujar;
    if (!self.BDDRessenyes) {  
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"BDDRessenyes"];
        self.BDDRessenyes = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}
@end
