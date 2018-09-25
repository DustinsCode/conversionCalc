//
//  SettingsViewController.swift
//  conversionCalc
//
//  Created by Dustin Thurston & Dylan Kernohan
//  9/22/18.
//  Copyright © 2018 dndmobile. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit, fromLengthIndex: Int, toLengthIndex: Int)
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit, fromVolumeIndex: Int, toVolumeIndex: Int)
}

class SettingsViewController: UIViewController {
    
    //Outlets for picker and labels
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    /* Variables relating to the picker.*/
    var pickerData: [String] = [String]()
    var selection : String?
    var selectionDest : String?         //So we know if the picker is for "From" or "To"
    
    /* Length or Volume mode */
    var mode : CalculatorMode?
    
    /* Variables to be passed to ViewController depending on which mode we're in */
    var fromLength : LengthUnit?
    var toLength : LengthUnit?
    var fromVolume : VolumeUnit?
    var toVolume : VolumeUnit?
    
    /* Delegate to pass values back to ViewControler */
    var delegate : SettingsViewControllerDelegate?
    
    /* Indices to persist data when switching between screens */
    var fromLengthIndex : Int?
    var toLengthIndex : Int?
    var fromVolumeIndex : Int?
    var toVolumeIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Populate picker selections based on current mode
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
        
        // Setting up UITapGestures for labels and making the picker disappear
        self.fromLabel.isUserInteractionEnabled = true
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.hidePicker))
        let detectFromLabelTouch = UITapGestureRecognizer(target: self, action: #selector(self.showPickerFrom))
        let detectToLabelTouch = UITapGestureRecognizer(target: self, action: #selector(self.showPickerTo))
        
        self.toLabel.addGestureRecognizer(detectToLabelTouch)
        self.fromLabel.addGestureRecognizer(detectFromLabelTouch)
        self.view.addGestureRecognizer(detectTouch)
        
    }
    
    /* Shows the picker for the From label */
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
    
    /* Shows the picker for the To label */
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
    
    /* Hides the picker and saves picker's current selections to the appropriate variables */
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
    
    /* Action for the save button.  Saves current picker selections and
     * informs ViewController
     **/
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        hidePicker()
        
        if let d = self.delegate {
            if mode == .Length{
                d.settingsChanged(fromUnits: fromLength!, toUnits: toLength!, fromLengthIndex: self.fromLengthIndex!, toLengthIndex: self.toLengthIndex!  )
            }else if mode == .Volume{
                d.settingsChanged(fromUnits: fromVolume!, toUnits: toVolume!, fromVolumeIndex: self.fromVolumeIndex!, toVolumeIndex: self.toVolumeIndex!)
            }
        }
    }
    
    /* Cancel button handler.  Cancel button is hooked up to an unwind */
    @IBAction func cancelButtonPressed(_ sender: Any) {  }
    
    
}

/**
 * Extension to handle the picker
 */
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
        //Logic to persist selections between modes and views
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

