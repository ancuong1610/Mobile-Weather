//
//  ForecastListViewModel.swift
//  Mobile Weather App
//
//  Created by Cg kon on 11.05.24.
//

import Foundation
import CoreLocation
import SwiftUI

class ForecastListViewModel: ObservableObject{
    struct AppError: Identifiable{
        let id = UUID().uuidString
        let errorString: String
    }
    @Published var forecasts: [ForecastViewModel] = []
    var appError: AppError? = nil
    @Published var isLoading: Bool = false
    @AppStorage("location")var storagelocation: String = ""
    @Published var location = ""
    @AppStorage("system")var system: Int = 0{
        didSet{
            for i in 0..<forecasts.count{
                forecasts[i].system = system
            }
        }
    }
    
    init(){
        location = storagelocation
        getWeatherForecast()
    }
    
    func getWeatherForecast(){
        storagelocation = location
        UIApplication.shared.endEditing()
        if location == ""{
            forecasts = []
        } else{
            isLoading = true
            let apiService = APIServiceCombine.shared
            CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                if let error = error as? CLError{
                    switch error.code{
                    case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                        self.appError = AppError(errorString: NSLocalizedString("Unable to determine location from this text", comment: ""))
                    case .network:
                        self.appError = AppError(errorString: NSLocalizedString("You do not appear to have a network connection.", comment: ""))
                    default:
                        self.appError = AppError(errorString: error.localizedDescription)
                    }
                    self.isLoading = false
                    print(error.localizedDescription)
                }
                if let lat = placemarks?.first?.location?.coordinate.latitude,
                   let lon = placemarks?.first?.location?.coordinate.longitude {
                    // Don't forget to use your own key
                    apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=a9c90e4395bcd1555390fcb809844fd2",
                                       dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIServiceCombine.APIError>) in
                        switch result {
                        case .success(let forecast):
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.forecasts = forecast.daily.map {ForecastViewModel(forecast: $0, system: self.system)}
                            }
                        case .failure(let apiError):
                            switch apiError {
                            case .error(let errorString):
                                self.appError = AppError(errorString: errorString)
                                print(errorString)
                            }
                        }
                    }
                }
            }
        }
    }
}
