//
//  CustomCellView.swift
//  WeatherApplication
//
//  Created by Arkadiy Zmikhov on 21.03.2024.
//

import UIKit

class CustomCell: UITableViewCell {
    let date: UILabel = UILabel()
    let temp: UILabel = UILabel()
    let wind: UILabel = UILabel()
    let cloud: UILabel = UILabel()
    let stack: UIStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stack.distribution = .equalCentering
        contentView.backgroundColor = .systemBlue
        contentView.addSubview(stack)
        
        stack.addArrangedSubview(date)
        stack.addArrangedSubview(temp)
        stack.addArrangedSubview(wind)
        stack.addArrangedSubview(cloud)
        date.translatesAutoresizingMaskIntoConstraints = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        wind.translatesAutoresizingMaskIntoConstraints = false
        cloud.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
