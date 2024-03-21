//
//  NetworkProvider.swift
//  WeatherApplication
//
//  Created by Arkadiy Zmikhov on 21.03.2024.
//

import Foundation

class NetworkProvider {
    func fetchServerStatus2(lat: Double, lon: Double, completion: @escaping (WeatherMapResponse) -> Void) {
        let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=1bfc5510205d109746c32825cce242a2&units=metric")!)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let data = try? JSONDecoder().decode(WeatherMapResponse.self, from: data) {
                completion(data)
            } else {
                print("error")
            }
        }
        task.resume()
    }
}
