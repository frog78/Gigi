//
//  UIViewController+Gigi.m
//  Gigi
//
//  Created by qiliu on 2017/7/26.
//  Copyright © 2017年 qiliu. All rights reserved.
//

#import "UIViewController+Gigi.h"

@interface UIViewController ()

@property (nonatomic) BOOL isFileInputIntercept;

@end

@implementation UIViewController (Gigi)


- (void)gigi_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    //如果present的viewcontroller是UIDocumentMenuViewController
    //类型，且代理是WKFileUploadPanel或UIWebFileUploadPanel
    //进行拦截
    if ([viewControllerToPresent isKindOfClass:[UIDocumentMenuViewController class]]) {
        UIDocumentMenuViewController *dvc = (UIDocumentMenuViewController*)viewControllerToPresent;
        if ([dvc.delegate isKindOfClass:NSClassFromString(@"WKFileUploadPanel")] || [dvc.delegate isKindOfClass:NSClassFromString(@"UIWebFileUploadPanel")]) {
            
            self.isFileInputIntercept = YES;
            [dvc.delegate documentMenuWasCancelled:dvc];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onFileInputIntercept];
            });
            
            return;
        }
    }
    //正常情况下的present
    [self gigi_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)gigi_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    
    //如果进行了拦截，禁止当前viewcontroller的dismiss
    if (self.isFileInputIntercept) {
        self.isFileInputIntercept = NO;
        completion();
        return;
    }
    
    //正常情况下viewcontroller的dismiss
    [self gigi_dismissViewControllerAnimated:flag completion:^{
        if (completion) {
            completion();
        }
    }];
}


- (void)onFileInputIntercept {
    if ([self respondsToSelector:@selector(onFileInputClicked)]) {
        [self performSelector:@selector(onFileInputClicked)];
    }
}

- (void)onFileInputClicked {
    
}

- (BOOL)isFileInputIntercept {
    return [objc_getAssociatedObject(self, @selector(isFileInputIntercept)) boolValue];
}

- (void)setIsFileInputIntercept:(BOOL)boolValue {
    objc_setAssociatedObject(self, @selector(isFileInputIntercept), @(boolValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(dismissViewControllerAnimated:completion:);
        SEL swizzledSelector = @selector(gigi_dismissViewControllerAnimated:completion:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        originalSelector = @selector(presentViewController:animated:completion:);
        swizzledSelector = @selector(gigi_presentViewController:animated:completion:);
        originalMethod = class_getInstanceMethod(class, originalSelector);
        swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


@end
