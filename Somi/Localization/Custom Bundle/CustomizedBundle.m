//
//  CustomizedBundle.m
//  TaxiApp
//
//  Created by MacOSX on 29/12/16.
//  Copyright © 2016 Mindiii. All rights reserved.
//

#import "CustomizedBundle.h"
#import <objc/runtime.h>

@implementation CustomizedBundle
static const char kAssociatedLanguageBundle = 0;

-(NSString*)localizedStringForKey:(NSString *)key
                            value:(NSString *)value
                            table:(NSString *)tableName {
    
    NSBundle* bundle = objc_getAssociatedObject(self, &kAssociatedLanguageBundle);
    
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] :
    [super localizedStringForKey:key value:value table:tableName];
}

- (void)setLanguage:(NSString*)language {
    object_setClass([NSBundle mainBundle], [CustomizedBundle class]);
    objc_setAssociatedObject([NSBundle mainBundle], &kAssociatedLanguageBundle, language ?
                             [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSLog(@"%@",[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]]);
}
@end
