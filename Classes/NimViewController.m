//
//  NimViewController.m
//  Nim
//
//  Created by Drew on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NimViewController.h"
#import "HelpViewController.h"
#import "SettingsViewController.h"
#import "BoardViewController.h"

@implementation NimViewController
HelpViewController *second;
SettingsViewController *settings;
BoardViewController *board;

-(IBAction)HelpView:(id)sender{
	second = [[HelpViewController alloc]
			  initWithNibName:@"HelpView" bundle:nil];
	[self.view addSubview:second.view];
}

-(IBAction)SettingsView:(id)sender{
	settings = [[SettingsViewController alloc]
				initWithNibName:@"SettingsView" bundle:nil];
	[self.view addSubview:settings.view];
}

-(IBAction)BoardView1:(id)sender{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"num_players"];
	board = [[BoardViewController alloc]
			 initWithNibName:@"BoardView" bundle:nil];
	[self.view addSubview:board.view];
}

-(IBAction)BoardView2:(id)sender{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:2] forKey:@"num_players"];
	board = [[BoardViewController alloc]
			 initWithNibName:@"BoardView" bundle:nil];
	[self.view addSubview:board.view];
}



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[second release];
    [super dealloc];
}

@end
