//
//  HabitViewController.swift
//  Vane
//
//  Created by Andrey Antosha on 10/04/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController {
    
//    var habits: [Habit] = []
    var habits = [Habit]()
    var username: String = "Username"
    
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var greetingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greetingsLabel.text = "Hello, \n\(username)"
        habitsTableView.dataSource = self
        fetchHabits()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        fetchHabits()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let habitSetupVC = segue.destination as? HabitSetupViewController {
            habitSetupVC.parentVC = self
        }
    }
    
    private func fetchHabits() {
        habits = Storage.default.fetchAllHabits()
    }
    
    public func updateHabits() {
        self.fetchHabits()
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
