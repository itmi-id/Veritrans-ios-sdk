//
//  MTCustomerDetails.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/2/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MTCustomerDetails.h"
#import "MTHelper.h"
#import "NSString+MTValidation.h"
#import "MTConstant.h"

@interface MTCustomerDetails ()

@end

@implementation MTCustomerDetails

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.customerIdentifier forKey:@"customerIdentifier"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.shippingAddress forKey:@"shippingAddress"];
    [encoder encodeObject:self.billingAddress forKey:@"billingAddress"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.customerIdentifier = [decoder decodeObjectForKey:@"customerIdentifier"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.shippingAddress = [decoder decodeObjectForKey:@"shippingAddress"];
        self.billingAddress = [decoder decodeObjectForKey:@"billingAddress"];
    }
    return self;
}


- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
                            phone:(NSString *)phone
                  shippingAddress:(MTAddress *)shippingAddress
                   billingAddress:(MTAddress *)billingAddress {
    if (self = [super init]) {
        self.customerIdentifier = [[NSUUID UUID] UUIDString];
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.phone = phone;
        self.shippingAddress = shippingAddress;
        self.billingAddress = billingAddress;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    // Format MUST BE compatible with
    // http://docs.veritrans.co.id/en/api/methods.html#customer_details_attr
    
    return @{@"first_name": [MTHelper nullifyIfNil:self.firstName],
             @"last_name": [MTHelper nullifyIfNil:self.lastName],
             @"email": [MTHelper nullifyIfNil:self.email],
             @"phone": [MTHelper nullifyIfNil:self.phone],
             @"shipping_address": [self.shippingAddress dictionaryValue],
             @"billing_address": [self.billingAddress dictionaryValue]};
}

- (NSDictionary *)snapDictionaryValue {
    return @{@"payment_detail":@{@"full_name":[NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName],
                                 @"phone":[MTHelper nullifyIfNil:self.phone],
                                 @"email":[MTHelper nullifyIfNil:self.email]}};
}

- (BOOL)isValidCustomerData:(NSError **)error {
    if (self.email.isEmpty ||
        !self.email.isValidEmail ||
        self.phone.isEmpty ||
        !self.phone.isValidPhoneNumber)
    {
        *error = [NSError errorWithDomain:MT_ERROR_DOMAIN code:MT_ERROR_CODE_INVALID_CUSTOMER_DETAILS userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Invalid or missing customer credentials", nil)}];
        return NO;
    }
    else {
        return YES;
    }
}

@end
