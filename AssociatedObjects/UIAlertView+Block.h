//
//  UIAlertView+Block.h
//  AssociatedObjects
//
//  Created by guomin on 15/8/10.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block) <UIAlertViewDelegate>

//UIAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

-(void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

@end
