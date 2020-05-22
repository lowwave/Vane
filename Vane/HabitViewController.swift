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
    var username: String = "Hero"
    
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var greetingsLabel: UILabel!

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
    }
    
    private func fetchHabits() {
        habits = Storage.default.fetchAllHabits()
//        for habit in habits {
//            Storage.default.removeHabit(habit: habit)
//        }
        habitsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        deselectActiveRow()
    }
    
    public func updateHabits() {
        self.fetchHabits()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath)
        let habit = habits[indexPath.row]
        (cell as? HabitCell)?.bind(habit)
        
        (cell as? HabitCell)?.markAsDoneButtonAction = { [unowned self] in
            self.habits[indexPath.row].isComplete = !habit.isComplete
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}

extension HabitViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentSetupScreen(for: habits[indexPath.row])
    }
}
