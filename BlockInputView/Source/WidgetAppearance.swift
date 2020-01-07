//
//  WidgetAppearance.swift
//  BlockInputSample
//
//  Created by Apple on 1/7/20.
//  Copyright © 2020 Ali Murad. All rights reserved.
//

import UIKit

public struct WidgetAppearance {
    public init() {
        
    }
    public var isMandatory: Bool = true
    public var minNumberOfSections: Int = 4
    public var sectionWidth = 4
    public var minLength: Int = 16
    public var maxLength: Int = 16
    public var isSecureTextEntry: Bool = false
    public var regex: String  = ".*"

    // Input Fields
    public var textColor: UIColor = .black
    public var FontSize = CGFloat(24)
    public var FontName = "OCRAExtended"
    public var hintColor = UIColor.lightGray
    public var hintText = "0000"


    // Error Message
    public var errorFontName   = "OCRAExtended"
    public var errorFontSize  = CGFloat(14.0)
    public var errorTextColor: UIColor = .red
    public var errorMessage: String = "Please enter valid card number"
    public var emptyMessage: String = "Please enter card number"
    
    // Bottom Lines
    public var bottomLineFocusOutColor = UIColor.lightGray
    public var bottomLineFocusedColor = UIColor.darkGray
    public var bottomLineErrorColor = UIColor.red
    
    // Other Properties
    public var blockSpacing = CGFloat(5.0)
    public var cursorColor = UIColor.lightGray
    public var keyboardType: UIKeyboardType = .numberPad
}
