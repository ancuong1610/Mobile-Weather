//
//  ForecastViewModel.swift
//  Mobile Weather App
//
//  Created by Cg kon on 11.05.24.
//

import Foundation

struct ForecastViewModel{
    let forecast: Forecast.Daily
    var system: Int
    
    private static var dateFormatter: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d"
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter{
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private static var numberFormatter2: NumberFormatter{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    func convert(_ temp: Double) -> Double{
        let celsius = temp - 273.5
        if system == 0{
            return celsius
        }else{
            return celsius * 9 / 5 + 32
        }
    }
    
    var day: String{
        return Self.dateFormatter.string(from: forecast.dt)
    }
    
    var overview: String{
        forecast.weather[0].description.capitalized
    }
    
    var high: String{
        return "H: \(Self.numberFormatter.string(for: convert(forecast.temp.max)) ?? "0")Degree"
    }
    
    var low: String{
        return "L: \(Self.numberFormatter.string(for: convert(forecast.temp.min)) ?? "0")Degree"
    }
    
    var pop: String{
        return "💧 \(Self.numberFormatter2.string(for: forecast.pop) ?? "0%")"
    }
    
    var clouds: String{
        return "☁️ \(forecast.clouds)%"
    }
    
    var humidity: String{
        return "Humidity: \(forecast.humidity)%"
    }
    
    var weatherIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
}
