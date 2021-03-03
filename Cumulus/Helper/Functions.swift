//
//  Functions.swift
//  Cumulus
//
//  Created by Joseph Szafarowicz on 2/1/21.
//  Copyright © 2021 Joseph Szafarowicz. All rights reserved.
//

import Foundation
import CoreLocation
import ForecastIO

func universalSettings() {
    if let widgetSetDataSource = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setDataSource") {
        universalDataSource = widgetSetDataSource
    }
    
    if let widgetSet = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setUnits") {
        universalUnits = widgetSet
    }
    
    if let widgetSetCumulusPlus = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setCumulusPlus") {
        universalCumulusPlus = widgetSetCumulusPlus
    }
    
    if let widgetSetIcons = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setIcons") {
        universalIcons = widgetSetIcons
    }
    
    if let widgetSetColor = UserDefaults.init(suiteName: "group.com.josephszafarowicz.weather")?.string(forKey: "setColor") {
        universalColor = widgetSetColor
    }
}

func checkSavedColor() {
    if (defaults.string(forKey: "userSavedColorString") == "Mango") || (defaults.string(forKey: "userSavedColorString") == "Maximum Red") || (defaults.string(forKey: "userSavedColorString") == "Dodger Blue") || (defaults.string(forKey: "userSavedColorString") == "Plump Purple") || (defaults.string(forKey: "userSavedColorString") == "Orchid") || (defaults.string(forKey: "userSavedColorString") == "Spring Green") {
        // Nothing
    } else {
        defaults.set("Dodger Blue", forKey: "userSavedColorString")
    }
}

func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
        guard let placemark = placemarks?.first, error == nil else {
            completion(nil, error)
            return
        }
        completion(placemark, nil)
    }
}

// MARK: - Get day name
func dayFormat(date: Date, fullLength: Bool) -> String {
    var dayString: String = ""
    
    if fullLength == true {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dayString = dateFormatter.string(from: date).uppercased()
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dayString = dateFormatter.string(from: date).uppercased()
    }
    
    return dayString
}

func dateFormat(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    
    return dateFormatter.string(from: date).uppercased()
}

// MARK: - Get hour times from date
func hourFormat(date: Date) -> String {
    var timeString: String = ""
    if (defaults.bool(forKey: "twentyFourHourClockEnabled") == true) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        timeString = dateFormatter.string(from: date)
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        timeString = dateFormatter.string(from: date)
    }
    
    return timeString
}

func twentyFourHour(hour: Int, meridiem: String) -> Int {
    var hourTime: Int = 0
    
    if hour == 12 && meridiem == "am" {
        hourTime = 0
    } else if hour == 1 && meridiem == "am" {
        hourTime = 1
    } else if hour == 2 && meridiem == "am" {
        hourTime = 2
    } else if hour == 3 && meridiem == "am" {
        hourTime = 3
    } else if hour == 4 && meridiem == "am" {
        hourTime = 4
    } else if hour == 5 && meridiem == "am" {
        hourTime = 5
    } else if hour == 6 && meridiem == "am" {
        hourTime = 6
    } else if hour == 7 && meridiem == "am" {
        hourTime = 7
    } else if hour == 8 && meridiem == "am" {
        hourTime = 8
    } else if hour == 9 && meridiem == "am" {
        hourTime = 9
    } else if hour == 10 && meridiem == "am" {
        hourTime = 10
    } else if hour == 11 && meridiem == "am" {
        hourTime = 11
    } else if hour == 12 && meridiem == "pm" {
        hourTime = 12
    } else if hour == 1 && meridiem == "pm" {
        hourTime = 13
    } else if hour == 2 && meridiem == "pm" {
        hourTime = 14
    } else if hour == 3 && meridiem == "pm" {
        hourTime = 15
    } else if hour == 4 && meridiem == "pm" {
        hourTime = 16
    } else if hour == 5 && meridiem == "pm" {
        hourTime = 17
    } else if hour == 6 && meridiem == "pm" {
        hourTime = 18
    } else if hour == 7 && meridiem == "pm" {
        hourTime = 19
    } else if hour == 8 && meridiem == "pm" {
        hourTime = 20
    } else if hour == 9 && meridiem == "pm" {
        hourTime = 21
    } else if hour == 10 && meridiem == "pm" {
        hourTime = 22
    } else if hour == 11 && meridiem == "pm" {
        hourTime = 23
    }
    
    return hourTime
}

