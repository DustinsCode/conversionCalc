//
//  ViewController.swift
//  conversionCalc
//
//  Created by Dustin Thurston on 9/17/18.
//  Copyright © 2018 dndmobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func modeButtonPressed(_ sender: UIButton) {
    }
    
}

