//
//  PickerView.swift
//  Vane
//
//  Created by Andrey Antosha on 21/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit

class PickerView: UIView {

    var titleLabel: UILabel!
    var cancelButton: UIButton!
    var confirmButton: UIButton!

    var datePicker: UIDatePicker?

    var valueFormatString: String!
    var confirmEmptyString: String?

    init(title: String) {
        super.init(frame: .zero)

        if traitCollection.userInterfaceStyle == .light {
            self.backgroundColor = .white
        } else {
            self.backgroundColor = .black
        }
        

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = title
        
        cancelButton = UIButton()
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.setTitle("Delete", for: .normal)
        
        confirmButton = UIButton()
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitle("Set Reminder", for: .normal)
        confirmButton.backgroundColor = .blue
        confirmButton.layer.cornerRadius = 15

        addSubview(titleLabel)
        addSubview(cancelButton)
        addSubview(confirmButton)

        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        datePicker = GarbageDatePicker(frame: .zero)
        datePicker?.datePickerMode = .time
        datePicker?.minuteInterval = 1
        datePicker?.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        datePicker?.minuteInterval = 1
        addSubview(datePicker!)
      
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func datePickerValueChanged() {
        
    }
    
    func getSelectedTime() -> Double? {
        return datePicker?.countDownDuration
    }
    
    func selectPickerValue(time: Double) {
        if let datePicker = datePicker {
            datePicker.countDownDuration = time
            datePickerValueChanged()
        }
    }
    
    func setupConstraints() {
        cancelButton.topToSuperview(offset: 0)
        cancelButton.leftToSuperview(offset: 15)
        cancelButton.height(55)

        titleLabel.topToSuperview()
        titleLabel.centerXToSuperview()
        titleLabel.height(55)

        confirmButton.bottom(to: safeAreaLayoutGuide, offset: -10)
        confirmButton.rightToSuperview(offset: -15)
        confirmButton.leftToSuperview(offset: 15)
        confirmButton.height(55)

        datePicker?.topToSuperview(offset: 35)
        datePicker?.leftToSuperview()
        datePicker?.rightToSuperview()
        datePicker?.height(250)
        datePicker?.bottomToTop(of: confirmButton, offset: -5)
    }
    
}

class GarbageDatePicker: UIDatePicker {
    override func layoutSubviews() {
        super.layoutSubviews()

//        setValue(false, forKey: "highlightsToday")
//        setValue(UITheme.current.textColor, forKey: "textColor")
    }
}

