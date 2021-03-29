//
//  Cumulus_Widget.swift
//  Cumulus Widget
//
//  Created by Joseph Szafarowicz on 10/3/20.
//  Copyright © 2020 Joseph Szafarowicz. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreLocation
import ForecastIO
import Combine

struct ForecastTimeline: TimelineProvider {
    var widgetLocationManager = WidgetLocationManager()
    
    func placeholder(in context: Context) -> ForecastEntry {
        return ForecastEntry(date: Date(), latitude: 37.3230, longitude: -122.0322, currentLocation: "Cupertino,CA", currentCondition: "Partly cloudy", currentTemperature: 79, currentSummary: "Partly cloudy for the hour.")
    }

    func getSnapshot(in context: Context, completion: @escaping (ForecastEntry) -> ()) {
        let entry = ForecastEntry(date: Date(), latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary)
        return completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ForecastEntry] = []
        
        if widgetLocationManager.locationManager == nil {
            widgetLocationManager.locationManager = CLLocationManager()
            widgetLocationManager.locationManager!.requestWhenInUseAuthorization()
        }
        widgetLocationManager.fetchLocation(handler: { location in
            if universalCumulusPlus == "true" {
                let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                let entry = ForecastEntry(date: entryDate, latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary)
                entries.append(entry)

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            } else {
                let entryDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
                let entry = ForecastEntry(date: entryDate, latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary)
                entries.append(entry)

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        })
    }
}

struct ForecastEntry: TimelineEntry {
    let date: Date
    let latitude: Double
    let longitude: Double
    
    var currentLocation: String
    var currentCondition: String
    var currentTemperature: Int
    var currentSummary: String
}

struct CurrentForecastWidgetView : View {
    let data: ForecastEntry

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            VStack {
                Text("\(data.currentLocation)")
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 30, alignment: .bottom)
                HStack {
                    Image(setWeatherConditionImage(condition: data.currentCondition, type: "widget", circle: universalIcons))
                        .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                    Text("\(data.currentTemperature)°")
                        .font(.system(size: 30, weight: .semibold, design: .default))
                        .frame(maxWidth: 80, maxHeight: 45, alignment: .leading)
                }
                Text("\(data.currentSummary.capitalizingFirstLetter())")
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .frame(maxWidth: 150, maxHeight: 30, alignment: .top)
                Text("↑\(highTemperature)° ↓\(lowTemperature)°")
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .frame(maxWidth: 150, maxHeight: 10, alignment: .center)
            }
        }
    }
}

struct HourlyForecastWidgetView : View {
    let data: ForecastEntry
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            VStack {
                Text("\(currentLocation)")
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .frame(maxWidth: 325, maxHeight: 10, alignment: .leading)
                HStack {
                    Text("\(currentTemperature)°")
                        .font(.system(size: 30, weight: .semibold, design: .default))
                        .frame(maxWidth: 75, maxHeight: 45, alignment: .leading)
                    VStack(alignment: .trailing) {
                        Text("\(currentSummary.capitalizingFirstLetter())")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 250, maxHeight: 25, alignment: .bottomTrailing)
                        HStack {
                            Text("↑\(highTemperature)° ↓\(lowTemperature)°")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .frame(maxWidth: 70, maxHeight: 20, alignment: .topTrailing)
                        }
                    }
                }

                HStack(spacing: 10) {
                    VStack {
                        Text("NOW")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour1, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour0)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour3)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour3, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour3)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour6)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour6, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour6)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour10)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour10, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour10)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour13)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour13, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour13)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour15)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour15, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour15)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                }
            }
        }
    }
}

struct DailyForecastWidgetView : View {
    let data: ForecastEntry
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            VStack {
                Text("\(currentLocation)")
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .frame(maxWidth: 325, maxHeight: 10, alignment: .leading)
                HStack {
                    Text("\(currentTemperature)°")
                        .font(.system(size: 30, weight: .semibold, design: .default))
                        .frame(maxWidth: 75, maxHeight: 45, alignment: .leading)
                    VStack(alignment: .trailing) {
                        Text("\(currentSummary.capitalizingFirstLetter())")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 250, maxHeight: 25, alignment: .bottomTrailing)
                        HStack {
                            Text("↑\(highTemperature)° ↓\(lowTemperature)°")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .frame(maxWidth: 70, maxHeight: 20, alignment: .topTrailing)
                        }
                    }
                }

