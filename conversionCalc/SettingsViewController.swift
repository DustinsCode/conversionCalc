//
//  SettingsViewController.swift
//  conversionCalc
//
//  Created by Dustin Thurston on 9/22/18.
//  Copyright © 2018 dndmobile. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit, fromLengthIndex: Int, toLengthIndex: Int)
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit, fromVolumeIndex: Int, toVolumeIndex: Int)
}

class SettingsViewController: UIViewController {
    

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    var pickerData: [String] = [String]()
    var selection : String?
    var selectionDest : String?
    var mode : CalculatorMode?
    var fromLength : LengthUnit?
    var toLength : LengthUnit?
    var fromVolume : VolumeUnit?
    var toVolume : VolumeUnit?
    var delegate : SettingsViewControllerDelegate?
    var fromLengthIndex : Int?
    var toLengthIndex : Int?
    var fromVolumeIndex : Int?
    var toVolumeIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .Length{
            LengthUnit.allCases.forEach{
                pickerData.append($0.rawValue)
            }
            self.fromLabel.text? = self.fromLength!.rawValue
            self.toLabel.text? = self.toLength!.rawValue
        }else{
            VolumeUnit.allCases.forEach{
                pickerData.append($0.rawValue)
            }
            self.fromLabel.text? = self.fromVolume!.rawValue
            self.toLabel.text? = self.toVolume!.rawValue
        }
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.fromLabel.isUserInteractionEnabled = true
        
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.hidePicker))
        let detectFromLabelTouch = UITapGestureRecognizer(target: self, action: #selector(self.showPickerFrom))
        let detectToLabelTouch = UITapGestureRecognizer(target: self, action: #selector(self.showPickerTo))
        
        self.toLabel.addGestureRecognizer(detectToLabelTouch)
        self.fromLabel.addGestureRecognizer(detectFromLabelTouch)
        self.view.addGestureRecognizer(detectTouch)
        
    }
    
    @objc func showPickerFrom(){
        hidePicker()
        if self.mode == .Length{
            self.picker.selectRow(self.fromLengthIndex!, inComponent: 0, animated: true)
        }else if self.mode == .Volume{
            self.picker.selectRow(self.fromVolumeIndex!, inComponent: 0, animated: true)
        }
        self.picker.isHidden = false
        self.selectionDest = "from"
    }
    
    @objc func showPickerTo(){
        hidePicker()
        if self.mode == .Length{
            self.picker.selectRow(self.toLengthIndex!, inComponent: 0, animated: true)
        }else if self.mode == .Volume{
            self.picker.selectRow(self.toVolumeIndex!, inComponent: 0, animated: true)
        }
        
        self.picker.isHidden = false
        self.selectionDest = "to"
    }
    
    @objc func hidePicker(){
        if self.selectionDest == "from"{
            if self.mode == .Length{
                self.fromLengthIndex = self.picker.selectedRow(inComponent: 0)
                self.fromLength = LengthUnit(rawValue: self.pickerData[fromLengthIndex!])
                
            }else{
                self.fromVolumeIndex = self.picker.selectedRow(inComponent: 0)
                self.fromVolume = VolumeUnit(rawValue: self.pickerData[fromVolumeIndex!])
                
            }
            
        }else if self.selectionDest == "to"{
            if self.mode == .Length{
                self.toLengthIndex = self.picker.selectedRow(inComponent: 0)
                self.toLength = LengthUnit(rawValue: self.pickerData[toLengthIndex!])
                
            }else{
                self.toVolumeIndex = self.picker.selectedRow(inComponent: 0)
                self.toVolume = VolumeUnit(rawValue: self.pickerData[toVolumeIndex!])
                
            }
        }
        self.picker.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let dest = segue.destination as? ViewController {
//            dest.delegate = self
//        }
//
//    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //temporary for now, delete these lines later once we can properly set these
//        fromLength = .Yards
//        toLength = .Meters
//        fromVolume = .Gallons
//        toVolume = .Quarts
        
        hidePicker()
        
        if let d = self.delegate {
            if mode == .Length{
                d.settingsChanged(fromUnits: fromLength!, toUnits: toLength!, fromLengthIndex: self.fromLengthIndex!, toLengthIndex: self.toLengthIndex!  )
            }else if mode == .Volume{
                d.settingsChanged(fromUnits: fromVolume!, toUnits: toVolume!, fromVolumeIndex: self.fromVolumeIndex!, toVolumeIndex: self.toVolumeIndex!)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {  }
    
    
}

extension SettingsViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int
    {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.selection = self.pickerData[row]
        if self.selection != nil{
            if self.selectionDest == "from"{
                self.fromLabel.text? = self.selection!
            }else if self.selectionDest == "to"{
                self.toLabel.text? = self.selection!
            }
        }else{
            if self.mode == .Length{
                if self.selectionDest == "from"{
                    self.fromLabel.text? = self.pickerData[fromLengthIndex!]
                }else if self.selectionDest == "to"{
                    self.toLabel.text? = self.pickerData[toLengthIndex!]
                }
            }else if self.mode == .Volume{
                if self.selectionDest == "from"{
                    self.fromLabel.text? = self.pickerData[fromVolumeIndex!]
                }else if self.selectionDest == "to"{
                    self.toLabel.text? = self.pickerData[toVolumeIndex!]
                }
            }
            
        }
        
        
    }
}

