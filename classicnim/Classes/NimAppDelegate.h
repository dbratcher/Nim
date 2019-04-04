//
//  NimAppDelegate.h
//  Nim
//
//  Created by Drew on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NimViewController;

@interface NimAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

