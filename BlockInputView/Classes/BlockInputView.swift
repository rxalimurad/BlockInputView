//
//  BlockInputView.swift
//  MCPCredit
//
//  Created by Ali Murad on 30/01/2019.
//  Copyright © 2019 i2c Inc. All rights reserved.
//




enum ChangeStatus {
    case insert
    case remove
    case noChange
}



protocol BlockInputViewDelegate: class {
    func actionForInfoButton(widget: BlockInputView)
}

enum TextAlignment {
    case left
    case right
    case center
}

import UIKit

class BlockInputView : UIView {
    
    //MARK: Outlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var lblError: UILabel!
    @IBOutlet private var stackView : UIStackView!
    @IBOutlet private var lblErrorHeightConstraint : NSLayoutConstraint!
    @IBOutlet private var stackViewHeight: NSLayoutConstraint!
    @IBOutlet private var errorLblTop: NSLayoutConstraint!
  
    
    
    
    //MARK: Class Property
    private var textFields = [UITextField]()
    private var lines = [UIView]()
    private var previousTextCount = 0
    private var totalText = ""
    private var initialHeight:CGFloat = 62
    private let errorLblTopConstant:CGFloat = 15.0
    private var textField =  UITextField()
    private var numberOfSections = 0
    private var spacing : CGFloat = 10
    private var font : UIFont = UIFont.systemFont(ofSize: 25)

    //MARK:- Delegates
    weak var delegate: BlockInputViewDelegate?
    
    
    //MARK: Widget Property
    var widgetAppearance = WidgetAppearance()
   
    //MARK: Computed Properties
    
