//
//  HabitViewController.swift
//  Vane
//
//  Created by Andrey Antosha on 10/04/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController {
    
    var habits = [Habit]()
    var completedHabits = [CompletedHabit]()
    var username: String = "Hero"
    
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    var selectedDate: Date = Date()
    
    var daysArray: [Int] = Array(-14...14)
    private var daysViews = [String]()

    @IBAction func addNewHabitPressed(_ sender: Any) {
        presentSetupScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitsTableView.dataSource = self
        habitsTableView.delegate = self
        fetchHabits()
        
        let defaults = UserDefaults.standard
        if let fbName = defaults.string(forKey: fbData.firstName) {
            username = fbName
        }
        greetingsLabel.text = "Hello, \n\(username)"
        
        // Setup horizontal scrolling of days
        
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        
        
        daysCollectionView.scrollToItem(at:IndexPath(item: (daysArray.firstIndex(of: 0) ?? 0) + 2,  section: 0), at: .right, animated: false)

        
    }
    
    private func fetchHabits() {
        habits = Storage.default.fetchAllHabits()
        let weekday = getWeekday(selectedDate)
        habits = habits.filter { $0.weekdays.contains(weekday) }
//        for habit in habits {
//            Storage.default.removeHabit(habit: habit)
//        }
    
        let date = getFormattedDate(selectedDate)
        completedHabits = Storage.default.fetchCompletedHabitsByDate(date: date)

        habitsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        deselectActiveRow()
    }
    
    public func updateHabits() {
        self.fetchHabits()
    }
    
    public func getWeekday(_ date: Date) -> Int {
        return Calendar.current.component(.weekday, from: date) - 2
    }
    
    public func getFormattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    func deselectActiveRow() {
        if let index = self.habitsTableView.indexPathForSelectedRow {
            self.habitsTableView.deselectRow(at: index, animated: false)
        }
    }
    
    public func presentSetupScreen(for habit: Habit? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "HabitSetupViewController") as! HabitSetupViewController
        vc.parentVC = self
        vc.habit = habit
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension HabitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitCell
        let habit = habits[indexPath.row]
                
        habits[indexPath.row].isComplete = !self.completedHabits.filter({$0.habitId == habit.id}).isEmpty
        
        cell.bind(habits[indexPath.row])
        cell.markAsDoneButtonAction = { [unowned self] in
            
            let habit = self.habits[indexPath.row]
            
            if habit.isComplete {
                Storage.default.removeCompletedHabitByHabitId(habitId: habit.id)
            } else {
                let completed = CompletedHabit()
                completed.habitId = habit.id
                completed.day = self.getFormattedDate(self.selectedDate)
                Storage.default.saveCompletedHabit(completedHabit: completed)
            }
            
            self.habits[indexPath.row].isComplete = !self.habits[indexPath.row].isComplete
            cell.changeState(habit.isComplete)
        }
        return cell
    }
}

extension HabitViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentSetupScreen(for: habits[indexPath.row])
    }
}

extension HabitViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        let day = daysArray[indexPath.item]
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let date = Calendar.current.date(byAdding: .day, value: day, to: Date())!
        cell.label.text = formatter.string(from: date)
        cell.label.backgroundColor = getFormattedDate(date) == getFormattedDate(selectedDate) ? .black : .white
        cell.label.textColor = getFormattedDate(date) == getFormattedDate(selectedDate) ? .white: .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = Calendar.current.date(byAdding: .day, value: daysArray[indexPath.item], to: Date())!
        collectionView.reloadData()
        fetchHabits()
    }
}
