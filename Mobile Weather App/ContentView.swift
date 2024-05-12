//
//  ContentView.swift
//  Mobile Weather App
//
//  Created by Cg kon on 11.05.24.
//
import SDWebImageSwiftUI
import SwiftUI

struct ContentView: View {
    @StateObject private var forecastListVM = ForecastListViewModel()
    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    Picker(selection: $forecastListVM.system, label: Text("System")){
                        Text("C").tag(0)
                        Text("F").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    HStack{
                        TextField("Enter Location", text: $forecastListVM.location, onCommit: {
                            forecastListVM.getWeatherForecast()
                        })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay (
                                Button(action: {
                                    forecastListVM.location = ""
                                    forecastListVM.getWeatherForecast()
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal),
                                alignment: .trailing
                            )
                        Button{
                            forecastListVM.getWeatherForecast()
                        }label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title3)
                        }
                    }
                    List(forecastListVM.forecasts, id: \.day) { day in
                        VStack(alignment: .leading){          Text(day.day).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            HStack(alignment: .center){
                                WebImage(url: day.weatherIconURL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75)
                                VStack(alignment: .leading){
                                    Text(day.overview)
                                        .font(.title2)
                                    HStack{
                                        Text(day.high)
                                        Text(day.low)
                                    }
                                    HStack{
                                        Text(day.clouds)
                                        Text(day.pop)
                                    }
                                    Text(day.humidity)
                                }
                            }
                        }
                    }.listStyle(PlainListStyle())
                }
                .padding(.horizontal)
                .navigationTitle("Mobile Weather")
                .alert(item: $forecastListVM.appError) {appAlert in
                    Alert(title: Text("Error"),
                          message: Text("""
                                 \(appAlert.errorString)
                                 Please try again later!
                                 """))
                }
            }
            if forecastListVM.isLoading{
                Color(.white)
                    .opacity(0.3)
                    .ignoresSafeArea()
                ProgressView("Fetching Weather")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground)))
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    ContentView()
}
