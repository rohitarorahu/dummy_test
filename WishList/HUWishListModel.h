//
//  HUWishListModel.h
//  HUM
//
//  Created by ShashiMukul Chakrawarti on 23/02/16.
//  Copyright © 2016 Happily Unmarried Marketing Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HULibraryAPI.h"

@interface HUWishListModel : NSObject

typedef void (^receivedData) (BOOL success, NSHTTPURLResponse *response, NSDictionary *receivedData, NSError *error);

-(void) getWishListData:(NSString *) url withCallBack:(receivedData) receivedDataCallBack;
-(void) postWishListDataForUrl:(NSString *) url withBody:(NSString *) body withCallBack:(receivedData) receivedDataCallBack;

@end