    var parentTopView: UIView? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController.view
            }
        }
        return nil
    }
    
    
    
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    
    private func nibSetup() {
        self.textField = UITextField()
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(containerView)
        self.lblError.isHidden = true
        let padding =  10
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(padding)),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(-padding)),
            ])
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
   
    
    private func setupView() {
        self.stackView.distribution = .fillEqually
        stackViewHeight.constant = self.font.lineHeight + 10
        self.stackView.spacing = self.spacing
        self.numberOfSections = widgetAppearance.minNumberOfSections
        self.calculateAndUpdateViewHeightBasedOnContents()
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.textFields = []
        self.lines = []
        for i in 1 ... numberOfSections {
            addTextFieldToStackView (stackView: self.stackView , tag: i)
        }



    }
    
    // MARK: Widget Getter
    
     func getFieldText()-> String {
        return self.totalText.removeWhitespace()
    }
    
    // MARK: Calculate View Height
    
    func calculateAndUpdateViewHeightBasedOnContents() {
        var height:CGFloat = 0
        height =   stackViewHeight.constant
        height =   height + errorLblTop.constant
        
        self.initialHeight = height
        self.updateHeight(height: height)
    }
    
    
    
    // MARK: Validation
     func validate() -> Bool {
        // return true
        self.endEditing(true)
        // Check Is Mandatory
        if(widgetAppearance.isMandatory == true) {
            if self.totalText.removeWhitespace().isEmpty {
                self.showError(errorMsg: widgetAppearance.emptyMessage)
                return false
            }
        }
        // Check Minimun Length
        
        if (!self.totalText.removeWhitespace().isEmpty && totalText.removeWhitespace().count < widgetAppearance.minLength) {
            self.showError(errorMsg: widgetAppearance.errorMessage)
            return false
        }
        
        // Check Regex
//
//        if (self.regex != "" && Regex(pattern: self.regex).evaluate(input: totalText) == false) {
//            self.showError(errorMsg: self.errorMsgId)
//            return false
//        }
        return true
    }
    
    //MARK: Overrides
    
    func activate(widgetAppearance: WidgetAppearance = WidgetAppearance()) {
        self.widgetAppearance = widgetAppearance
        // Set error msg property
        lblError.textColor =    widgetAppearance.errorTextColor
        if let errorFont = UIFont(name: widgetAppearance.errorFontName, size: widgetAppearance.errorFontSize) {
            lblError.font = errorFont
        } else {
            lblError.font = UIFont.systemFont(ofSize: widgetAppearance.errorFontSize)
        }
        
        // Set Font
        if let fnt = UIFont(name: widgetAppearance.FontName, size: widgetAppearance.FontSize) {
            font = fnt
        }
        
        // Setting Space between TextFields
                self.spacing = (widgetAppearance.blockSpacing / CGFloat(100) * UIScreen.main.bounds.size.width)
        
        setupView()
    }
    
    func showError(errorMsg:String) {
        
       self.lblError.text = errorMsg
        
        if !errorMsg.isEmpty {  // show Error Label spacing only if error msg is not empty
            
            if let errorLabelHeight =  self.lblError.text?.height(withConstrainedWidth: self.lblError.frame.width, font: self.lblError.font){
                self.lblError.isHidden = false
                self.errorLblTop.constant = errorLblTopConstant
                self.lblErrorHeightConstraint.constant = errorLabelHeight
                let viewHeight = self.initialHeight  + errorLabelHeight
                self.updateHeight(height: viewHeight)
                
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            
            self.lblError.alpha = 1
            self.parentTopView?.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
        }
        
        for line in self.lines {
            line.backgroundColor = widgetAppearance.bottomLineErrorColor
        }
        
    }
    
    
    
    
    
     func hideErrorView() {
        
        if !self.lblError.isHidden {
            
            self.updateHeight(height: self.initialHeight)
            self.lblErrorHeightConstraint.constant = 0
            self.lblError.fadeOut(duration: 0.5, delay: 0.0) { (finished) in
                self.lblError.isHidden = true
                self.lblError.text = ""
                
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.parentTopView?.layoutIfNeeded()
            })
            
            
        }
        
    }
    
    
    
    
    //MARK: TextField Helper Methods
    
    @objc func textDidChange(textField: UITextField) {
        if !self.lblError.isHidden {
            self.hideErrorView()
            
        }
        
        
        let change = self.getChangeStatus()
        self.textField.text = totalText
        if let cursorPosition = self.getCursorPosition(textField: textField) {
            if change == .insert {
                if totalText.count > widgetAppearance.maxLength {
                    var s = textField.text!
                    if let index = s.index(s.startIndex, offsetBy: cursorPosition - 1, limitedBy: s.endIndex) {
                        s.remove(at: index)
                        textField.text = s
                    }
                    _ = self.getChangeStatus()
                    self.setCursorPosition(textFieldTag: textField.tag, cursorPosition: cursorPosition - 1)
                    return
                }
                if cursorPosition > widgetAppearance.sectionWidth {
                    let nextTag = textField.tag + 1
                    var nextResponder = self.stackView.viewWithTag(nextTag)
                    if nextResponder == nil {
                        if widgetAppearance.maxLength >= (self.numberOfSections * widgetAppearance.sectionWidth) {
                            self.numberOfSections = self.numberOfSections + 1
                            updateFonts()
                            addTextFieldToStackView (stackView: self.stackView , tag: nextTag)
                            nextResponder = self.stackView.viewWithTag(nextTag)
                            
                        }
                        
                    }
                    nextResponder?.isUserInteractionEnabled = true
                    nextResponder?.becomeFirstResponder()
                    
                }
                if (textField.text?.count)! > widgetAppearance.sectionWidth {
                    rightShiftText(currentFieldTag: textField.tag, cursorPosition: cursorPosition)
                }
                
            } else if change == .remove {
                if cursorPosition == 0 {
                    let prevTag = textField.tag - 1
                    let prevResponder = self.stackView.viewWithTag(prevTag)
                    prevResponder?.becomeFirstResponder()
                    if (textField.text?.count) == 0 {
                        leftShiftText(currentFieldTag : textField.tag, cursorPosition: cursorPosition)
                        updateLinesColor()
                        return
                    }
                    
                }
                leftShiftText(currentFieldTag : textField.tag, cursorPosition: cursorPosition)
                
            }
        }
        updateLinesColor()
        
    }
    
    
  
    func updateLinesColor() {
        for i in 0 ..< self.lines.count {
            let index = (self.lines.count - 1) - i
            if textFields[index].text == "" {
                self.lines[index].backgroundColor = widgetAppearance.bottomLineFocusOutColor
            }else {
                self.lines[index].backgroundColor = widgetAppearance.bottomLineFocusedColor
            }
        }
        
    }
    
    func leftShiftText(currentFieldTag : Int, cursorPosition: Int) {
        var nextFieldTag = 0
        var currentTag = currentFieldTag - 1
        repeat {
            currentTag = currentTag + 1
            nextFieldTag = currentTag + 1
            
            if nextFieldTag <= self.numberOfSections {
                let currentField = self.stackView.viewWithTag(currentTag) as? UITextField
                let nextField = self.stackView.viewWithTag(nextFieldTag) as? UITextField
                
                if !(nextField?.text?.isEmpty)! {
                    let nextChar = (nextField?.text?.removeFirst())!
                    currentField?.text = (currentField?.text!)! + "\(nextChar)"
                }else {
                    nextField?.isUserInteractionEnabled = false
                    if let _ = nextField {
                        if (nextField?.text?.count)! == 0 {
                            removeExtraTextField(textField: nextField)
                        
                        }
                    }
                    break
                }
                
            }
        } while (nextFieldTag <= self.numberOfSections)
        self.setCursorPosition(textFieldTag: currentFieldTag, cursorPosition: cursorPosition)
        removeAllExtraField()
        
        
    }
    
    func removeAllExtraField() {
        for (index , tf) in textFields.enumerated().reversed() {
            if index >= widgetAppearance.minNumberOfSections && (tf.text ?? "").isEmpty {
                self.numberOfSections = self.numberOfSections - 1
                (stackView.viewWithTag(tf.tag) as? UITextField)?.removeFromSuperview()
                if index  < self.textFields.count {
                    self.textFields.remove(at: index)
                }
                
                if index  < self.lines.count {
                    self.lines.remove(at: index)
                }
                self.updateFonts()
            }
        }
    }
    
    func removeExtraTextField(textField: UITextField?, completion: (() -> Void) = {}) {
        if let tag = textField?.tag {
            if tag > widgetAppearance.minNumberOfSections {
                textField?.removeFromSuperview()
                self.numberOfSections = self.numberOfSections - 1
                
                
                if tag  <= self.textFields.count {
                    self.textFields.remove(at: tag - 1)
                    completion()
                }
                if tag  <= self.lines.count {
                    self.lines.remove(at: tag - 1)
                }
                self.updateFonts()
            }
        }
    }
    
    func rightShiftText (currentFieldTag: Int, cursorPosition: Int) {
        var nextFieldTag = 0
        var currentTag = currentFieldTag - 1
        // get next field for cursor setting
        let fieldWithCursor = currentFieldTag + 1
        
        repeat {
            currentTag = currentTag + 1
            nextFieldTag = currentTag + 1
            let currentField = self.stackView.viewWithTag(currentTag) as? UITextField
            var nextField = self.stackView.viewWithTag(nextFieldTag) as? UITextField
            
            if nextField == nil {
                if widgetAppearance.maxLength >= (self.numberOfSections * widgetAppearance.sectionWidth) {
                    self.numberOfSections = self.numberOfSections + 1
                    updateFonts()
                    addTextFieldToStackView (stackView: self.stackView , tag: nextFieldTag)
                    nextField = self.textFields[nextFieldTag - 1]
                    
                }
                
            }
            
            let lastChar = (currentField?.text?.removeLast())!
            nextField?.text = "\(lastChar)" + (nextField?.text!)!
            nextField?.isUserInteractionEnabled = true
            if ((nextField?.text?.count)! <= widgetAppearance.sectionWidth) || nextFieldTag > numberOfSections {
                break
            }
            
            
        } while ( true )
        self.setCursorPosition(textFieldTag: currentFieldTag, cursorPosition: cursorPosition)
        
        if fieldWithCursor <= numberOfSections {
            self.setCursorPosition(textFieldTag: fieldWithCursor, cursorPosition: 1)
        }
        
        
    }
    
    
    //MARK: Cursor Position Handler
    
    func setCursorPosition(textFieldTag : Int, cursorPosition : Int) {
        if textFieldTag - 1 < textFields.count {
            let textField = self.textFields[textFieldTag - 1]
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    func getCursorPosition(textField: UITextField) -> Int? {
        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            return cursorPosition
        }
        return nil
    }
    
    //MARK: Helper Methods
    func addTextFieldToStackView (stackView: UIStackView?, tag: Int) {
        let tf = PasteDisabledTextField()
        tf.keyboardType = widgetAppearance.keyboardType
        tf.tag = tag
        tf.backgroundColor = .clear
        tf.contentHorizontalAlignment = .center
        tf.textAlignment = .center
        tf.isSecureTextEntry = widgetAppearance.isSecureTextEntry

        tf.textColor = widgetAppearance.textColor
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        tf.isSelected = true
        tf.font = getFontSize(maxFont: self.font)

        let hint =  widgetAppearance.hintText
        let attrStr = NSMutableAttributedString(string:  hint)
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: widgetAppearance.hintColor, range:  NSRange(location: 0, length: hint.count))
        tf.attributedPlaceholder = attrStr





        tf.contentVerticalAlignment = .bottom
        tf.tintColor = widgetAppearance.cursorColor
        self.addLineToView(view: tf, color: widgetAppearance.bottomLineFocusOutColor, height: 1.0)
        textFields.append(tf)
        stackView?.addArrangedSubview(tf)
        
        
        if tf.tag != 1 {
            tf.isUserInteractionEnabled = false
        }
        
    }
    
    func changeTextFieldsFont (font: UIFont) {
        for tf in self.textFields {
            tf.font = font
        }
    }
    
    func addLineToView(view : UIView,  color: UIColor, height: CGFloat) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)
        lines.append(lineView)
        lineView.heightAnchor.constraint(equalToConstant: height).isActive = true
        lineView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
    }
    
    
    func getChangeStatus() -> ChangeStatus
    {
        totalText = ""
        for tf in self.textFields {
            totalText = totalText + tf.text!
        }
        let previousCount = previousTextCount
        previousTextCount = totalText.count
        
        if totalText.count > previousCount {
            return ChangeStatus.insert
        }else if totalText.count < previousCount {
            return ChangeStatus.remove
        }else {
            return ChangeStatus.noChange
        }
        
        
    }
    
    func updateFonts() {
        for tf in self.textFields {
            tf.font = self.getFontSize(maxFont: self.font)
        }
        
    }
    
    func getFontSize(maxFont: UIFont) -> UIFont {
        let widthToFit = (self.stackView.frame.width - (self.spacing * CGFloat(self.numberOfSections - 1))) /  CGFloat(self.numberOfSections)
        var fontSize = maxFont.pointSize
        var font = maxFont
        let allDigits = "012345789"
        
        guard let _ = self.getWidthOfBiggestCharacter(characters: allDigits, font: font) else {
            return maxFont.withSize(fontSize)
        }
        
        var w  = self.getWidthOfBiggestCharacter(characters: allDigits, font: font)!
        while (widthToFit < w) {
            font = self.font.withSize(fontSize)
            w  = self.getWidthOfBiggestCharacter(characters: allDigits, font: font)!
            fontSize = fontSize - 1
        }
        return maxFont.withSize(fontSize)
    }
    
    func getWidthOfBiggestCharacter(characters: String, font: UIFont) -> CGFloat? {
        let allDigitsWidths  =  characters.map { (character) -> CGFloat in
            return String(repeating: character, count: widgetAppearance.sectionWidth).width(withConstrainedHeight: self.stackView.frame.height, font: font)
        }
        return allDigitsWidths.max()
        
    }
    
    func clearText() {
        for field in textFields {
            field.text = ""
            field.resignFirstResponder()
        }
    }
    
    func updateHeight(height:CGFloat) {
        let viewHeight = height
        
        if self.getConstraint(attribute: .height) != nil {
            self.updateConstraint(attribute: .height, constant: viewHeight,applyLayoutChange:false)
        } else {
            self.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        }
    }
    
    func resetInput() {
        totalText = ""
        self.textField.text = ""
        for textField in textFields {
            textField.text = ""
        }
        self.hideErrorView()
        updateLinesColor()
    }
    
    
    //MARK:- Actions
    
    @IBAction func actionForHelpButton(_ sender: UIButton) {
        delegate?.actionForInfoButton(widget: self)
    }
    
    //MARK: Overrided method for server request param value
     func selectedValueForServer() -> String? {
        return !self.getFieldText().isEmpty ? self.getFieldText() : nil
    }
}




extension String {
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }
}



extension UIView {
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.alpha = 0.0
        }, completion: completion)
    }
    
    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat,applyLayoutChange:Bool = true) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            if applyLayoutChange {
                self.layoutIfNeeded()
            }
            
        }
    }
    
    func getConstraint(attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            return constraint
        }
        
        return nil
    }
    
    
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width;
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
}


class PasteDisabledTextField: UITextField {
    
    
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if  action == #selector(paste(_:)) ||  action == #selector(cut(_:)) {
            return false
        }
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in subviews {
            if let label = subview as? UILabel {
                label.minimumScaleFactor = 0.3
                label.adjustsFontSizeToFitWidth = true
                
            }
        }
    }
}


