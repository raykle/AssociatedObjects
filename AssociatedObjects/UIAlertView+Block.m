//
//  UIAlertView+Block.m
//  AssociatedObjects
//
//  Created by guomin on 15/8/10.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

const char oldDelegateKey;
const char completionHandlerKey;

@implementation UIAlertView (Block) 

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,...{
    if (self = [super init])
    {
        self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
        if (otherButtonTitles) {
            NSString *otherTitle;
            va_list list;
            va_start(list, otherButtonTitles);
            while ((otherTitle = va_arg(list, NSString *))) {
                [self addButtonWithTitle:otherTitle];
            }
            va_end(list);
        }
    }
    
    return self;
}

- (void)showWithCompletionHandler:(void (^)(NSInteger))completionHandler{
    if (completionHandler) {
        
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegate);
        if (!oldDelegate) {
            oldDelegate = self.delegate;
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        self.delegate = self;
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    void(^theCompletionHandle)(NSUInteger buttonIndex) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if (!theCompletionHandle) {
        return;
    }
    
    theCompletionHandle(buttonIndex);
    
    id delegate = objc_getAssociatedObject(self, &oldDelegateKey);
    alertView.delegate = delegate;
}

@end
