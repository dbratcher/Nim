    //
//  StackSettings.m
//  Nim
//
//  Created by Drew on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StackSettingsViewController.h"


@implementation StackSettingsViewController

@synthesize stack_1_label,stack_2_label,stack_3_label,stack_4_label,stack_1_slider,stack_2_slider,stack_3_slider,stack_4_slider;

-(IBAction)stack_1_slider_changed:(id)sender{
	UISlider *slider=(UISlider *)sender;
	int slider_int_val=(int)(slider.value+0.5f);
	stack_1_label.text=[NSString stringWithFormat:@"%d",slider_int_val];
	slider.value=slider_int_val;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:slider_int_val] forKey:@"num_stones_stack_1"];
}
-(IBAction)stack_2_slider_changed:(id)sender{
	UISlider *slider=(UISlider *)sender;
	int slider_int_val=(int)(slider.value+0.5f);
	stack_2_label.text=[NSString stringWithFormat:@"%d",slider_int_val];
	slider.value=slider_int_val;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:slider_int_val] forKey:@"num_stones_stack_2"];
}
-(IBAction)stack_3_slider_changed:(id)sender{
	UISlider *slider=(UISlider *)sender;
	int slider_int_val=(int)(slider.value+0.5f);
	stack_3_label.text=[NSString stringWithFormat:@"%d",slider_int_val];
	slider.value=slider_int_val;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:slider_int_val] forKey:@"num_stones_stack_3"];
}
-(IBAction)stack_4_slider_changed:(id)sender{
	UISlider *slider=(UISlider *)sender;
	int slider_int_val=(int)(slider.value+0.5f);
	stack_4_label.text=[NSString stringWithFormat:@"%d",slider_int_val];
	slider.value=slider_int_val;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:slider_int_val] forKey:@"num_stones_stack_4"];
}



-(IBAction)BackToSettingsView:(id)sender{
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
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSInteger stack_1_val = [defaults integerForKey:@"num_stones_stack_1"];
	stack_1_slider.value=stack_1_val;
	stack_1_label.text=[NSString stringWithFormat:@"%ld",(long)stack_1_val];
	NSInteger stack_2_val = [defaults integerForKey:@"num_stones_stack_2"];
	stack_2_slider.value=stack_2_val;
	stack_2_label.text=[NSString stringWithFormat:@"%ld",(long)stack_2_val];
	NSInteger stack_3_val = [defaults integerForKey:@"num_stones_stack_3"];
	stack_3_slider.value=stack_3_val;
	stack_3_label.text=[NSString stringWithFormat:@"%ld",(long)stack_3_val];
	NSInteger stack_4_val = [defaults integerForKey:@"num_stones_stack_4"];
	stack_4_slider.value=stack_4_val;
	stack_4_label.text=[NSString stringWithFormat:@"%ld",(long)stack_4_val];
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
    [super dealloc];
}


@end
