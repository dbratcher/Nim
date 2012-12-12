//
//  GameViewController.h
//  Nim
//
//  Created by Drew Bratcher on 12/21/11.
//  Copyright 2011 Drew Bratcher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardViewController : UIViewController {
	int selected_stack;
	NSMutableArray *selected;
	IBOutlet UILabel *player;
}
-(IBAction)HelpView:(id)sender;
-(IBAction)BackToMenuView:(id)sender;
-(IBAction)stoneClicked:(id)sender;
-(IBAction)removeClicked:(id)sender;
-(void)Rise_Up_Repeat:(NSString *)animationID finished:(BOOL)finished context:(void *) context;
-(void)Rise_Up:(int)stone;
-(void)remove_pieces;
-(void)run_ai;

@property(nonatomic, retain) UILabel *player;

@end