func sunFormat(date: Date) -> String {
    var timeString: String = ""
    if (defaults.bool(forKey: "twentyFourHourClockEnabled") == true) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        timeString = dateFormatter.string(from: date)
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        timeString = dateFormatter.string(from: date)
    }
    
    return timeString
}

func windDirection(degree: Double) -> String {
    var directionString: String = ""
    
    if degree == 0 && degree <= 22.4 {
        directionString = "N"
    } else if degree >= 22.5 && degree <= 44 {
        directionString = "NE"
    } else if degree >= 45 && degree <= 67.4 {
        directionString = "NE"
    } else if degree >= 67.5 && degree <= 89 {
        directionString = "NE"
    } else if degree >= 90 && degree <= 112.4 {
        directionString = "E"
    } else if degree >= 112.5 && degree <= 134 {
        directionString = "SE"
    } else if degree >= 135 && degree <= 157.4 {
        directionString = "SE"
    } else if degree >= 157.5 && degree <= 179 {
        directionString = "SE"
    } else if degree >= 180 && degree <= 202.4 {
        directionString = "S"
    } else if degree >= 202.5 && degree <= 224 {
        directionString = "SW"
    } else if degree >= 225 && degree <= 147.4 {
        directionString = "SW"
    } else if degree >= 147.5 && degree <= 269 {
        directionString = "SW"
    } else if degree >= 270 && degree <= 292.4 {
        directionString = "W"
    } else if degree >= 292.5 && degree <= 314 {
        directionString = "NW"
    } else if degree >= 315 && degree <= 337.4 {
        directionString = "NW"
    } else if degree >= 337.5 && degree <= 360 {
        directionString = "NW"
    }
    
    return directionString
}

func moonPhase(percentage: Double) -> String {
    let value = percentage * 100
    
    if value == 0 {
        moonPhaseString = "New moon"
    } else if value >= 1 && value <= 24 {
        moonPhaseString = "Waxing crescent"
    } else if value == 25 {
        moonPhaseString = "First quarter"
    } else if value >= 26 && value <= 49  {
        moonPhaseString = "Waxing gibbous"
    } else if value == 50 {
        moonPhaseString = "Full moon"
    } else if value >= 51 && value <= 74  {
        moonPhaseString = "Waning gibbous"
    } else if value == 75 {
        moonPhaseString = "Last quarter"
    } else if value >= 76 && value <= 100  {
        moonPhaseString = "Waning crescent"
    }
    
    return moonPhaseString
}

func kmhToMS(speed: CGFloat) -> Int {
    return Int(speed / 3.6)
}

func inToMM(amount: Double) -> Double {
    return Double(amount * 25.4)
}

func dailyPrecipAccum(day: DataPoint) -> Double {
    var dailyValue: Double = 0
    
    if day.precipitationAccumulation != nil {
        if unitsPrecipitation == "mm" {
            dailyValue = inToMM(amount: Double(day.precipitationAccumulation!))
        } else {
            dailyValue = Double(day.precipitationAccumulation!)
        }
    } else {
        dailyValue = 0
    }
    
    return dailyValue
}

func dailyPrecipProb(day: DataPoint) -> Int {
    var dailyValue: Int = 0
    
    if day.precipitationProbability != nil {
        dailyValue = Int(day.precipitationProbability! * 100)
    } else {
        dailyValue = 0
    }
    
    return dailyValue
}

func cgFloatPrecipProb(day: CGFloat) -> Int {
    var dailyValue: Int = 0
    
    if day.isNaN == true {
        dailyValue = 0
    } else {
        dailyValue = Int(day * 100)
    }
    
    return dailyValue
}

func dailyHumidityProb(day: DataPoint) -> Int {
    var dailyValue: Int = 0
    
    if day.humidity != nil {
        dailyValue = Int(day.humidity! * 100)
    } else {
        dailyValue = 0
    }
    
    return dailyValue
}

func dailyCloudCoverProb(day: DataPoint) -> Int {
    var dailyValue: Int = 0
    
    if day.cloudCover != nil {
        dailyValue = Int(day.cloudCover! * 100)
    } else {
        dailyValue = 0
    }
    
    return dailyValue
}

func minutePrecipProb(value: Int, minute: DataBlock?) -> Int {
    var minuteValue: Int = 0
    
    let fetchMinute = minute!.data[value]
    let minuteArray = fetchMinute
    
    if minuteArray.precipitationProbability != nil {
        minuteValue = Int(minuteArray.precipitationProbability! * 100)
    } else {
        minuteValue = 0
    }
    
    return minuteValue
}

