//
//  ContactHelper.m
//  XYTools
//
//  Created by Panda on 16/3/16.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import "ContactHelper.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactHelper () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) ABPeoplePickerNavigationController *pickerController;
@property (nonatomic, weak) UIViewController *targetController;
@property (nonatomic, copy) void (^callBackBlock)(NSDictionary *callBackBlock);

@end

@implementation ContactHelper

- (void)showInController:(UIViewController *)vc completion:(void(^)(NSDictionary *))block{

    _callBackBlock = block;
    _pickerController = [ABPeoplePickerNavigationController new];
    _pickerController.peoplePickerDelegate = self;
    [vc presentViewController:_pickerController animated:YES completion:NULL];
}

#pragma mark -  ABPeoplePickerNavigationControllerDelegate

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

// Called after a person has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person {
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSDictionary *dic = @{@"fullname": [NSString stringWithFormat:@"%@%@", firstName, lastName],
                          @"phone" : phones.count > 0 ? [phones firstObject] : @""};
    
    _callBackBlock(dic);
    [_targetController dismissViewControllerAnimated:YES completion:nil];
}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {

    _callBackBlock(nil);
    [_targetController dismissViewControllerAnimated:YES completion:nil];
}

#else

// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    _completionBlock(nil);
    [_targetController dismissViewControllerAnimated:YES completion:nil];
}


// Deprecated, use predicateForSelectionOfPerson and/or -peoplePickerNavigationController:didSelectPerson: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSDictionary *dic = @{@"firstName": firstName,@"lastName":lastName,@"phones":phones};
    
    _callBackBlock(nil);
    [_targetController dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

// Deprecated, use predicateForSelectionOfProperty and/or -peoplePickerNavigationController:didSelectPerson:property:identifier: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
    _callBackBlock(nil);
    [_targetController dismissViewControllerAnimated:YES completion:nil];
    return NO;
}
#endif

#pragma mark - ABPersonViewControllerDelegate
// Called when the user selects an individual value in the Person view, identifier will be kABMultiValueInvalidIdentifier if a single value property was selected.
// Return NO if you do not want anything to be done or if you are handling the actions yourself.
// Return YES if you want the ABPersonViewController to perform its default action.
- (BOOL)personViewController:(ABPersonViewController *)personViewController
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property
                  identifier:(ABMultiValueIdentifier)identifier {
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSDictionary *dic = @{@"firstName": firstName,@"lastName":lastName,@"phones":phones};
    
    _callBackBlock(dic);
    [_targetController dismissViewControllerAnimated:YES completion:nil];
    return NO;  
}  

@end
