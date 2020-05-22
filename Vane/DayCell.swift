//
//  DayCell.swift
//  Vane
//
//  Created by Andrew on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 26
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 26
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
}
