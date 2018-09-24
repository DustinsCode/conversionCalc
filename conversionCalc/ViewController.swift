//
//  ViewController.swift
//  conversionCalc
//
//  Created by Dustin Thurston on 9/17/18.
//  Copyright © 2018 dndmobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SettingsViewControllerDelegate {
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit, fromLengthIndex: Int, toLengthIndex: Int) {
        self.fromUnitsLength = fromUnits
        self.toUnitsLength = toUnits
        self.fromLengthIndex = fromLengthIndex
        self.toLengthIndex = toLengthIndex
        
        self.fromLabel.text? = fromUnits.rawValue
        self.toLabel.text? = toUnits.rawValue
    }
    
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit, fromVolumeIndex: Int, toVolumeIndex: Int) {
        self.fromUnitsVolume = fromUnits
        self.toUnitsVolume = toUnits
        self.fromVolumeIndex = fromVolumeIndex
        self.toVolumeIndex = toVolumeIndex
        
        self.fromLabel.text? = fromUnits.rawValue
        self.toLabel.text? = toUnits.rawValue
    }
    
   
    
    
    
    var mode = CalculatorMode.Length
    var toUnitsLength = LengthUnit.Meters
    var fromUnitsLength = LengthUnit.Yards
    var toUnitsVolume = VolumeUnit.Liters
    var fromUnitsVolume = VolumeUnit.Gallons
    var fromLengthIndex : Int = 1
    var toLengthIndex : Int = 0
    var fromVolumeIndex : Int = 1
    var toVolumeIndex : Int = 0

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var toLabel: UILabel!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UINavigationController {
            
            if let test = dest.viewControllers[0] as? SettingsViewController {
                test.delegate = self
                test.mode = self.mode
                test.fromLength = self.fromUnitsLength
                test.toLength = self.toUnitsLength
                test.fromVolume = self.fromUnitsVolume
                test.toVolume = self.toUnitsVolume
                test.fromLengthIndex = self.fromLengthIndex
                test.toLengthIndex = self.toLengthIndex
                test.toVolumeIndex = self.toVolumeIndex
                test.fromVolumeIndex = self.fromVolumeIndex
                
            }
        }

    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        if mode == .Length{
            if self.fromField.text != "" {
                let key = LengthConversionKey(toUnits: toUnitsLength, fromUnits: fromUnitsLength)
                let conversionVal = lengthConversionTable[key]
                self.toField.text = String(Double(self.fromField.text!)! * conversionVal!)
            }else if self.toField.text != ""{
                let key = LengthConversionKey(toUnits: fromUnitsLength, fromUnits: toUnitsLength)
                let conversionVal = lengthConversionTable[key]
                self.fromField.text = String(Double(self.toField.text!)! * conversionVal!)
            }
        }else if mode == .Volume {
            if self.fromField.text != "" {
                let key = VolumeConversionKey(toUnits: toUnitsVolume, fromUnits: fromUnitsVolume)
                let conversionVal = volumeConversionTable[key]
                self.toField.text = String(Double(self.fromField.text!)! * conversionVal!)
            }else if self.toField.text != ""{
                let key = VolumeConversionKey(toUnits: fromUnitsVolume, fromUnits: toUnitsVolume)
                let conversionVal = volumeConversionTable[key]
                self.fromField.text = String(Double(self.toField.text!)! * conversionVal!)
            }
        }
        
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        self.fromField.text? = ""
        self.toField.text? = ""
    }
    
    @IBAction func modeButtonPressed(_ sender: UIButton) {
        if mode == .Length{
            mode = .Volume
            self.titleLabel?.text? = "Volume Conversion Calculator"
            self.fromLabel?.text? = fromUnitsVolume.rawValue
            self.toLabel.text? = toUnitsVolume.rawValue
            
        }else{
            mode = .Length
            self.titleLabel?.text? = "Length Conversion Calculator"
            self.fromLabel.text? = fromUnitsLength.rawValue
            self.toLabel.text? = toUnitsLength.rawValue
        }
    }
    
    @IBAction func cancelButtonPressed(segue: UIStoryboardSegue){
        
    }
    
}

