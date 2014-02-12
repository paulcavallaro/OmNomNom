//
//  ONNMenuUtils.h
//  OmNomNom
//
//  Created by Elliot Lynde on 2/12/14.
//
//

#import <Foundation/Foundation.h>

@interface ONNMenuUtils : NSObject

+(void) getMenu:(void ( ^ )(NSString *) ) completionHandler;
+(void) downloadMenu:(void ( ^ )(NSString *) ) completionHandler;
+(void) deleteMenu;
@end
