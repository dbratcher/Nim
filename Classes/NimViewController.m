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
    second.view.backgroundColor = self.tileColor;
	[self.view addSubview:second.view];
}

-(IBAction)SettingsView:(id)sender{
	settings = [[SettingsViewController alloc]
                initWithNibName:@"SettingsView" bundle:nil];
    settings.view.backgroundColor = self.tileColor;
	[self.view addSubview:settings.view];
}

-(IBAction)BoardView1:(id)sender{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:1] forKey:@"num_players"];
	board = [[BoardViewController alloc]
             initWithNibName:@"BoardView" bundle:nil];
    board.view.backgroundColor = self.tileColor;
	[self.view addSubview:board.view];
}

-(IBAction)BoardView2:(id)sender{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:2] forKey:@"num_players"];
	board = [[BoardViewController alloc]
			 initWithNibName:@"BoardView" bundle:nil];
    board.view.backgroundColor = self.tileColor;
	[self.view addSubview:board.view];
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (UIColor *)tileColor
{
    UIImage *pattern = [UIImage imageNamed:@"Background"];
    UIColor *tileColor = [UIColor colorWithPatternImage: pattern];
    
    return tileColor;
}

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = self.tileColor;
}

- (void)dealloc {
	[second release];
    [super dealloc];
}

@end
