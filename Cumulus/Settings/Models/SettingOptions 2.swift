//
//  SettingOptions.swift
//  Cumulus
//
//  Created by Joseph Szafarowicz on 11/29/18.
//  Copyright © 2018 Joseph Szafarowicz. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GooglePlaces

let defaults = UserDefaults.standard

var cumulusPro: Bool = false
var potentialCustomer: Bool = false

var placesClient: GMSPlacesClient!

// Shared Secret for IAPs, API, and Ad keys
var sharedSecret: String = "28d11783d1a94fb1895f62c10c4db49b"

// Random
var clockChanged: Bool = false
var unitsChanged: Bool = false
var setupCounter: Int = 0
var userViewedCounter: Int = 0
var userInvocationPhrase: String = ""
var twentyFourHourClockEnabled: Bool = false

// App icon & Color Themes
var userSavedAppIconString: String = ""
var randomColorEnabled: Bool = false

// Colors
var userChangedColorTheme: Bool = false
var userSavedColorString: String = ""
var buttonColor: String = ""

// Weather Alert color
let alertColor = UIColor(rgb: 0xEA2027)
var modeBackgroundColor = UIColor(rgb: 0x000000)
var modeTextColor = UIColor(rgb: 0x000000)

// Theme Colors
let mandarin = UIColor(rgb: 0xFFA500)
let malachite = UIColor(rgb: 0x32E981)
let maximumRed = UIColor(rgb: 0xD81F15)
let dodgerBlue = UIColor(rgb: 0x4361EE)
let plumpPurple = UIColor(rgb: 0x9572FF)
let sandstorm = UIColor(rgb: 0xFFDA3D)
let asteroid = UIColor(rgb: 0xE5E5E5)
let carminePink = UIColor(rgb: 0xE60073)

var defaultHourlyCondition: String = ""
var defaultDailyCondition: String = ""
var defaultWidgetSlot1: String = ""
var defaultWidgetSlot2: String = ""
var defaultDailyConditionValueType: String = ""
var defaultDailyConditionValueUnit: String = ""

var dataSource: String = ""
var dataSourceChanged: Bool = false

// Sets values for widget
var universalDataSource: String = ""
var setDataSource: String = ""

var universalDefaultWidgetSlot1: String = ""
var setDefaultWidgetSlot1: String = ""
var universalDefaultWidgetSlot2: String = ""
var setDefaultWidgetSlot2: String = ""

var universalUnits: String = ""
var setUnits: String = ""

var universalLatitude: Double = 0
var universalLongitude: Double = 0
var setWidgetLatitude: Double = 0
var setWidgetLongitude: Double = 0

func universalSettings() {
    if let widgetSetDataSource = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setDataSource") {
        universalDataSource = widgetSetDataSource
    }
    
    if let widgetSetDefaultWidgetSlot1 = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setDefaultWidgetSlot1") {
        universalDefaultWidgetSlot1 = widgetSetDefaultWidgetSlot1
    }
    
    if let widgetSetDefaultWidgetSlot2 = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setDefaultWidgetSlot2") {
        universalDefaultWidgetSlot2 = widgetSetDefaultWidgetSlot2
    }
    
    if let widgetSet = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setUnits") {
        universalUnits = widgetSet
    }
    
    if let widgetSetLatitude = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.double(forKey: "setWidgetLatitude") {
        universalLatitude = widgetSetLatitude
    }
    
    if let widgetSetLongitude = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.double(forKey: "setWidgetLongitude") {
        universalLongitude = widgetSetLongitude
    }
}

// Check user saved color
func checkSavedColor() {
    if defaults.string(forKey: "userSavedColorString") == "Tuscan" || defaults.string(forKey: "userSavedColorString") == "Mandarin" || defaults.string(forKey: "userSavedColorString") == "Malachite" || defaults.string(forKey: "userSavedColorString") == "Maximum Red" || defaults.string(forKey: "userSavedColorString") == "Dodger Blue" || defaults.string(forKey: "userSavedColorString") == "Cotton Candy" || defaults.string(forKey: "userSavedColorString") == "Plump Purple" || defaults.string(forKey: "userSavedColorString") == "Sandstorm" || defaults.string(forKey: "userSavedColorString") == "Asteroid" || defaults.string(forKey: "userSavedColorString") == "Carmine Pink" || defaults.string(forKey: "userSavedColorString") == "Iguana Green" || defaults.string(forKey: "userSavedColorString") == "Dark Cerulean" {
        // Nothing
    } else {
        defaults.set("Dodger Blue", forKey: "userSavedColorString")
    }
}

