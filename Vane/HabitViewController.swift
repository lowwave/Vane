//
//  HabitViewController.swift
//  Vane
//
//  Created by Andrey Antosha on 10/04/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController {
    
    var habits: [Habit] = []
    var username: String = "Username"
    
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var greetingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greetingsLabel.text = "Hello, \n\(username)"
        
        createHabits()
        habitsTableView.dataSource = self
    }
    
    private func createHabits() {
        for i in 1...100 {
            let habit = Habit(title: "Habit number \(i)", icon: "droplet", isComplete: Bool.random())
            habits.append(habit)
        }
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
        return cell
    }
}
