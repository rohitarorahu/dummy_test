//
//  HUAddAddressViewController.h
//  HUM
//
//  Created by User on 26/02/16.
//  Copyright © 2016 Happily Unmarried Marketing Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUUtility.h"
#import "HUGlobalConstants.h"
#import "HUUrlSessionAPI.h"
#import "UserAddressesArray.h"
#import "HUOrderDeliveryDetailViewController.h"
@interface HUAddAddressViewController : UIViewController<UITextFieldDelegate> {
    
}
@property NSInteger comingInThisScreenFor; // 1 to add new address, 2 for edit address
@property NSInteger comingInThisScreenFromFlowType; // 1 from checkout flow, 2 from my account flow
@property NSMutableDictionary* dataDictionary;
@property BOOL canEditMarkAsDefaultOption;
@end