                HStack(spacing: 10) {
                    VStack {
                        Text("NOW")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour1, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour0)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour3)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour3, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour3)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour6)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour6, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour6)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour10)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour10, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour10)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour13)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour13, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour13)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                    VStack {
                        Text("\(hour15)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                        Image(setWeatherConditionImage(condition: conditionHour15, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(tempHour15)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .center)
                    }
                }
                
                VStack(spacing: 0) {
                    HStack {
                        Text("\(day1DayStringFull.capitalizingFirstLetter())")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 150, maxHeight: 10, alignment: .leading)
                        Image(setWeatherConditionImage(condition: day1Condition, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(day1High)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .trailing)
                        Text("\(day1Low)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .leading)
                    }
                    HStack {
                        Text("\(day2DayStringFull.capitalizingFirstLetter())")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 150, maxHeight: 10, alignment: .leading)
                        Image(setWeatherConditionImage(condition: day2Condition, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(day2High)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .trailing)
                        Text("\(day2Low)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .leading)
                    }
                    HStack {
                        Text("\(day3DayStringFull.capitalizingFirstLetter())")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 150, maxHeight: 10, alignment: .leading)
                        Image(setWeatherConditionImage(condition: day3Condition, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(day3High)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .trailing)
                        Text("\(day3Low)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .leading)
                    }
                    HStack {
                        Text("\(day4DayStringFull.capitalizingFirstLetter())")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 150, maxHeight: 10, alignment: .leading)
                        Image(setWeatherConditionImage(condition: day4Condition, type: "widget", circle: universalIcons))
                            .frame(maxWidth: 45, maxHeight: 45, alignment: .center)
                        Text("\(day4High)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .trailing)
                        Text("\(day4Low)°")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.gray)
                            .frame(maxWidth: 45, maxHeight: 10, alignment: .leading)
                    }
                }
            }
        }
    }
}

struct CurrentForecastWidget: Widget {
    private let kind = "CurrentForecastWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ForecastTimeline()) { entry in
            CurrentForecastWidgetView(data: ForecastEntry(date: Date(), latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary))
        }
        .configurationDisplayName("Current Forecast")
        .description("View the current forecast.")
        .supportedFamilies([.systemSmall])
    }
}

struct HourlyForecastWidget: Widget {
    private let kind = "HourlyForecastWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ForecastTimeline()) { entry in
            HourlyForecastWidgetView(data: ForecastEntry(date: Date(), latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary))
        }
        .configurationDisplayName("Hourly Forecast")
        .description("View the current and hourly forecasts.")
        .supportedFamilies([.systemMedium])
    }
}

struct DailyForecastWidget: Widget {
    private let kind = "DailyForecastWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ForecastTimeline()) { entry in
            DailyForecastWidgetView(data: ForecastEntry(date: Date(), latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary))
        }
        .configurationDisplayName("Daily Forecast")
        .description("View the current, hourly, and daily forecasts.")
        .supportedFamilies([.systemLarge])
    }
}

@main
struct SwiftWidgetsBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CurrentForecastWidget()
        HourlyForecastWidget()
        DailyForecastWidget()
    }
}

struct Cumulus_Widget_Previews: PreviewProvider {
    static var previews: some View {
        CurrentForecastWidgetView(data: ForecastEntry(date: Date(), latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        HourlyForecastWidgetView(data: ForecastEntry(date: Date(), latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        DailyForecastWidgetView(data: ForecastEntry(date: Date(), latitude: latitudeValue, longitude: longitudeValue, currentLocation: currentLocation, currentCondition: currentCondition, currentTemperature: currentTemperature, currentSummary: currentSummary))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

class WidgetLocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager? {
        didSet {
            self.locationManager!.delegate = self
        }
    }
    
    private var handler: ((CLLocation) -> Void)?
    func fetchLocation(handler: @escaping (CLLocation) -> Void) {
        self.handler = handler
        self.locationManager!.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.handler!(locations.last!)
        universalSettings()
        
//        latitudeValue = 37.3230
//        longitudeValue = -122.0322
        latitudeValue = (manager.location?.coordinate.latitude)!
        longitudeValue = (manager.location?.coordinate.longitude)!
        
        geocode(latitude: latitudeValue, longitude: longitudeValue) { placemark, error in
            guard let placemark = placemark, error == nil else { return }

            // Set state/province for respective locations
            if placemark.locality != nil && placemark.administrativeArea != nil && placemark.country != nil {
                if placemark.country! == "Micronesia" || placemark.country! == "Myanmar" || placemark.country! == "United States" {
                    currentLocation = "\(placemark.locality!), \(placemark.administrativeArea!)"
                } else if placemark.country! == "Japan" {
                    currentLocation = "\(placemark.administrativeArea!), \(placemark.country!)"
                 } else {
                   currentLocation = "\(placemark.locality!), \(placemark.country!)"
                }
            } else {
                currentLocation = "\(placemark.name!), \(placemark.country!)"
            }
            
            if universalDataSource == "Dark Sky" {
                fetchDarkSkyWeatherData()
            } else if universalDataSource == "OpenWeather" {
                fetchOpenWeatherData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
