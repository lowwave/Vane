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
    @IBOutlet weak var setupReminderButton: UIButton!
    @IBOutlet weak var deleteHabitButton: UIButton!
    
    private var weekdayViews = [WeekdayView]()
    private var colorViews = [ColorView]()
    private var selectedColorIndex: Int = 0
    private var selectedTime: Double? = nil
    private var selectedIcon: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        definesPresentationContext = true
//        hidesBottomBarWhenPushed = true
        
        if habit == nil {
            deleteHabitButton.isHidden = true
        }
        
        reminderView.layer.borderWidth = 1
        reminderView.layer.borderColor = habitColors[self.selectedColorIndex].cgColor
        reminderView.layer.cornerRadius = 10
        
        saveButton.layer.cornerRadius = 5
        
        // Data from habit
        
        titleField.text = habit?.title
        selectedTime = habit?.reminderTime.value
        selectedIcon = habit?.icon ?? iconNames.randomElement()!
        selectedColorIndex = habit?.colorIndex ?? 0
        
        // Creating weekday views
        
        let weekdayNames = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        
        weekdayViews = weekdayNames.compactMap({
            let weekdayView = WeekdayView()
            weekdayView.title = $0
            weekdayView.accentColor = habitColors[selectedColorIndex]
            return weekdayView
        })
        
        weekdayViews.forEach {
            scheduleContainer.addArrangedSubview($0)
        }
        
        for (index, view) in weekdayViews.enumerated() {
            view.isSelected = habit?.weekdays.contains(index + 1) == true
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
        
        updateColorSelection()
        timeChanged()
        
        // Setup reminder time picker
        
        iconCollection.dataSource = self
        iconCollection.delegate = self
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
            self.updateColorSelection()
        }
        
        self.reminderView.layer.borderColor = habitColors[selectedColorIndex].cgColor
        
        self.weekdayViews.forEach {
            $0.accentColor = habitColors[selectedColorIndex]
        }
        
        self.iconCollection.reloadData()
    }
    
    @objc func timeChanged() {
        if let duration: TimeInterval = selectedTime {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "en")

            let formatter = DateComponentsFormatter()
            formatter.calendar = calendar
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute]
            formatter.zeroFormattingBehavior = [.dropLeading]

            reminderInputView.text = formatter.string(from: duration) ?? "No Reminder"
        } else {
            reminderInputView.text = "No Reminder"
        }
    }
    
    @IBAction func setupReminderTapped(_ sender: Any) {
        let vc = PickerViewController(time: habit?.reminderTime.value, title: "Reminder") { [weak self] (newTime) in
            self?.selectedTime = newTime
            self?.timeChanged()
            
            if newTime != nil {
                PermissionManager.request(.notifications) { _ in
                    
                }
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func deleteHabitTapped(_ sender: Any) {
        if let existingHabit = habit {
            Storage.default.removeHabit(habit: existingHabit)
        }
        
        self.dismiss(animated: true) {
            self.parentVC?.updateHabits()
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if habit == nil {
            habit = Habit()
        }
        
        // Saving the title
        
        let title = titleField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        habit?.title = title.isEmpty ? "New Habit" : title
        
        // Saving selected weekdays
        
        habit?.weekdays.removeAll()
        
        for (index, view) in weekdayViews.enumerated() {
            if view.isSelected {
                habit?.weekdays.append(index + 1)
            }
        }
        
        // Saving the color
        
        habit?.colorIndex = selectedColorIndex
        
        // Saving the icon
        
        habit?.icon = selectedIcon
        
        // Saving the time
        
        habit?.reminderTime.value = selectedTime
        
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
            label.textColor = isSelected ? .white : UIColor.label
            label.backgroundColor = isSelected ? self.accentColor : .clear
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

extension HabitSetupViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitIconCell", for: indexPath) as! HabitIconCell
        
        cell.contentView.backgroundColor = habitColors[selectedColorIndex]
        
        let iconName = iconNames[indexPath.item]
        cell.imageView.image = UIImage(named: iconName)
        cell.contentView.alpha = (iconName == selectedIcon) ? 1 : 0.4
        
        return cell
    }
}

extension HabitSetupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 57, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIcon = iconNames[indexPath.item]
        collectionView.reloadData()
    }
}
