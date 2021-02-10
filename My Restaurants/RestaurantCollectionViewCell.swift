//
//  RestaurantCollectionViewCell.swift
//  My Restaurants
//
//  Created by Gil Jetomo on 2021-02-05.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "restaurantCell"
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let title: UILabel = {
        let lbl = UILabel()
        lbl.setContentHuggingPriority(.required, for: .horizontal)
        lbl.clipsToBounds = true
        lbl.textColor = UIColor.Theme1.black
        lbl.layer.cornerRadius = 1
        lbl.font = UIFont.init(name: "Arial", size: 19)
        return lbl
    }()
    let price: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.clipsToBounds = true
        lbl.textColor = UIColor.Theme1.white
        lbl.layer.cornerRadius = 1
        lbl.backgroundColor = UIColor.Theme1.green
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        return lbl
    }()
    let classification: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.Theme1.brown
        lbl.font = UIFont.init(name: "Arial", size: 16)
        return lbl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let hStackView = UIStackView(arrangedSubviews: [title, UIView(), price])
        hStackView.axis = .horizontal
        hStackView.alignment = .fill
        hStackView.distribution = .fill
        
        let vStackView = UIStackView(arrangedSubviews: [hStackView, classification])
        vStackView.axis = .vertical
        vStackView.alignment = .fill
        vStackView.distribution = .fill
        vStackView.spacing = 2
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(vStackView)
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65).isActive = true
        
        vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        vStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(with restaurant: Restaurant) {
        title.text = restaurant.title
        imageView.image = restaurant.image
        price.text = restaurant.price.rawValue
        classification.text = restaurant.type.map {$0.rawValue}.joined(separator: " ")
        
//for future implementation
//        guard Restaurant.selectedItems.count > 0 else { return }
//        //highlight each type
//        let attrsString =  NSMutableAttributedString(string:classification.text!);
//        let filters = Restaurant.selectedItems.map { $0.rawValue }
//        for filter in filters where classification.text!.contains(filter) {
//            let color: UIColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
//            let range = (classification.text! as NSString).range(of: filter)
//            if (range.length > 0) {
//                attrsString.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
//            }
//        }
//        classification.attributedText = attrsString
    }
}
