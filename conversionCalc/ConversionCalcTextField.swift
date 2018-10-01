//
//  ConversionCalcTextField.swift
//  conversionCalc
//
//  Created by Dustin Thurston on 10/1/18.
//  Copyright © 2018 dndmobile. All rights reserved.
//

import UIKit

class ConversionCalcTextField: DecimalMinusTextField {

    override func awakeFromNib() {
        self.tintColor = FOREGROUND_COLOR
        self.backgroundColor = UIColor.clear
        self.textColor = FOREGROUND_COLOR
        
        guard let ph = self.placeholder else{
            return
        }
        
        self.attributedPlaceholder = NSAttributedString(string: ph,
                                                              attributes: [NSAttributedStringKey.foregroundColor: FOREGROUND_COLOR])
        
    }

}