func setButtonColor() {
    if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
        buttonColor = "Mandarin"
    } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
        buttonColor = "Malachite"
    } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
        buttonColor = "Maximum Red"
    } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
        buttonColor = "Dodger Blue"
    } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
        buttonColor = "Plump Purple"
    } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
        buttonColor = "Sandstorm"
    } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
        buttonColor = "Asteroid"
    } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
        buttonColor = "Carmine Pink"
    } else {
        buttonColor = "Dodger Blue"
    }
}

// Set table cell appearance
func setTableViewCellColor(tableCell: UITableViewCell) {
    if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
        tableCell.tintColor = mandarin
    } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
        tableCell.tintColor = malachite
    } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
        tableCell.tintColor = maximumRed
    } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
        tableCell.tintColor = dodgerBlue
    } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
        tableCell.tintColor = plumpPurple
    } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
        tableCell.tintColor = sandstorm
    } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
        tableCell.tintColor = asteroid
    } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
        tableCell.tintColor = carminePink
    } else {
        tableCell.tintColor = dodgerBlue
    }
}

// Set tab bar appearance
func setTabBarColor(tabBar: UITabBarController) {
    if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
        tabBar.tabBar.tintColor = mandarin
    } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
        tabBar.tabBar.tintColor = malachite
    } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
        tabBar.tabBar.tintColor = maximumRed
    } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
        tabBar.tabBar.tintColor = dodgerBlue
    } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
        tabBar.tabBar.tintColor = plumpPurple
    } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
        tabBar.tabBar.tintColor = sandstorm
    } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
        tabBar.tabBar.tintColor = asteroid
    } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
        tabBar.tabBar.tintColor = carminePink
    } else {
        tabBar.tabBar.tintColor = dodgerBlue
    }
}

// Check for user saved color and sets button title color
func setupLabelColor(label: UILabel!) {
    if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
         label.textColor = mandarin
    } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
         label.textColor = malachite
    } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
         label.textColor = maximumRed
    } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
         label.textColor = dodgerBlue
    } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
         label.textColor = plumpPurple
    } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
         label.textColor = sandstorm
    } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
         label.textColor = asteroid
    } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
         label.textColor = carminePink
    } else {
         label.textColor = dodgerBlue
    }
}

// Check for user saved color and sets button title color
func setupButtonColor(button: UIButton!) {
    if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
         button.setTitleColor(mandarin, for: .normal)
    } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
         button.setTitleColor(malachite, for: .normal)
    } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
         button.setTitleColor(maximumRed, for: .normal)
    } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
         button.setTitleColor(dodgerBlue, for: .normal)
    } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
         button.setTitleColor(plumpPurple, for: .normal)
    } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
         button.setTitleColor(sandstorm, for: .normal)
    } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
         button.setTitleColor(asteroid, for: .normal)
    } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
         button.setTitleColor(carminePink, for: .normal)
    } else {
         button.setTitleColor(dodgerBlue, for: .normal)
    }
}

// Check for user saved color and sets button title color
func setupBarButtonColor(button: UIBarButtonItem!) {
    if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
        button.tintColor = mandarin
    } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
        button.tintColor = malachite
    } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
        button.tintColor = maximumRed
    } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
        button.tintColor = dodgerBlue
    } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
        button.tintColor = plumpPurple
    } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
        button.tintColor = sandstorm
    } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
        button.tintColor = asteroid
    } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
        button.tintColor = carminePink
    } else {
        button.tintColor = dodgerBlue
    }
}

// Check for user saved color and sets switch title color
func setupSwitchColor(switchOne: UISwitch!) {
    if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
         switchOne.onTintColor = mandarin
    } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
         switchOne.onTintColor = malachite
    } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
         switchOne.onTintColor = maximumRed
    } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
         switchOne.onTintColor = dodgerBlue
    } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
         switchOne.onTintColor = plumpPurple
    } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
         switchOne.onTintColor = sandstorm
    } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
         switchOne.onTintColor = asteroid
    } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
         switchOne.onTintColor = carminePink
    } else {
         switchOne.onTintColor = dodgerBlue
    }
}

// Check for user saved color and sets text field text color
func setupTextFieldColor(textField: UITextField!) {
    if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
         textField.textColor = mandarin
    } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
         textField.textColor = malachite
    } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
         textField.textColor = maximumRed
    } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
         textField.textColor = dodgerBlue
    } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
         textField.textColor = plumpPurple
    } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
         textField.textColor = sandstorm
    } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
         textField.textColor = asteroid
    } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
         textField.textColor = carminePink
    } else {
         textField.textColor = dodgerBlue
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIToolbar {

    func ToolbarPicker(mySelect : Selector) -> UIToolbar {

        let toolBar = UIToolbar()

        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar
    }
}