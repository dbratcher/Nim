    //
//  SettingsViewController.m
//  Nim
//
//  Created by Drew on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "StackSettingsViewController.h"

@implementation SettingsViewController

@synthesize num_stacks_label,removable_label,ai_diff_label,stack_slider,rem_slider,ai_slider;
StackSettingsViewController *stack_settings;


-(IBAction)ai_slider_changed:(id)sender{
	UISlider *slider=(UISlider *)sender;
	int slider_int_val=(int)(slider.value+0.5f);
	ai_diff_label.text=[NSString stringWithFormat:@"%d",slider_int_val];
	slider.value=slider_int_val;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:slider_int_val] forKey:@"ai_diff"];
}

-(IBAction)rem_slider_changed:(id)sender{
	UISlider *slider=(UISlider *)sender;
	int slider_int_val=(int)(slider.value+0.5f);
	removable_label.text=[NSString stringWithFormat:@"%d",slider_int_val];
	slider.value=slider_int_val;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:slider_int_val] forKey:@"max_rem"];
}

-(IBAction)stack_slider_changed:(id)sender{
	UISlider *slider=(UISlider *)sender;
	int slider_int_val=(int)(slider.value+0.5f);
	num_stacks_label.text=[NSString stringWithFormat:@"%d",slider_int_val];
	slider.value=slider_int_val;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:slider_int_val] forKey:@"num_stacks"];
}



-(IBAction)StackSettingsView:(id)sender{
	stack_settings = [[StackSettingsViewController alloc]
					  initWithNibName:@"StackSettingsView" bundle:nil];
	[self.view addSubview:stack_settings.view];
}

-(IBAction)BackToFirstView:(id)sender{
	[self.view removeFromSuperview];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Get user object for any preset values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// Get preset number of stacks
	NSInteger num_stacks = [defaults integerForKey:@"num_stacks"];
	stack_slider.value=num_stacks;
	num_stacks_label.text=[NSString stringWithFormat:@"%ld",(long)num_stacks];
	// Get preset ai difficulty
	NSInteger ai_diff = [defaults integerForKey:@"ai_diff"];
	ai_slider.value=ai_diff;
	ai_diff_label.text=[NSString stringWithFormat:@"%ld",(long)ai_diff];
	// Get preset max remove
	NSInteger max_rem = [defaults integerForKey:@"max_rem"];
	rem_slider.value=max_rem;
	removable_label.text=[NSString stringWithFormat:@"%ld",(long)max_rem];
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[num_stacks_label release];
	[ai_diff_label release];
	[removable_label release];
	[ai_slider release];
	[rem_slider release];
	[stack_slider release];
    [super dealloc];
}


@end
