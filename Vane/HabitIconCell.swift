//
//  HabitIconCell.swift
//  Vane
//
//  Created by Andrey Antosha on 21/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit

class HabitIconCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 4
    }
    
}
