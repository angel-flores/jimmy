//
//  Facebook.h
//  Jimmy
//
//  Created by Angel Flores on 2/27/14.
//  Copyright (c) 2014 Menlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@interface Facebook : NSObject

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) NSMutableArray *events;

@end
