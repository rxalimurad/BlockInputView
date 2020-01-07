//
//  SecondViewController.swift
//  BlockInputView_Example
//
//  Created by Apple on 1/8/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var lbl: UILabel!
    var number: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl.text = "Value is " + number
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
