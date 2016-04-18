//
//  HUWishListModel.m
//  HUM
//
//  Created by ShashiMukul Chakrawarti on 23/02/16.
//  Copyright © 2016 Happily Unmarried Marketing Private Limited. All rights reserved.
//

#import "HUWishListModel.h"

@implementation HUWishListModel

-(void)getWishListData:(NSString *)url withCallBack:(receivedData)receivedDataCallBack
{
    HULibraryAPI *libApi = [HULibraryAPI sharedInstance];
    [libApi getDataFromServerForUrl:url withResponse:^(BOOL success,
                                                       NSHTTPURLResponse *response,
                                                       NSData *receivedData,
                                                       NSError *error)
     {
         NSError* jsonError;
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:receivedData
                                                              options:kNilOptions
                                                                error:&jsonError];
         receivedDataCallBack(success, response, json, error);
     }];
}

-(void)postWishListDataForUrl:(NSString *)url withBody:(NSString *)body withCallBack:(receivedData)receivedDataCallBack
{
    HULibraryAPI *libApi = [HULibraryAPI sharedInstance];
    [libApi postDatatoServerForUrl:url withBody:body withResponse:^(BOOL success,
                                                                    NSHTTPURLResponse *response,
                                                                    NSData *receivedData,
                                                                    NSError *error)
     {
         NSError* jsonError;
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:receivedData
                                                              options:kNilOptions
                                                                error:&jsonError];
         receivedDataCallBack(success, response, json, error);
     }];
}

@end
