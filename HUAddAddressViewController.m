//
//  HUAddAddressViewController.m
//  HUM
//
//  Created by Rohit Arora on 26/02/16.
//  Copyright © 2016 Happily Unmarried Marketing Private Limited. All rights reserved.
//

#import "HUAddAddressViewController.h"
#import "UIButton+BackgroundColorWithState.h"
#import "MobiKwikSDK.h"
@interface HUAddAddressViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultAddressButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepsPopupViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *stepsPopupView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountDetailsViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *stepIndicatorLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerViewButton;
@property (weak, nonatomic) IBOutlet UILabel *itemsAndPaymentDetailsLabel;
@property (weak, nonatomic) IBOutlet UIView *greyLineView;
@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation HUAddAddressViewController {
    NSMutableArray* myAddressListArray;
}
@synthesize comingInThisScreenFor, dataDictionary,canEditMarkAsDefaultOption,comingInThisScreenFromFlowType;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (comingInThisScreenFromFlowType==2 || comingInThisScreenFromFlowType == 3) {
        self.amountDetailsViewTopConstraint.constant = -self.itemsAndPaymentDetailsLabel.superview.frame.size.height;
        [self.itemsAndPaymentDetailsLabel.superview layoutIfNeeded];
        self.stepIndicatorLabel.hidden = true;
        if (comingInThisScreenFor==1) {
            [self.headerViewButton setTitle:@"ADD ADDRESS" forState:UIControlStateNormal];
        } else {
            [self.headerViewButton setTitle:@"EDIT ADDRESS" forState:UIControlStateNormal];
        }
        [self.headerViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.headerViewButton.enabled = false;
        self.greyLineView.hidden = false;
        self.statusBarView.backgroundColor = [HUUtility appRGBColor:248.0 :248.0 :248.0];
        self.backButton.superview.backgroundColor = [HUUtility appRGBColor:248.0 :248.0 :248.0];
        [self.backButton setTintColor:[HUUtility appRGBColor:54.0 :61.0 :69.0]];
    }
    [self.view layoutIfNeeded];
    
    NSArray* placeHolderArray = [NSArray arrayWithObjects:@"Pincode",@"City",@"State",@"First name",@"Last name",@"Delivery address",@"Mobile Number",nil];
    
    for (int i = 1; i<8; i++) {
        CALayer *border = [CALayer layer];
        border.borderColor = [[HUUtility appRGBColor:224.0 :224.0 :224.0] CGColor];
        UITextField *textField = (UITextField *)[self.mainContentView viewWithTag:i];
        border.frame = CGRectMake(0, textField.frame.size.height - 1, textField.frame.size.width, textField.frame.size.height);
        border.borderWidth = 1;
        [textField.layer addSublayer:border];
        textField.layer.masksToBounds = YES;
        
        UILabel* placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, textField.frame.size.height)];
        placeHolderLabel.textColor = [UIColor redColor];
        [placeHolderLabel setTextAlignment:NSTextAlignmentRight];
        placeHolderLabel.font = [UIFont fontWithName:@"Arial" size:12];
        placeHolderLabel.text = [placeHolderArray objectAtIndex:i-1];
        textField.rightView = placeHolderLabel;
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    
    [[self.setDefaultAddressButton layer] setMasksToBounds:YES];
    [[self.setDefaultAddressButton layer] setBorderColor:[[HUUtility appRGBColor:204.0 :204.0 :204.0] CGColor]];
    [[self.setDefaultAddressButton layer] setBorderWidth:1.0f];
    [self.setDefaultAddressButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.setDefaultAddressButton setBackgroundColor:[HUUtility appRGBColor:39.0 :48.0 :53.0] forState:UIControlStateSelected];
    if (comingInThisScreenFor==2) {
        NSLog(@"%@",dataDictionary);
        UITextField* pinCodeTextField = (UITextField *)[self.mainContentView viewWithTag:1];
        pinCodeTextField.text=[dataDictionary valueForKey:@"pin_code"];
        UITextField* cityTextField = (UITextField *)[self.mainContentView viewWithTag:2];
        cityTextField.text=[dataDictionary valueForKey:@"city"];
        
        UITextField* stateTextField = (UITextField *)[self.mainContentView viewWithTag:3];
        stateTextField.text=[dataDictionary valueForKey:@"state"];
        
        UITextField* firstNameTextField = (UITextField *)[self.mainContentView viewWithTag:4];
        firstNameTextField.text=[dataDictionary valueForKey:@"firstname"];
        
        UITextField* lastNameTextField = (UITextField *)[self.mainContentView viewWithTag:5];
        lastNameTextField.text=[dataDictionary valueForKey:@"lastname"];
        
        UITextField* addressTextField = (UITextField *)[self.mainContentView viewWithTag:6];
        addressTextField.text=[dataDictionary valueForKey:@"street"];
        
        UITextField* mobileTextField = (UITextField *)[self.mainContentView viewWithTag:7];
        mobileTextField.text=[dataDictionary valueForKey:@"contact_no"];
        
        self.setDefaultAddressButton.selected = [[dataDictionary valueForKey:@"isdefault"] integerValue];
        self.setDefaultAddressButton.userInteractionEnabled = canEditMarkAsDefaultOption;
    }
    // Do any additional setup after loading the view.
}

