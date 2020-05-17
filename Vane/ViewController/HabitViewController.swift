//
//  HabitViewController.swift
//  Vane
//
//  Created by Andrey Antosha on 10/04/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit
import CoreData


class HabitViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var habits = [Habit]()
    var username: String = ""
    
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var greetingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username = defaults.object(forKey: "fbFirstName") as! String
        greetingsLabel.text = "Hello, \n\(username)"
                
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        /*
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Habit")
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            // Execute Batch Request
            let batchDeleteResult = try context.execute(deleteRequest) as! NSBatchDeleteResult
             
            print("The batch delete request has deleted \(batchDeleteResult.result!) records.")
             
            // Reset Managed Object Context
            context.reset()
        } catch {
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }
        // */
        
        
        let fetchRequest = NSFetchRequest<Habit>(entityName: "Habit")
        
        do {
            habits = try context.fetch(fetchRequest)
            print(habits)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        habitsTableView.dataSource = self
    }
    
    /*
    private func createHabits() {
        for i in 1...5 {
            let habit = Habit(title: "Habit number \(i)", icon: "droplet", isComplete: Bool.random())
            habits.append(habit)
        }
    }
     */
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
//            var habit = self.habits[indexPath.row]
//            print(habit)
            self.habits[indexPath.row].isCompleted = !habit.isCompleted
            tableView.reloadRows(at: [indexPath], with: .none)
//            DispatchQueue.main.async {}

        }
        return cell
    }
}
