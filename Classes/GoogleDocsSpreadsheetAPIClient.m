//
//  JPGoogleDocsSpreadsheetAPIClient.m
//  amp
//
//  Created by Joseph Pintozzi on 2/12/14.
//  Copyright (c) 2014 branberg. All rights reserved.
//

#import "GoogleDocsSpreadsheetAPIClient.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface GoogleDocsSpreadsheetAPIClient() {
    NSString *_baseURLString;
}

@end

@implementation GoogleDocsSpreadsheetAPIClient

+ (GoogleDocsSpreadsheetAPIClient*)sharedClient{
    static GoogleDocsSpreadsheetAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURLString:@"https://spreadsheets.google.com/"];
    });
    return _sharedClient;
}

- (id)initWithBaseURLString:(NSString *)urlString{
    
    self = [super init];
    if (!self) {
        return nil;
    }

    _baseURLString = urlString;
    
    return self;
}

- (void)GET:(NSString *)path
    completion:(GoogleDocsAPICompletionBlock)completionBlock {
    
    NSString *string = [NSString stringWithFormat:@"%@%@", _baseURLString, path];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:_baseURLString]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:string
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(YES, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, nil, error);
    }];
    
    [operation start];
}

//sample URL https://spreadsheets.google.com/feeds/cells/0Atoge9gLkMCTdENkUkVENElFczlmTDl1ODZWaTJmeFE/1/public/basic?alt=json

- (void)cellsForSpreadsheetKey:(NSString*)key sheetId:(NSString*)gid withCompletionBlock:(GoogleDocsAPICompletionBlock)completionBlock{
    
    [self GET:[NSString stringWithFormat:@"feeds/cells/%@/%@/public/basic?alt=json", key, gid] completion:completionBlock];
}

- (void)sheetsForSpreadsheetKey:(NSString*)key withCompletionBlock:(GoogleDocsAPICompletionBlock)completionBlock{
    
    [self GET:[NSString stringWithFormat:@"feeds/worksheets/%@/public/basic?alt=json", key] completion:completionBlock];
}

@end
