//
//  UIWebView+TS_JavaScriptContext.m
//
//  Created by Nicholas Hodapp on 11/15/13.
//  Copyright (c) 2013 CoDeveloper, LLC. All rights reserved.
//

#import "UIWebView+TS_JavaScriptContext.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>


@implementation NSObject (TS_JavaScriptContext)
- (void)webView:(id)unused didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)alsoUnused {
    if (!ctx)
        return;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LLCreatJSContex" object:ctx];
}


@end


