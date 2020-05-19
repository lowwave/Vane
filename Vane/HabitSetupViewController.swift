//
//  HabitSetupViewController.swift
//  Vane
//
//  Created by Andrey Antosha on 17/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints
import RealmSwift

class HabitSetupViewController: UIViewController {
    
    public weak var parentVC: HabitViewController?
    
    public var habit: Habit? = nil
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var scheduleContainer: UIStackView!
    @IBOutlet weak var iconCollection: UICollectionView!
    @IBOutlet weak var colorCollection: UIStackView!
    @IBOutlet weak var reminderInputView: UITextField!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var weekdayViews = [WeekdayView]()
    private var colorViews = [ColorView]()
    private var selectedColorIndex: Int = 0 {
        didSet {
            updateColorSelection()
        }
    }
    private var timePicker: UIDatePicker!
    private var selectedTime: Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminderView.layer.borderWidth = 1
        reminderView.layer.borderColor = UIColor.black.cgColor
        reminderView.layer.cornerRadius = 10
        
        saveButton.layer.cornerRadius = 5
        
        // Creating weekday views
        
        let weekdayNames = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
        
        weekdayViews = weekdayNames.compactMap({
            let weekdayView = WeekdayView()
            weekdayView.title = $0
            return weekdayView
        })
        
        weekdayViews.forEach {
            scheduleContainer.addArrangedSubview($0)
        }
        
        // Creating colors
        
        colorViews = habitColors.compactMap({
            let colorView = ColorView()
            colorView.backgroundColor = $0
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorChanged))
            colorView.addGestureRecognizer(tapGesture)
            
            return colorView
        })
        
        for (index, view) in colorViews.enumerated() {
            view.tag = index
            colorCollection.addArrangedSubview(view)
        }
        
        selectedColorIndex = 0
        
        // Setup reminder time picker
        
        timePicker = UIDatePicker()
        timePicker.minuteInterval = 15
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        reminderInputView.inputView = timePicker
    }
    
    func updateColorSelection() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            // drop scale for each view
            self.colorViews.forEach {
                $0.transform = .identity
                $0.alpha = 0.4
            }

            // resize the selected color
            self.colorViews[self.selectedColorIndex].transform = .init(scaleX: 1.3, y: 1.3)
            self.colorViews[self.selectedColorIndex].alpha = 1
        }, completion: nil)
    }
    
    @objc func colorChanged(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.selectedColorIndex = sender.view!.tag
        }
        
        self.weekdayViews.forEach {
            $0.accentColor = habitColors[selectedColorIndex]
        }
    }
    
    @objc func timeChanged() {
        selectedTime = timePicker.countDownDuration
        
        let duration: TimeInterval = timePicker.countDownDuration

        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en")

        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = [.dropLeading]

        reminderInputView.text = formatter.string(from: duration) ?? "No Reminder"
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if habit == nil {
            habit = Habit()
        }
        
        // Saving the title
        
        habit?.title = titleField.text ?? "New Habit"
        
        // Saving selected weekdays
        
        habit?.weekdays.removeAll()
        
        for (index, view) in weekdayViews.enumerated() {
            if view.isSelected {
                habit?.weekdays.append(index)
            }
        }
        
        // Saving the color
        
        habit?.colorIndex = selectedColorIndex
        
        // Saving
        
        if let habit = habit {
            Storage.default.saveHabit(habit: habit)
        }
        
        self.dismiss(animated: true) {
          self.parentVC?.updateHabits()
        }
    }
    
    
    // MARK: Weekday Label
    
    class WeekdayView: UIView {
        
        public var accentColor: UIColor = habitColors[0] {
            didSet {
                updateState()
            }
        }
        
        private let label = UILabel()
        private var tapGesture: UITapGestureRecognizer!
        
        var isSelected: Bool = false {
            didSet {
                updateState()
            }
        }
        
        var title: String = "" {
            didSet {
                label.text = title
            }
        }
    
        init() {
            super.init(frame: .zero)
            
            addSubview(label)
            label.leftToSuperview()
            label.rightToSuperview()
            label.centerYToSuperview()
            label.size(CGSize(width: 40, height: 40))
            
            label.layer.borderWidth = 2
            label.layer.cornerRadius = 20
            label.clipsToBounds = true
            
            label.textAlignment = .center
            
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
            addGestureRecognizer(tapGesture)
            
            updateState()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc func onTap() {
            self.isSelected = !self.isSelected
        }
        
        func updateState() {
            label.textColor = isSelected ? .white : .black
            label.backgroundColor = isSelected ? self.accentColor : .white
            label.layer.borderColor = self.accentColor.cgColor
        }
        
    }
    
    // MARK: ColorView
    
    class ColorView: UIView {
        
        init() {
            super.init(frame: .zero)
            
            self.size(CGSize(width: 30, height: 30))
            self.layer.cornerRadius = 15
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(red: CGFloat((rgb >> 16) & 0xff) / 255.0,
                  green: CGFloat((rgb >> 8) & 0xff) / 255.0,
                  blue: CGFloat(rgb & 0xff) / 255.0,
                  alpha: 1.0)
    }
}
