//
//  StackSettings.h
//  Nim
//
//  Created by Drew on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StackSettingsViewController : UIViewController {
	IBOutlet UILabel *stack_1_label;
	IBOutlet UILabel *stack_2_label;
	IBOutlet UILabel *stack_3_label;
	IBOutlet UILabel *stack_4_label;
	IBOutlet UISlider *stack_1_slider;
	IBOutlet UISlider *stack_2_slider;
	IBOutlet UISlider *stack_3_slider;
	IBOutlet UISlider *stack_4_slider;
}
-(IBAction)BackToSettingsView:(id)sender;
-(IBAction)stack_1_slider_changed:(id)sender;
-(IBAction)stack_2_slider_changed:(id)sender;
-(IBAction)stack_3_slider_changed:(id)sender;
-(IBAction)stack_4_slider_changed:(id)sender;

@property(nonatomic, retain) UILabel *stack_1_label;
@property(nonatomic, retain) UILabel *stack_2_label;
@property(nonatomic, retain) UILabel *stack_3_label;
@property(nonatomic, retain) UILabel *stack_4_label;
@property(nonatomic, retain) UISlider *stack_1_slider;
@property(nonatomic, retain) UISlider *stack_2_slider;
@property(nonatomic, retain) UISlider *stack_3_slider;
@property(nonatomic, retain) UISlider *stack_4_slider;

@end
