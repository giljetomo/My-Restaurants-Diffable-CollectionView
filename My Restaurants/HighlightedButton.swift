//
//  HighlightedButton.swift
//  My Restaurants
//
//  Created by Macbook Pro on 2021-02-09.
//

import Foundation
import UIKit

class HighlightedButton: UIButton {

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.Theme1.black : UIColor.Theme1.yellow
            setTitleColor(isSelected ? UIColor.Theme1.yellow : UIColor.Theme1.black, for: .normal)
        }
    }
}
