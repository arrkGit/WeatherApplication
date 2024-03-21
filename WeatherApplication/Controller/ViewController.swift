//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Arkadiy Zmikhov on 21.03.2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let textTemp = UILabel()
    private let mainTemp = UILabel()
    private let mainWind = UILabel()
    private let mainCloud = UILabel()
    private let mainCity = UILabel()
    private let networkProvider = NetworkProvider()
    private var data: WeatherMapResponse?
    private var lat: Double? = nil
    private var lon: Double? = nil
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self

        view.backgroundColor = .cyan
        
        view.addSubview(textTemp)
        view.addSubview(mainTemp)
        view.addSubview(mainWind)
        view.addSubview(mainCloud)
        view.addSubview(mainCity)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        
        configureTableView()
        configureMainBlock()
    }
    
    func configureMainBlock() {
        textTemp.translatesAutoresizingMaskIntoConstraints = false
        mainTemp.translatesAutoresizingMaskIntoConstraints = false
        mainWind.translatesAutoresizingMaskIntoConstraints = false
        mainCity.translatesAutoresizingMaskIntoConstraints = false
        mainCloud.translatesAutoresizingMaskIntoConstraints = false
        
        textTemp.textAlignment = .center
        mainTemp.textAlignment = .center
        mainWind.textAlignment = .center
        mainCloud.textAlignment = .center
        mainCity.textAlignment = .center
        
        textTemp.text = "Температура сейчас:"
        textTemp.font = textTemp.font.withSize(20)
        mainTemp.font = mainTemp.font.withSize(60)
        
        NSLayoutConstraint.activate([
            textTemp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textTemp.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textTemp.bottomAnchor.constraint(equalTo: mainTemp.topAnchor),
            
            mainTemp.topAnchor.constraint(equalTo: textTemp.bottomAnchor),
            mainTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTemp.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTemp.bottomAnchor.constraint(equalTo: mainWind.topAnchor),
            
            mainWind.topAnchor.constraint(equalTo: mainTemp.bottomAnchor),
            mainWind.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainWind.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainWind.bottomAnchor.constraint(equalTo: mainCloud.topAnchor),
            
            mainCloud.topAnchor.constraint(equalTo: mainWind.bottomAnchor),
            mainCloud.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCloud.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCloud.bottomAnchor.constraint(equalTo: mainCity.topAnchor),
            
            mainCity.topAnchor.constraint(equalTo: mainCloud.bottomAnchor),
            mainCity.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCity.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCity.bottomAnchor.constraint(equalTo: tableView.topAnchor),
        ])
    }
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainCity.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        let d = "\(data?.list[indexPath.row].dtTxt ?? "")"
        let date: String = "\(data?.list[indexPath.row].dtTxt ?? "")"[5..<d.count-3]
        cell.date.text = date
        cell.temp.text = "\(data?.list[indexPath.row].main?.temp ?? 0.0)"
        cell.wind.text = "\(data?.list[indexPath.row].wind?.speed ?? 0.0)"
        cell.cloud.text = "\(data?.list[indexPath.row].clouds?.all ?? 0)"
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let stack: UIStackView = UIStackView()
        
        let date: UILabel = UILabel()
        date.text = "Дата"
        stack.addArrangedSubview(date)
        let temp: UILabel = UILabel()
        temp.text = "Температура"
        stack.addArrangedSubview(temp)
        let wind: UILabel = UILabel()
        wind.text = "Ветер"
        stack.addArrangedSubview(wind)
        let cloud: UILabel = UILabel()
        cloud.text = "Облачность"
        stack.addArrangedSubview(cloud)
        
        stack.distribution = .equalCentering
        stack.backgroundColor = .systemBlue
        
        return stack
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            networkProvider.fetchServerStatus2(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { response in
                self.data = response
                DispatchQueue.main.async {
                    let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    self.lat = location.coordinate.latitude
                    self.lon = location.coordinate.longitude
                    location.fetchCityAndCountry { city, country, error in
                        guard let city = city, let country = country, error == nil else { return }
                        self.mainCity.text = "Ваша локация: " + city
                        print(city + ", " + country)
                    }
                    self.mainTemp.text = "\(response.list.first?.main?.temp ?? 0.0)"
                    self.mainWind.text = "Скорость ветра: " + "\(response.list.first?.wind?.speed ?? 0.0)"
                    self.mainCloud.text = "Облачность: " + "\(response.list.first?.clouds?.all ?? 0)"
                    self.tableView.reloadData()
                }
            }
        }
    }
}