- (IBAction)goToStepButtonPressed:(UIButton *)sender {
    [self showOrHideStepsPopUp:false];
}

- (IBAction)setAsDefaultButtonPressed:(UIButton *)sender {
    self.setDefaultAddressButton.selected = ![self.setDefaultAddressButton isSelected];
}

- (IBAction)saveAddressButtonPressed:(UIButton *)sender {
    [self hideKeyboard];
    if ([[(UITextField *)[self.mainContentView viewWithTag:1] text] length]==0){
        [HUUtility showAlertView:@"Error" message:@"Please enter pincode."];
    }
    else if ([[(UITextField *)[self.mainContentView viewWithTag:2] text] length]==0){
        [HUUtility showAlertView:@"Error" message:@"Please enter city."];
    }
    else if ([[(UITextField *)[self.mainContentView viewWithTag:3] text] length]==0){
        [HUUtility showAlertView:@"Error" message:@"Please enter state."];
    }
    else if ([[(UITextField *)[self.mainContentView viewWithTag:4] text] length]==0){
        [HUUtility showAlertView:@"Error" message:@"Please enter first name."];
    }
    else if ([[(UITextField *)[self.mainContentView viewWithTag:5] text] length]==0){
        [HUUtility showAlertView:@"Error" message:@"Please enter last name."];
    }
    else if ([[(UITextField *)[self.mainContentView viewWithTag:6] text] length]==0){
        [HUUtility showAlertView:@"Error" message:@"Please enter delivery address."];
    }
    else if ([[(UITextField *)[self.mainContentView viewWithTag:7] text] length]==0){
        [HUUtility showAlertView:@"Error" message:@"Please enter your mobile number."];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUUtility showLoadingIndicator:@"Saving Address..."];
        });
        
        if ([HUUtility checkInternetConnection]) {
            NSString *mainUrl, *parametersString;
            if (comingInThisScreenFor==2) {
                mainUrl= [NSString stringWithFormat:@"%@huapi/index/updateaddress?secretkey=XmgobA7HyvrBLhjI74o5pqec2fDFSf4TWzmIhSYnkNU",HUBaseUrl];
                parametersString = [NSString stringWithFormat:@"addressId=%@&contactno=%@&firstname=%@&lastname=%@&regionId=%@&street=%@&city=%@&pincode=%@&isDefault=%@",[dataDictionary valueForKey:@"address_id"], [(UITextField *)[self.mainContentView viewWithTag:7] text], [(UITextField *)[self.mainContentView viewWithTag:4] text],[(UITextField *)[self.mainContentView viewWithTag:5] text],@"512",[(UITextField *)[self.mainContentView viewWithTag:6] text],[(UITextField *)[self.mainContentView viewWithTag:2] text],[(UITextField *)[self.mainContentView viewWithTag:1] text],[NSString stringWithFormat:@"%d",[self.setDefaultAddressButton isSelected]]];
            }else {
                mainUrl= [NSString stringWithFormat:@"%@huapi/index/createaddress?secretkey=XmgobA7HyvrBLhjI74o5pqec2fDFSf4TWzmIhSYnkNU",HUBaseUrl];
                parametersString = [NSString stringWithFormat:@"customerId=%@&contactno=%@&firstname=%@&lastname=%@&regionId=%@&street=%@&city=%@&pincode=%@&isDefault=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"], [(UITextField *)[self.mainContentView viewWithTag:7] text], [(UITextField *)[self.mainContentView viewWithTag:4] text],[(UITextField *)[self.mainContentView viewWithTag:5] text],@"512",[(UITextField *)[self.mainContentView viewWithTag:6] text],[(UITextField *)[self.mainContentView viewWithTag:2] text],[(UITextField *)[self.mainContentView viewWithTag:1] text],[NSString stringWithFormat:@"%d",[self.setDefaultAddressButton isSelected]]];
            }
            HUUrlSessionAPI* serverCallMethodObject = [[HUUrlSessionAPI alloc]init];
            [serverCallMethodObject requestServerCall:parametersString urlString:mainUrl headerParameters:nil requestMethod:@"POST" withCallback:^(BOOL success, NSData *response, NSError *error, long statusCode) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUUtility hideLoadingIndicator];
                });
                if (success) {
                    NSMutableDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
                    if ([[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"status"]]isEqualToString:@"200"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (comingInThisScreenFor==2) {
                                [HUUtility showAlertView:@"Success" message:[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"message"]]];
                                [self.navigationController popViewControllerAnimated:true];
                            }else if (comingInThisScreenFor==3) {
                                HUOrderDeliveryDetailViewController *orderDeliveryDetailScreen = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HUOrderDeliveryDetailViewController"];
                                [[UserAddressesArray sharedInstance] addAddressData:myAddressListArray];
                                NSArray *defaultKeyArray = [myAddressListArray valueForKey:@"isdefault"];
                                NSUInteger index = [defaultKeyArray indexOfObject:[NSNumber numberWithInt:1]];
                                [[UserAddressesArray sharedInstance] setSelectedAddressForDelivery:index];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.navigationController pushViewController:orderDeliveryDetailScreen animated:true];
                                });
                                
                            }else {
                                [self.navigationController popViewControllerAnimated:true];
                            }
                        });
                    } else {
                        
                    }
                }
            }];
        }else {
            [HUUtility showAlertView:@"Error" message:HUnoInternetConnectionError];
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showOrHideStepsPopUp:true];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showOrHideStepsPopUp:true];
}

