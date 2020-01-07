//
//  WidgetAppearance.swift
//  BlockInputSample
//
//  Created by Apple on 1/7/20.
//  Copyright © 2020 Ali Murad. All rights reserved.
//

import UIKit

struct WidgetAppearance {
    var isMandatory: Bool = true
    var minNumberOfSections: Int = 4
    var sectionWidth = 4
    var minLength: Int = 16
    var maxLength: Int = 16
    var isSecureTextEntry: Bool = false
    var regex: String  = ".*"

    // Input Fields
    var textColor: UIColor = .black
    var FontSize = CGFloat(24)
    var FontName = "OCRAExtended"
    var hintColor = UIColor.lightGray
    var hintText = "0000"


    // Error Message
    var errorFontName   = "OCRAExtended"
    var errorFontSize  = CGFloat(14.0)
    var errorTextColor: UIColor = .red
    var errorMessage: String = "Please enter valid card number"
    var emptyMessage: String = "Please enter card number"
    
    // Bottom Lines
    var bottomLineFocusOutColor = UIColor.lightGray
    var bottomLineFocusedColor = UIColor.darkGray
    var bottomLineErrorColor = UIColor.red
    
    // Other Properties
    var blockSpacing = CGFloat(5.0)
    var cursorColor = UIColor.lightGray
    var keyboardType: UIKeyboardType = .numberPad
}
