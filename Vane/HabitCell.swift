//
//  HabitCell.swift
//  Vane
//
//  Created by Andrey Antosha on 10/04/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit

class HabitCell: UITableViewCell {
    
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var habitIconView: UIImageView!
    @IBOutlet weak var habitCompleteButton: UIButton!
    @IBOutlet weak var habitWrapperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.clipsToBounds = false
        
        habitWrapperView.layer.cornerRadius = 10
        habitWrapperView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        habitWrapperView.layer.shadowOffset = .init(width: 0, height: 4)
        habitWrapperView.layer.shadowRadius = 3
        habitWrapperView.layer.shadowOpacity = 1
        
        habitCompleteButton.layer.cornerRadius = 20
        habitCompleteButton.layer.borderWidth = 1.5
        habitCompleteButton.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func bind(_ habit: Habit) {
        self.habitTitleLabel.text = habit.title
        self.habitIconView.image = UIImage(named: habit.icon)
        
        if habit.isComplete {
            habitCompleteButton.setImage(UIImage(named: "check"), for: .normal)
        } else {
            habitCompleteButton.setImage(nil, for: .normal)
        }
    }
}
