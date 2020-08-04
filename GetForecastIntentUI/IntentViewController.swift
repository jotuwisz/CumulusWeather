//
//  IntentViewController.swift
//  GetForecastIntentUI
//
//  Created by Joseph Szafarowicz on 10/5/18.
//  Copyright © 2018 Joseph Szafarowicz. All rights reserved.
//

import IntentsUI
import CoreLocation
import ForecastIO

class IntentViewController: UIViewController, INUIHostedViewControlling, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentConditionIcon: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var highAndLowTemperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var precipitationAccumulationLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    
    @IBOutlet weak var dayZeroConditionImage: UIImageView!
    @IBOutlet weak var dayOneConditionImage: UIImageView!
    @IBOutlet weak var dayTwoConditionImage: UIImageView!
    @IBOutlet weak var dayThreeConditionImage: UIImageView!
    
    @IBOutlet weak var dayZeroDateLabel: UILabel!
    @IBOutlet weak var dayOneDateLabel: UILabel!
    @IBOutlet weak var dayTwoDateLabel: UILabel!
    @IBOutlet weak var dayThreeDateLabel: UILabel!
    
    @IBOutlet weak var day0HighLabel: UILabel!
    @IBOutlet weak var day0LowLabel: UILabel!
    @IBOutlet weak var day1HighLabel: UILabel!
    @IBOutlet weak var day1LowLabel: UILabel!
    @IBOutlet weak var day2HighLabel: UILabel!
    @IBOutlet weak var day2LowLabel: UILabel!
    @IBOutlet weak var day3HighLabel: UILabel!
    @IBOutlet weak var day3LowLabel: UILabel!
    
    
    func setWeatherDataLabels() {
        // Current condition labels
        self.currentConditionIcon.image = UIImage(named: weatherCondition(condition: currentCondition, type: "image"))
        self.currentTemperatureLabel.text = "\(currentTemperature)°"
        self.highAndLowTemperatureLabel.text = "\(day0High)°/\(day0Low)°"
        self.currentConditionLabel.text = "\(weatherCondition(condition: currentCondition, type: "text"))"
        
        self.precipitationLabel.text = "Precip. \(precipitation)%"
        self.precipitationAccumulationLabel.text = "Accum. \(precipAccumulation) \(unitsPrecipitation)"
        self.humidityLabel.text = "Humidity \(humidity)%"
        
        // Set uv index
        if uvIndex < 2 {
            uvIndexLabel.text = "UV index low (\(uvIndex))"
        } else if uvIndex >= 3 && uvIndex <= 5 {
            uvIndexLabel.text = "UV index moderate (\(uvIndex))"
        } else if uvIndex >= 6 && uvIndex <= 7 {
            uvIndexLabel.text = "UV index high (\(uvIndex))"
        } else if uvIndex >= 8 && uvIndex <= 10 {
            uvIndexLabel.text = "UV index very high (\(uvIndex))"
        } else if uvIndex >= 11 {
            uvIndexLabel.text = "UV index extreme (\(uvIndex))"
        }

        // Set wind
        if windGust == wind {
            windLabel.text = "Wind \(wind)\(unitsWindSpeed) \(windDirectionString)"
        } else {
            windLabel.text = "Wind \(wind)(\(windGust))\(unitsWindSpeed) \(windDirectionString)"
        }
        
        // Set cloud cover
        if cloudCover > cloudCoverHour1 || cloudCover > cloudCoverHour2 || cloudCover > cloudCoverHour3 || cloudCover > cloudCoverHour4 {
            cloudCoverLabel.text = "Clouds \(cloudCover)% & decr."
        } else if cloudCover < cloudCoverHour1 || cloudCover < cloudCoverHour2 || cloudCover < cloudCoverHour3 || cloudCover < cloudCoverHour4 {
            cloudCoverLabel.text = "Clouds \(cloudCover)% & incr."
        } else {
            cloudCoverLabel.text = "Clouds \(cloudCover)%"
        }
        
        // Day Zero
        self.dayZeroConditionImage.image = UIImage(named: weatherCondition(condition: day0Condition, type: "daily"))
        self.dayZeroDateLabel.text = "\(day0DayString.capitalizingFirstLetter())"
        self.day0HighLabel.text = "\(day0High)°"
        self.day0LowLabel.text = "\(day0Low)°"
        
        // Day One
        self.dayOneConditionImage.image = UIImage(named: weatherCondition(condition: day1Condition, type: "daily"))
        self.dayOneDateLabel.text = "\(day1DayString.capitalizingFirstLetter())"
        self.day1HighLabel.text = "\(day1High)°"
        self.day1LowLabel.text = "\(day1Low)°"
        
        // Day Two
        self.dayTwoConditionImage.image = UIImage(named: weatherCondition(condition: day2Condition, type: "daily"))
        self.dayTwoDateLabel.text = "\(day2DayString.capitalizingFirstLetter())"
        self.day2HighLabel.text = "\(day2High)°"
        self.day2LowLabel.text = "\(day2Low)°"
        
        // Day Three
        self.dayThreeConditionImage.image = UIImage(named: weatherCondition(condition: day3Condition, type: "daily"))
        self.dayThreeDateLabel.text = "\(day3DayString.capitalizingFirstLetter())"
        self.day3HighLabel.text = "\(day3High)°"
        self.day3LowLabel.text = "\(day3Low)°"
    }
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        let locationManager = CLLocationManager()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 100
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let userLocation = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        geocode(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!) { placemark, error in
            guard let placemark = placemark, error == nil else { return }

            // Set state for locations in the US
            if placemark.country! == "United States" {
                currentLocation = "\(placemark.locality!), \(placemark.administrativeArea!)"
                self.locationLabel.text = "\(currentLocation)"
            } else {
                currentLocation = "\(placemark.locality!), \(placemark.country!)"
                self.locationLabel.text = "\(currentLocation)"
            }
        }
        
        client.getForecast(location: userLocation) { result in
            switch result {
            case .success(let tuple):
                let (currentForecast, _) = tuple
                universalSettings()
                
                if universalUnits == "USA" {
                    client.units = .us
                    client.language = .english
                    unitsTemperature = "F"
                    unitsDistance = "miles"
                    unitsWindSpeed = "mph"
                    unitsPressure = "mB"
                    unitsPrecipitation = "in"
                }
                
                if universalUnits == "UK" {
                    client.units = .uk
                    client.language = .english
                    unitsTemperature = "C"
                    unitsDistance = "miles"
                    unitsWindSpeed = "mph"
                    unitsPressure = "hPa"
                    unitsPrecipitation = "mm"
                }
                
                if universalUnits == "Canada" {
                    client.units = .ca
                    client.language = .english
                    unitsTemperature = "C"
                    unitsDistance = "kilometers"
                    unitsWindSpeed = "km/h"
                    unitsPressure = "hPa"
                    unitsPrecipitation = "mm"
                }
                
                if universalUnits == "International" {
                    client.units = .si
                    client.language = .english
                    unitsTemperature = "C"
                    unitsDistance = "kilometers"
                    unitsWindSpeed = "m/s"
                    unitsPressure = "hPa"
                    unitsPrecipitation = "mm"
                }
                
                // Set timezone to local timezone of location
                TimeZone.ReferenceType.default = TimeZone(identifier: "\(currentForecast.timezone)")!
                
                // Manage weather data
                // Get current weather data
                if let current = currentForecast.currently {
                    currentCondition = "\(current.icon!.rawValue)"
                    currentTemperature = Int(current.temperature!)
                    precipitation = dailyPrecipProb(day: current)
                    humidity = dailyHumidityProb(day: current)
                    cloudCover = dailyCloudCoverProb(day: current)
                    uvIndex = Int(current.uvIndex!)
                    wind = Int(current.windSpeed!)
                    windGust = Int(current.windGust!)
                    windDirectionDegree = current.windBearing!
                    windDirectionString = windDirection(degree: windDirectionDegree)
                    
                    if current.precipitationAccumulation != nil {
                        precipAccumulation = Double(current.precipitationAccumulation!)
                    }
                }
                
                // Get weather data for the day
                if let daily = currentForecast.daily {
                    let firstArray = daily.data[0]
                    let fetchArray = firstArray
                    
                    day0Condition = "\(fetchArray.icon!.rawValue)"
                    
                    highTemperature = Int(fetchArray.temperatureHigh!)
                    lowTemperature = Int(fetchArray.temperatureLow!)
                    
                    // Seven day forecast
                    // Day Zero
                    let dayZeroArray = daily.data[0]
                    let fetchDayZeroArray = dayZeroArray
                    
                    // Date
                    day0DayString = dayFormat(date: dayZeroArray.time, fullLength: false)
                    
                    // High and Low
                    day0High = Int(fetchDayZeroArray.temperatureHigh!)
                    day0Low = Int(fetchDayZeroArray.temperatureLow!)
                    
                    // Precipitation
                    day0Precip = Int(fetchDayZeroArray.precipitationProbability! * 100)
                    
                    // Day One
                    let dayOneArray = daily.data[1]
                    let fetchDayOneArray = dayOneArray
                    
                    day1Condition = "\(fetchDayOneArray.icon!.rawValue)"
                    
                    // Date
                    day1DayString = dayFormat(date: dayOneArray.time, fullLength: false)
                    
                    // High and Low
                    day1High = Int(fetchDayOneArray.temperatureHigh!)
                    day1Low = Int(fetchDayOneArray.temperatureLow!)
                    
                    // Precipitation
                    day1Precip = Int(fetchDayOneArray.precipitationProbability! * 100)
                    
                    // Day Two
                    let dayTwoArray = daily.data[2]
                    let fetchDayTwoArray = dayTwoArray
                    
                    day2Condition = "\(fetchDayTwoArray.icon!.rawValue)"
                    
                    // Date
                    day2DayString = dayFormat(date: dayTwoArray.time, fullLength: false)
                    
                    // High and Low
                    day2High = Int(fetchDayTwoArray.temperatureHigh!)
                    day2Low = Int(fetchDayTwoArray.temperatureLow!)
                    
                    // Precipitation
                    day2Precip = Int(fetchDayTwoArray.precipitationProbability! * 100)
                    
                    // Day Three
                    let dayThreeArray = daily.data[3]
                    let fetchDayThreeArray = dayThreeArray
                    
                    day3Condition = "\(fetchDayThreeArray.icon!.rawValue)"
                    
                    // Date
                    day3DayString = dayFormat(date: dayThreeArray.time, fullLength: false)
                    
                    // High and Low
                    day3High = Int(fetchDayThreeArray.temperatureHigh!)
                    day3Low = Int(fetchDayThreeArray.temperatureLow!)
                    
                    // Precipitation
                    day3Precip = Int(fetchDayThreeArray.precipitationProbability! * 100)
                }
                
                DispatchQueue.main.async() {
                    self.setWeatherDataLabels()
                    completion(true, parameters, self.desiredSize)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var desiredSize: CGSize {
        let width = self.extensionContext?.hostedViewMaximumAllowedSize.width ?? 320
        return CGSize(width: width, height: 425)
    }
}
