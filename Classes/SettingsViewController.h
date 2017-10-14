//
//  SettingsViewController.h
//  Nim
//
//  Created by Drew on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_STACKS 4
#define MIN_STACKS 2
#define MAX_STONES 5
#define MIN_STONES 1
#define MAX_REMOVE 6
#define MIN_REMOVE 1


@interface SettingsViewController : UIViewController {
	IBOutlet UILabel *num_stacks_label;
	IBOutlet UILabel *removable_label;
	IBOutlet UILabel *ai_diff_label;
	IBOutlet UISlider *ai_slider;
	IBOutlet UISlider *rem_slider;
	IBOutlet UISlider *stack_slider;
    IBOutlet UISegmentedControl *first_mover_control;
}

-(IBAction)BackToFirstView:(id)sender;
-(IBAction)StackSettingsView:(id)sender;
-(IBAction)ai_slider_changed:(id)sender;
-(IBAction)rem_slider_changed:(id)sender;
-(IBAction)stack_slider_changed:(id)sender;
-(IBAction)first_move_changed:(id)sender;

@property(nonatomic, retain) UILabel *num_stacks_label;
@property(nonatomic, retain) UILabel *removable_label;
@property(nonatomic, retain) UILabel *ai_diff_label;
@property(nonatomic, retain) UISlider *ai_slider;
@property(nonatomic, retain) UISlider *rem_slider;
@property(nonatomic, retain) UISlider *stack_slider;

@end
