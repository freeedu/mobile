//
//  ABTypeDefine.h
//  AddressBook2
//
//  Created by Mason Mei on 3/13/14.
//  Copyright (c) 2014 Mason Mei. All rights reserved.
//

#ifndef AddressBook2_ABTypeDefine_h
#define AddressBook2_ABTypeDefine_h

/**
 *  Used to define the mode of ABContactPickerViewController.
 *
 *  Full Function:  all the function can be using.
 *
 *  Read Only   :   all the view funtion can be using but update or change.
 *
 *  Picker Only :   only the ABContactPickerViewController and the
 *                  ABGroupPickerView Controller can be used for pick
 *                  contacts.
 */
typedef uint32_t ABContactInvokeMode;
enum ABContactInvokeMode {
    abInvokeModeFullFunction = 0x00,
    abInvokeModeReadOnly = 0x01,
    abInvokeModePickerOnly = 0x10
};


#endif
