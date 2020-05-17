//
//  NewHabitViewController.swift
//  Vane
//
//  Created by Andrew on 16/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
///Users/andrew/dev/projects/Vane/Vane/Base.lproj/Main.storyboard

import UIKit
import CoreData
import NotificationCenter

class NewHabitViewController: UIViewController {
    
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var habitTitle: UITextField!
    
    @IBOutlet weak var timePickerInput: UITextField!
    private var timePicker: UIDatePicker!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyRoundCorner(mondayButton)
        applyRoundCorner(tuesdayButton)
        applyRoundCorner(wednesdayButton)
        applyRoundCorner(thursdayButton)
        applyRoundCorner(fridayButton)
        applyRoundCorner(saturdayButton)
        applyRoundCorner(sundayButton)
        
        timePicker = UIDatePicker()
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(NewHabitViewController.dateChanged(timePicker:)), for: .valueChanged)
        timePickerInput.inputView = timePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewHabitViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        createButton.layer.cornerRadius = 10
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(timePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        timePickerInput.text = dateFormatter.string(from: timePicker.date)
//        view.endEditing(true)
    }
    
    @IBAction func changeSchedule(_ button: UIButton) {
        changeAppearance(button)
    }
    
    
    func changeAppearance(_ button: UIButton) {
        if (button.layer.backgroundColor == UIColor.white.cgColor) {
            button.layer.backgroundColor = UIColor.black.cgColor
            button.setTitleColor(UIColor.white, for: .normal)
            button.isSelected = true
        } else {
            button.layer.backgroundColor = UIColor.white.cgColor
            button.setTitleColor(UIColor.black, for: .normal)
            button.isSelected = false
        }
    }
    
    func applyRoundCorner(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.width * 0.5
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.backgroundColor = UIColor.white.cgColor
    }
    
    @IBAction func createHabit(_ sender: Any) {
        if habitTitle.text == nil {
            print("Add validation for nil textfield")
            return
        }
        
        let context = delegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Habit", in: context)
        let newHabit = NSManagedObject(entity: entity!, insertInto: context)
        newHabit.setValue(habitTitle.text, forKeyPath: "title")
        newHabit.setValue("droplet", forKeyPath: "icon")
        
        if sundayButton.isSelected {
            registerNotification(habitTitle: habitTitle.text!, weekday: 1)
        }
        if mondayButton.isSelected {
            registerNotification(habitTitle: habitTitle.text!, weekday: 2)
        }
        if tuesdayButton.isSelected {
            registerNotification(habitTitle: habitTitle.text!, weekday: 3)
        }
        if wednesdayButton.isSelected {
            registerNotification(habitTitle: habitTitle.text!, weekday: 4)
        }
        if thursdayButton.isSelected {
            registerNotification(habitTitle: habitTitle.text!, weekday: 5)
        }
        if fridayButton.isSelected {
            registerNotification(habitTitle: habitTitle.text!, weekday: 6)
        }
        if saturdayButton.isSelected {
            registerNotification(habitTitle: habitTitle.text!, weekday: 7)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func registerNotification(habitTitle: String, weekday: Int) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = habitTitle
        
        var dateComponents = DateComponents()
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        dateComponents.hour = components.hour!
        dateComponents.minute = components.minute!
        dateComponents.weekday = weekday
        

//        NOTE: Notification will be executed once
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    @IBAction func sendNotification(_ sender: Any) {
//        self.registerNotification(habitTitle: "Test")
    }


}
