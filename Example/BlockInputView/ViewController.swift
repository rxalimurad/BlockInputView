//
//  ViewController.swift
//  BlockInputView
//
//  Created by herralimurad on 01/07/2020.
//  Copyright (c) 2020 herralimurad. All rights reserved.
//

import UIKit
import BlockInputView

class ViewController: UIViewController {
    
    @IBOutlet weak var cardNumberInput: BlockInputView!
    @IBOutlet weak var pinInput: BlockInputView!
    @IBOutlet weak var otpInput: BlockInputView!
    @IBOutlet weak var macAddressInput: BlockInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardNumberInput.delegate = self
        cardNumberInput.activate()
        
        var widgetProperPIN = WidgetAppearance()
        widgetProperPIN.minNumberOfSections = 4
        widgetProperPIN.sectionWidth = 1
        widgetProperPIN.emptyMessage = "Please enter valid pin"
        widgetProperPIN.errorMessage = "Invalid pin"
        widgetProperPIN.isSecureTextEntry = true
        widgetProperPIN.minLength = 1
        widgetProperPIN.maxLength = 4
        widgetProperPIN.hintText = "0"
        
        pinInput.delegate = self
        pinInput.activate(widgetAppearance: widgetProperPIN)
        
        var widgetProperOTP = WidgetAppearance()
        widgetProperOTP.minNumberOfSections = 8
        widgetProperOTP.sectionWidth = 1
        widgetProperOTP.emptyMessage = "Please enter valid OTP"
        widgetProperOTP.errorMessage = "Invalid Code"
        widgetProperOTP.minLength = 1
        widgetProperOTP.maxLength = 8
        widgetProperOTP.hintText = "0"
        
        otpInput.delegate = self
        otpInput.activate(widgetAppearance: widgetProperOTP)
        
        var widgetProperMAC = WidgetAppearance()
        widgetProperMAC.minNumberOfSections = 6
        widgetProperMAC.sectionWidth = 2
        widgetProperMAC.errorMessage = "Please enter valid OTP"
        widgetProperMAC.emptyMessage = "Invalid mac address"
        widgetProperMAC.minLength = 1
        widgetProperMAC.maxLength = 12
        widgetProperMAC.hintText = "00"
        widgetProperMAC.keyboardType = .default
        
        macAddressInput.delegate = self
        macAddressInput.activate(widgetAppearance: widgetProperMAC)
    }
    @IBAction func actForNext(_ sender: UIButton) {
        if cardNumberInput.validate() && pinInput.validate() && otpInput.validate() && macAddressInput.validate() {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            vc.cardNo = cardNumberInput.getFieldText()
            vc.mac = macAddressInput.getFieldText()
            vc.pin = pinInput.getFieldText()
            vc.otp = otpInput.getFieldText()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension ViewController: BlockInputViewDelegate {
    func actionForInfoButton(widget: BlockInputView) {
        print("tapped")
    }
    
    
}