func minutePrecipIntensity(value: Int, minute: DataBlock?) -> Double {
    var minuteValue: Double = 0
    
    let fetchMinute = minute!.data[value]
    let minuteArray = fetchMinute
    
    if minuteArray.precipitationIntensity != nil {
        minuteValue = Double(minuteArray.precipitationIntensity!).rounded(toPlaces: 2)
    } else {
        minuteValue = 0
    }
    
    return minuteValue
}

func minutePrecipType(value: Int, minute: DataBlock?) -> String {
    var minuteValue: String = ""
    
    let fetchMinute = minute!.data[value]
    let minuteArray = fetchMinute
    
    if minuteArray.precipitationType != nil {
        minuteValue = "\(minuteArray.precipitationType!)"
    } else {
        minuteValue = "none"
    }
    
    return minuteValue
}

func hourPrecipProb(value: Int, hour: DataBlock?) -> Int {
    var hourValue: Int = 0
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.precipitationProbability != nil {
        hourValue = Int(hourArray.precipitationProbability! * 100)
    } else {
        hourValue = 0
    }
    
    return hourValue
}

func hourAccumProb(value: Int, hour: DataBlock?) -> Double {
    var hourValue: Double = 0
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.precipitationAccumulation != nil {
        if unitsPrecipitation == "mm" {
            hourValue = inToMM(amount: Double(hourArray.precipitationAccumulation!))
        } else {
            hourValue = Double(hourArray.precipitationAccumulation!)
        }
    } else {
        hourValue = 0
    }
    
    return hourValue
}

func hourTemp(value: Int, hour: DataBlock?) -> Int {
    var hourValue: Int = 0
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.temperature != nil {
        hourValue = Int(hourArray.temperature!)
    } else {
        hourValue = 0
    }
    
    return hourValue
}

func hourHumidity(value: Int, hour: DataBlock?) -> Int {
    var hourValue: Int = 0
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.humidity != nil {
        hourValue = Int(hourArray.humidity! * 100)
    } else {
        hourValue = 0
    }
    
    return hourValue
}

func hourUVIndex(value: Int, hour: DataBlock?) -> Int {
    var hourValue: Int = 0
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.uvIndex != nil {
        hourValue = Int(hourArray.uvIndex!)
    } else {
        hourValue = 0
    }
    
    return hourValue
}

func hourPressure(value: Int, hour: DataBlock?) -> Int {
    var hourValue: Int = 0
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.pressure != nil {
        hourValue = Int(hourArray.pressure!)
    } else {
        hourValue = 0
    }
    
    return hourValue
}

func hourWindSpeed(value: Int, hour: DataBlock?) -> Int {
    var hourValue: Int = 0
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.windSpeed != nil {
        hourValue = Int(hourArray.windSpeed!)
    } else {
        hourValue = 0
    }
    
    return hourValue
}

func hourWindDirection(value: Int, hour: DataBlock?) -> String {
    var hourValue: Double = 0
    var hourDirectionString: String = ""
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.windBearing != nil {
        hourValue = hourArray.windBearing!
        hourDirectionString = windDirection(degree: hourValue)
    } else {
        hourValue = 0
    }
    
    return hourDirectionString
}

func hourCloudCover(value: Int, hour: DataBlock?) -> Int {
    var hourValue: Int = 0
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.cloudCover != nil {
        hourValue = Int(hourArray.cloudCover! * 100)
    } else {
        hourValue = 0
    }
    
    return hourValue
}

func hourIcon(value: Int, hour: DataBlock?) -> String {
    var hourValue: String = ""
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    if hourArray.icon != nil {
        hourValue = hourArray.icon!.rawValue
    } else {
        hourValue = ""
    }
    
    return hourValue
}

func hourTime(value: Int, hour: DataBlock?) -> String {
    var hourValue: String = ""
    
    let fetchHour = hour!.data[value]
    let hourArray = fetchHour
    
    hourValue = hourFormat(date: hourArray.time)
    
    return hourValue
}

func hourlyValue(value: Int) -> Int {
    var valueInteger: Int = 0
    
    let screenSize = UIScreen.main.bounds
    let screenWidth = screenSize.width
    if screenWidth == 320 {
        valueInteger = value + 3
    } else {
        valueInteger = value + 6
    }
    
    return valueInteger
}