//
//  UISettings.swift
//  teamTimer3
//
//  Created by Игорь Корабельников on 05.04.2020.
//  Copyright © 2020 Игорь Корабельников. All rights reserved.
//

import Foundation
import UIKit

class UISettingsManager {
    
     func pickerModeControl(teaSort: TeaSortEnum, greenTeaPicker: UIPickerView, blackTeaPicker: UIPickerView, subviewWithPickers: UIView) {
        if teaSort == .green {
            subviewWithPickers.isHidden = false
            greenTeaPicker.isHidden = false
            blackTeaPicker.isHidden = true
        } else if teaSort == .black {
            subviewWithPickers.isHidden = false
            blackTeaPicker.isHidden = false
            greenTeaPicker.isHidden = true
        }
    }
    
    func shapesOfElements(buttons: [UIButton]) {
    buttons.forEach { (button) in
    button.layer.cornerRadius = button.frame.size.height / 2
    button.titleLabel?.textAlignment = .center }
    }
    
    func segmentedButtonSelected(selectedButton: UIButton,notSelectedButton: UIButton, colorOfSelectedButton: TeaSortEnum,teaSort: inout TeaSortEnum) {
    selectedButton.isSelected = true
    teaSort = colorOfSelectedButton
    notSelectedButton.isSelected = false
    selectedButton.backgroundColor = #colorLiteral(red: 0, green: 0.6549019608, blue: 0.462745098, alpha: 1)
    selectedButton.titleLabel?.textColor = #colorLiteral(red: 0.9529623389, green: 0.9598125815, blue: 0.9751449227, alpha: 1)
    notSelectedButton.backgroundColor = #colorLiteral(red: 0.7739834189, green: 0.7929247022, blue: 0.8539995551, alpha: 1)
    notSelectedButton.titleLabel?.textColor = #colorLiteral(red: 0.9529623389, green: 0.9598125815, blue: 0.9751449227, alpha: 1)
    }
    
}
