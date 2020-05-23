//
//  ProgressViewController.swift
//  Vane
//
//  Created by Andrew on 23/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//


import UIKit
import Charts

class ProgressViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var motivationLabel: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadPieData()
        loadLineData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPieChart()
        setupLineChart()
        pieView.delegate = self
        lineChartView.delegate = self
    }
    
    func loadLineData() {
        var entires = [ChartDataEntry]()
        var i = 0
        
        var datesArray = [String]()
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        
        for x in -10...0 {
            let date = Calendar.current.date(byAdding: .day, value: x, to: Date())!
            let stats = getStats(date)
            let completed = stats.0
            let all = stats.1
            i += 1
            datesArray.append(formatter.string(from: date))
            entires.append(ChartDataEntry(x: Double(i), y: all == 0 ? 1.0 : Double(completed) / Double(all) * 100))
        }
        let set = LineChartDataSet(entries: entires)
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: datesArray)
        lineChartView.xAxis.granularity = 1

        set.drawValuesEnabled = false
        set.circleRadius = 5
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = true
        set.mode = .horizontalBezier
        
        set.setColor(UIColor(rgb: 0x536DFE))
        set.setCircleColor(UIColor(rgb: 0x536DFE))
        set.fillColor = UIColor(rgb: 0x536DFE)
//        set.circleColors = UIColor(rgb: 0xF9A826)
        
        let data = LineChartData(dataSet: set)
        lineChartView.data = data
    }
    
    func loadPieData() {
        var entires: [PieChartDataEntry] = Array()
        
        let stats = getStats(Date())
        let completed = stats.0
        let all = stats.1
        
        entires.append(PieChartDataEntry(value: Double(completed)))
        entires.append(PieChartDataEntry(value: Double(all - completed)))
        
        doneLabel.text = "\(completed)/\(all)"
        motivationLabel.text = completed != all ? "Keep going!" : "You're perfect today"
        
        let dataset = PieChartDataSet(entries: entires, label: "")
        
        dataset.drawValuesEnabled = false
        
        dataset.colors = [UIColor(rgb: 0x536DFE), UIColor(rgb: 0xF9A826)]
        
        pieView.data = PieChartData(dataSet: dataset)
    }
    
    func setupPieChart() {
        pieView.chartDescription?.enabled = false
        pieView.drawHoleEnabled = true
        pieView.rotationAngle = 270
        pieView.rotationEnabled = true
        pieView.isUserInteractionEnabled = false
        pieView.legend.enabled = false
        pieView.holeRadiusPercent = 0.8
        pieView.drawEntryLabelsEnabled = false
     }
    
    func getStats(_ date: Date) -> (Int, Int){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateStr: String = formatter.string(from: date)
        let weekday = Calendar.current.component(.weekday, from: date) - 2
        let all = Storage.default.fetchAllHabits().filter({$0.weekdays.contains(weekday)}).count
        let completedHabits = Storage.default.fetchCompletedHabitsByDate(date: dateStr)
        let completed = completedHabits.count
        return (completed, all)
    }
    
    func setupLineChart() {
        lineChartView.legend.enabled = false
        lineChartView.isUserInteractionEnabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false

        lineChartView.leftAxis.drawAxisLineEnabled = false
        
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false


    }
    
}
