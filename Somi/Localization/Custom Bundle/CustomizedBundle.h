//
//  CustomizedBundle.h
//  TaxiApp
//
//  Created by MacOSX on 29/12/16.
//  Copyright © 2016 Mindiii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomizedBundle : NSBundle
-(NSString*)localizedStringForKey:(NSString *)key
                            value:(NSString *)value
                            table:(NSString *)tableName;
- (void)setLanguage:(NSString*)language ;
@end



