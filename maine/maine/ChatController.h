//
//  СhatViewController.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/18/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pods/QuickBlox/Quickblox.framework/Headers/QBChatDialog.h"

@interface ChatController : UIViewController

@property (nonatomic, strong) QBChatDialog *dialog;

@end
