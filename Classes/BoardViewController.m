//
//  GameViewController.m
//  Nim
//
//  Created by Drew on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"
#import "HelpViewController.h"

@interface StoneButton : UIButton

@end

@implementation StoneButton: UIButton

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateColor:highlighted];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateColor:selected];
}

- (void)updateColor:(BOOL)colored
{
    if(colored) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

@end

@implementation BoardViewController

@synthesize player;

HelpViewController *help;
NSMutableArray *worldstate;


-(IBAction)HelpView:(id)sender{
	help = [[HelpViewController alloc]
			  initWithNibName:@"HelpView" bundle:nil];
	[self.view addSubview:help.view];
}

-(IBAction)BackToMenuView:(id)sender{
	[self.view removeFromSuperview];
}

- (void)highlightButton:(StoneButton *)b {
    [b setSelected:YES];
}

-(IBAction)stoneClicked:(id)sender {
	NSLog(@"User clicked %@",[sender currentTitle]);
    
    UIButton *b = (UIButton *)sender;
    [b setSelected:NO];
	
	// process button input into stack and stone
	NSString *temp=[sender currentTitle];
	NSArray *comps=[temp componentsSeparatedByString:@","];
	int stack=[[comps objectAtIndex:0] intValue];
	int stone=[[comps objectAtIndex:1] intValue];
	
	NSLog(@"Parsed to be stack %d and stone %d",stack,stone);
	
	// if a stack is selected
	if(selected_stack!=-1) {
		// if in same stack
		if(selected_stack==stack) {
			// if selected
			if([selected containsObject:sender]){
				//deselect button
				[sender setHighlighted:NO];
				//remove from selected
				[selected removeObject:sender];
				//if empty unset selected row
				if([selected count]==0){
					selected_stack=-1;
				}
			} else {
				// select button
				[self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
				// add to selected list
				[selected addObject:sender];
			}
		} else {
			// message same stack rule
            NSString *title = @"Same Stack Rule";
            NSString *message = @"You must select stones in the same stack.";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
		}
	} else {
		// select button
		[self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
		// add to selected list
		[selected addObject:sender];
		// set selected row
		selected_stack=stack;
	}
}

-(void)Rise_Up:(int)stone {
	NSLog(@"swapping stone %d and %d",stone+1,stone+2);
	
	//swap button positions
	StoneButton *button1=[[worldstate objectAtIndex:selected_stack] objectAtIndex:stone];
	StoneButton *button2=[[worldstate objectAtIndex:selected_stack] objectAtIndex:stone+1];
	CGPoint tempcenter=button1.center;
	button1.center=button2.center;
	button2.center=tempcenter;
	[button1 setHighlighted:NO];
	[button2 setHighlighted:YES];

	//animate swap back
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(Rise_Up_Repeat:finished:context:)];
	button2.center=button1.center;
	button1.center=tempcenter;
    [UIView commitAnimations];
	 
	 //change selected to one higher
	 [selected removeObject:button1];
	 [selected addObject:button2];
}

-(void)Rise_Up_Repeat:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
	int called=0;
	// check if to continue rise up cycle...
	int unsel=0;
	// find any necessary rise
	for(int i=(int)[[worldstate objectAtIndex:selected_stack] count]-1; i>=0; i--){
		NSLog(@"looking at stone %d",i);
		if([selected containsObject:[[worldstate objectAtIndex:selected_stack] objectAtIndex:i]]){
			if(unsel>0){
				NSLog(@"found first, call rise then break");
				[self Rise_Up:i];
				called=1;
				break;
			}
		} else {
			unsel++;
		}
	}
	if(!called){
		[self remove_pieces];
	}
}

-(void)remove_pieces{
	NSLog(@"animate removal of pieces");
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// Get preset number of players
	NSInteger num_players = [defaults integerForKey:@"num_players"];
	
	// remove selections from stack (animated)
	
	//for each selected button
	for(int i=0; i<[selected count]; i++){
		StoneButton *abutton=[selected objectAtIndex:i];
		//animate swap back
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		abutton.alpha=0.0;
        [UIView commitAnimations];
        
		//remove from worldstate
		[[worldstate objectAtIndex:selected_stack] removeObject:abutton];
	}
	
	// reset row selection
	selected_stack=-1;
	
	// reset selection
	[selected removeAllObjects];
	
	//check win condition
	int all=1;
	for(int i=0; i<[worldstate count]; i++){
		if([[worldstate objectAtIndex:i] count]>0){
			all=0;
		}
	}
	
	if(all){ //someone won
		//if two player
		if(num_players==2){
			if([player.text isEqualToString:@"Player 1's Turn"]){
				player.text=@"Player 2 Won!";
			} else {
				player.text=@"Player 1 Won!";
			}
			return;
		} else {
			if([player.text isEqualToString:@"Player 1's Turn"]){
				player.text=@"Computer Won!";
			} else {
				player.text=@"Player 1 Won!";
			}
			return;
		}
	}
	
	//update player label
	if(num_players==2){
		if([player.text isEqualToString:@"Player 1's Turn"]){
			player.text=@"Player 2's Turn";
		} else {
			player.text=@"Player 1's Turn";
		}
	} else {
		player.text=@"Computer's Turn!";
		[self performSelector:@selector(run_ai) withObject:nil afterDelay:1.0f];
	}
}

-(IBAction)removeClicked:(id)sender {
	NSLog(@"Remove Stones Clicked");
	
	//if nothing is selected
	if(selected_stack==-1){
        //message user
        NSString *title = @"Select Stones";
        NSString *message = @"You must select stones to remove.";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
	}
	
	//if too many selected
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger max_rem = [defaults integerForKey:@"max_rem"];
	if([selected count]>max_rem){
        //message user
        NSString *title = @"Too Many Stones";
        NSString *message = [NSString stringWithFormat:@"There is a max removal setting of %ld stones.",(long)max_rem];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
		return;
	}
	
	NSLog(@"worldstate has %lu stacks", (unsigned long)[worldstate count]);
	NSLog(@"worldstate selected stack %d has %lu stones", selected_stack, (unsigned long)[[worldstate objectAtIndex:selected_stack] count]);
	
	// start the rise up cycle...
	int unsel=0;
	int called=0;
	// find first necessary rise
	for(int i=(int)[[worldstate objectAtIndex:selected_stack] count]-1; i>=0; i--){
		NSLog(@"looking at stone %d",i);
		if([selected containsObject:[[worldstate objectAtIndex:selected_stack] objectAtIndex:i]]){
			if(unsel>0){
				NSLog(@"found first, call rise then break");
				[self Rise_Up:i];
				called=1;
				break;
			}
		} else {
			unsel++;
		}

	}
	
	if(!called){
		[self remove_pieces];
	}
}

-(void)run_ai{
	NSLog(@"running computer ai");
	
	//calc move (ai goes here)
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	// Get preset number of stacks
	NSInteger num_stacks = [defaults integerForKey:@"num_stacks"];
	NSInteger max_rem = [defaults integerForKey:@"max_rem"];
	NSInteger ai_diff = [defaults integerForKey:@"ai_diff"];
	
	//make a random move
	selected_stack=arc4random()%num_stacks;
	//while stack count is not greater than zero change stack
	while([[worldstate objectAtIndex:selected_stack] count]==0){
		selected_stack+=1;
		if(selected_stack>=[worldstate count]){
			selected_stack=0;
		}
	}
	//pick random non zero number of stones from stack
	int num_stones=arc4random()%[[worldstate objectAtIndex:selected_stack] count]+1;
	num_stones%=max_rem+1;
	if(num_stones==0){
		num_stones=1;
	}	
	
	//or dont
	//calculate total stones
	int total_stones=0;
	for(int i=0; i<num_stacks; i++){
		total_stones+=[[worldstate objectAtIndex:i] count];
	}
	
	
	// make a better move if theres a certain number of stones left(difficulty factors in here)
	if(total_stones<ai_diff*2){
		//xor all heaps
		int xor_val=(int)[[worldstate objectAtIndex:0] count];
		for(int i=1; i<num_stacks; i++){
			xor_val=xor_val^((int)[[worldstate objectAtIndex:i] count]);
		}
		NSLog(@"xorval=%d",xor_val);
		
		if(xor_val==0){//take one from any heap
			NSLog(@"should never reach here on high diff....");
			num_stones=1;
		} else {
			NSLog(@"should always reach here...");
			//calc how many to take to make xor 0
			for(int i=0; i<num_stacks; i++){
				int stack_count=(int)[[worldstate objectAtIndex:i] count];
				NSLog(@"Looking at stack %d with s=%d, x=%d, s^x=%d",i,stack_count,xor_val,stack_count^xor_val);
				if((stack_count^xor_val)<stack_count){
					NSLog(@"Found stack %d",i);
					selected_stack=i;
					num_stones=stack_count-(stack_count^xor_val);
					int two_ormore_count=0;
					for(int j=0; j<num_stacks; j++){
						int heapcount=(int)[[worldstate objectAtIndex:j] count];
						if(j==selected_stack){
							heapcount-=num_stones;
						}
						if(heapcount>1){
							two_ormore_count++;
						}
					}
					if(two_ormore_count==0){
						NSLog(@"No stacks with two or more");
						int stacksofone=0;
						for(int j=0; j<num_stacks; j++){
							int heapcount=(int)[[worldstate objectAtIndex:j] count];
							if(j==selected_stack){
								heapcount-=num_stones;
							}
							if(heapcount==1){
								stacksofone++;
							}
						}
						if(stacksofone%2==0){
							NSLog(@"Even stacks with one");
							num_stones=(int)[[worldstate objectAtIndex:selected_stack] count];
						} else {
							num_stones=(int)[[worldstate objectAtIndex:selected_stack] count]-1;
						}

					}
					break;
				}
			}
		}
	}
		
	
	//check that there is at least one left after if possible (for random moves)
	if(num_stones>1){
		if(total_stones-num_stones==0){
			num_stones--;
		}
	}
	
	//animate selection & removal
	for(int i=0; i<num_stones; i++){
		[selected addObject:[[worldstate objectAtIndex:selected_stack] objectAtIndex:([[worldstate objectAtIndex:selected_stack] count]-1-i)]];
	}
	for(int i=0; i<[selected count]; i++){
		StoneButton *abutton=[selected objectAtIndex:i];
		abutton.highlighted=YES;
		//animate swap back
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		[UIView setAnimationDelay:0.5f];
		abutton.alpha=0.0;
        [UIView commitAnimations];
		
		//remove from worldstate
		[[worldstate objectAtIndex:selected_stack] removeObject:abutton];
	}
	
	[self performSelector:@selector(comp_cleanup) withObject:nil afterDelay:1.0f];
}

-(void) comp_cleanup {
	
	// reset row selection
	selected_stack=-1;
	
	// reset selection
	[selected removeAllObjects];
	
	
	//check win condition
	int all=1;
	for(int i=0; i<[worldstate count]; i++){
		if([[worldstate objectAtIndex:i] count]>0){
			all=0;
		}
	}
	
	//if won update
	if(all){
		if([player.text isEqualToString:@"Player 1's Turn"]){
			player.text=@"Computer Won!";
		} else {
			player.text=@"Player 1 Won!";
		}
		return;
	}
	
	//update label
	player.text=@"Player 1's Turn";
}

- (void)viewDidLoad {
	
	//setup selected array
	selected = [[NSMutableArray alloc] init];
	selected_stack = -1;
	
	// Get user object for any preset values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// Get preset number of stacks
	NSInteger num_stacks = [defaults integerForKey:@"num_stacks"];
	
	// Calculate x_spacing relative to number of stacks
	int x_spacing = 160/num_stacks;
	
	// y_spacing is calculated relative to the max possible number of stones
	int y_spacing = 225/5+25;
	worldstate=[[NSMutableArray alloc] init];
	// For each stack
	for(int i=0; i<num_stacks; i++){
		NSMutableArray *astack=[[NSMutableArray alloc] init];
		// Get any preset number of stones for this stack
		NSInteger num_stones = [defaults integerForKey:[NSString stringWithFormat:@"num_stones_stack_%d",i+1]];
		
		// Make and add a new UIButton for each stone
		for(int j=0; j<num_stones; j++){
			StoneButton *myButton = [StoneButton buttonWithType:UIButtonTypeRoundedRect];
			//build up from the bottom
			myButton.frame=CGRectMake(x_spacing+i*x_spacing+25*i,340-j*y_spacing,50,50);
			[myButton addTarget:self action:@selector(stoneClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [myButton setBackgroundColor:[UIColor whiteColor]];
            [myButton setTintColor:[UIColor clearColor]];
            myButton.layer.cornerRadius = 10;
            
			[myButton setTitle:[NSString stringWithFormat:@"%d,%d", i, j] forState:UIControlStateNormal];
			[myButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
			[myButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
			[myButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
			[self.view addSubview:myButton];
			[astack addObject:myButton];
		}
		[worldstate addObject:astack];
	}
	
    [super viewDidLoad];
}

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
	[player release];
    [super dealloc];
}

@end