-(void)showOrHideStepsPopUp:(BOOL)onlyHide {
    if (self.stepsPopupViewHeightConstraint.constant == 1) {
        if (!onlyHide) {
            self.stepsPopupViewHeightConstraint.constant = 80;
        }
    }else {
        self.stepsPopupViewHeightConstraint.constant = 1;
    }
    
    [UIView animateKeyframesWithDuration:0.8 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
            if (self.stepsPopupViewHeightConstraint.constant == 80) {
                if (!onlyHide) {
                    self.stepsPopupView.hidden = false;
                }
            }else {
                self.stepsPopupView.hidden = true;
            }
        }];
    } completion:nil];
}

- (IBAction)backToCartScreen:(UIButton *)sender {
    [self hideKeyboard];
    [self.navigationController popToRootViewControllerAnimated:true];
}

-(void)hideKeyboard {
    for (int i = 1; i<8; i++) {
        [(UITextField *)[self.mainContentView viewWithTag:i] resignFirstResponder];
    }
}

// Textfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag != 7) {
        UITextField *selectedTextField = (UITextField *)[self.mainContentView viewWithTag:textField.tag+1];
        [selectedTextField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == (UITextField *)[self.mainContentView viewWithTag:1]) {
        if ([string isEqualToString:@" "] || textField.text.length >= 6) {
            return false;
        }
    }
    return true;
}
- (IBAction)popBackToPreviousScreen:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
