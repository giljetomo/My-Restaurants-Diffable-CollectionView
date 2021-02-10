//
//  RestaurantCollectionViewCell.swift
//  My Restaurants
//
//  Created by Gil Jetomo on 2021-02-04.
//

import UIKit

protocol FilterCollectionViewCellDelegate: class {
    func filterSelected()
}
class FilterCollectionViewCell: UICollectionViewCell {
    
    var delegate: FilterCollectionViewCellDelegate?
    static let identifier = "filterCell"

    lazy var button: HighlightedButton = {
        let btn = HighlightedButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        btn.setTitleColor(.brown, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.layer.cornerRadius = 4
        btn.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return btn
    }()
    @objc func buttonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
    
        guard let buttonText = sender.titleLabel?.text?.lowercased() else { return }
        guard let type = Type(rawValue: buttonText) else { return }
        
        sender.isSelected ?
            Restaurant.selectedItems.append(type) :
            (Restaurant.selectedItems = Restaurant.selectedItems.filter {$0.rawValue != buttonText})
        
        UIView.animate(withDuration: 0.10) {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { (_) in
            UIView.animate(withDuration: 0.10) {
                sender.transform = CGAffineTransform.identity
            }
        }
        delegate?.filterSelected()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        //constraints need to be applied so the button does not overflow outside the contentView
        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
