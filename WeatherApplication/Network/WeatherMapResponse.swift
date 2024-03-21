//
//  WeatherMapResponse.swift
//  WeatherApplication
//
//  Created by Arkadiy Zmikhov on 21.03.2024.
//

import Foundation

struct WeatherMapResponse: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]
    let city: City?
}

struct City: Codable {
    let id: Int?
    let name: String?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop
        case dtTxt = "dt_txt"
    }
}

struct Clouds: Codable {
    let all: Int?
}

struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}


struct Weather: Codable {
    let id: Int?
    let description, icon: String?
}


struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
