//
//  VTPaymentGeneralViewController.m
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentGeneralViewController.h"
#import "VTPaymentGeneralView.h"
#import "VTClassHelper.h"
#import "UIViewController+HeaderSubtitle.h"
#import "VTStringHelper.h"
#import <MidtransCoreKit/MidtransCoreKit.h>
@interface VTPaymentGeneralViewController ()
@property (strong, nonatomic) IBOutlet VTPaymentGeneralView *view;

@end

@implementation VTPaymentGeneralViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setHeaderWithTitle:self.paymentMethod.title subTitle:@"Payment Instructions"];
    self.view.guideTextView.attributedText = [VTStringHelper numberingTextWithLocalizedStringPath:self.paymentMethod.internalBaseClassIdentifier objectAtIndex:0];
    self.view.totalAmountLabel.text = self.token.transactionDetails.grossAmount.formattedCurrencyNumber;
    self.view.orderIdLabel.text = self.token.transactionDetails.orderId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmPaymentPressed:(UIButton *)sender {
    [self showLoadingHud];
    
    if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_BCA_KLIKPAY_IDENTIFIER]) {
        VTPaymentBCAKlikpay *paymentDetails = [[VTPaymentBCAKlikpay alloc] initWithDescription:@"klikpay bca description"];
        VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails
                                                                             token:self.token];
        [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
            [self hideLoadingHud];
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
        
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_ECASH_IDENTIFIER]) {
        VTPaymentMandiriECash *paymentDetails = [[VTPaymentMandiriECash alloc] initWithDescription:@"mandiri ecash description"];
        VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails
                                                                             token:self.token];
        
        [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
            [self hideLoadingHud];
            
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_EPAY_IDENTIFIER]) {
        VTPaymentEpayBRI *paymentDetails = [[VTPaymentEpayBRI alloc] init];
        VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails
                                                                             token:self.token];
        
        [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
            [self hideLoadingHud];
            
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
        
    }
    else if ([self.paymentMethod.internalBaseClassIdentifier isEqualToString:VT_CIMB_CLIKS_IDENTIFIER]) {
        VTPaymentCIMBClicks *paymentDetails = [[VTPaymentCIMBClicks alloc] initWithDescription:@"dummy_description"];
        VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails
                                                                             token:self.token];
        
        [[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
            [self hideLoadingHud];
            
            if (error) {
                [self handleTransactionError:error];
            } else {
                [self handleTransactionSuccess:result];
            }
        }];
    }
}

@end
