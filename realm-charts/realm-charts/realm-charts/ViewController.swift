//
//  ViewController.swift
//  realm-charts
//
//  Created by Sachin Leelasena on 21/02/2017.
//  Copyright © 2017 Sachin Leelasena. All rights reserved.
//

import UIKit
import Charts
import RealmSwift


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        axisFormatDelegate = self
//        updateChartWithData()
        updateLineChartWithData()
        updatePieChartWithData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBOutlet weak var tfValue: UITextField!
    
    @IBOutlet weak var lineView: LineChartView!
    
    @IBOutlet weak var pieView: PieChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
//    @IBAction func btnAddTapped(_ sender: AnyObject) {
//        
//        // If text field is not empty, create new object and store in db
//        if let value = tfValue.text , value != "" {
//            let visitorCount = VisitorCount()
//            visitorCount.count = (NumberFormatter().number(from: value)?.intValue)!
//            visitorCount.save()
//            tfValue.text = "" // Clear text field
//        }
////        updateChartWithData()
//        updateLineChartWithData()
//        updatePieChartWithData()
//    }
    
//    func updateChartWithData() {
//        var dataEntries: [BarChartDataEntry] = []
//        let visitorCounts = getVisitorCountsFromDatabase()
//        for i in 0..<visitorCounts.count {
//            let timeIntervalForDate: TimeInterval = visitorCounts[i].date.timeIntervalSince1970
//            let dataEntry = BarChartDataEntry(x: Double(timeIntervalForDate), y: Double(visitorCounts[i].count))
//            dataEntries.append(dataEntry)
//        }
//        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Visitor count")
//        let chartData = BarChartData(dataSet: chartDataSet)
//        barView.data = chartData
//        
//        let xaxis = barView.xAxis
//        xaxis.valueFormatter = axisFormatDelegate
//    }
    
    func getVisitorCountsFromDatabase() -> Results<VisitorCount> {
        do {
            let realm = try Realm()
            debugPrint("Path to line realm file: " + realm.configuration.fileURL!.absoluteString)
            return realm.objects(VisitorCount.self)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func getPosturePercentagesFromDatabase() -> Results<PosturePercentages> {
        do {
            let realm = try Realm()
            debugPrint("Path to pie realm file: " + realm.configuration.fileURL!.absoluteString)
            return realm.objects(PosturePercentages.self)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateLineChartWithData() {
        var dataEntries: [ChartDataEntry] = []
        let visitorCounts = getVisitorCountsFromDatabase()
        for i in 0..<visitorCounts.count {
            let timeIntervalForDate: TimeInterval = visitorCounts[i].date.timeIntervalSince1970
            let dataEntry = ChartDataEntry(x: Double(timeIntervalForDate), y: Double(visitorCounts[i].count))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "% Good Posture")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineView.data = lineChartData
        
        let line_xaxis = lineView.xAxis
        line_xaxis.valueFormatter = axisFormatDelegate
        
        // Y axis values are a %
        let axisMin = 0.0
        let axisMax = 100.0
        
        lineView.leftAxis.axisMinimum = axisMin
        lineView.leftAxis.axisMaximum = axisMax
        lineView.rightAxis.axisMinimum = axisMin
        lineView.rightAxis.axisMaximum = axisMax
        
        let ll = ChartLimitLine(limit: 75.0, label: "Target")
        lineView.rightAxis.addLimitLine(ll)
    }
    
    func updatePieChartWithData() {
        var dataEntries: [ChartDataEntry] = []
        
        let posturePercentages = getPosturePercentagesFromDatabase()
        
        for i in 0..<posturePercentages.count {
            let dataEntry = PieChartDataEntry(value: Double(posturePercentages[i].count), label: posturePercentages[i].classification, data: posturePercentages[i].count as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        var colors: [UIColor] = []
        
        for i in 0..<posturePercentages.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "% Posture today")
        pieChartDataSet.colors = colors
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieView.data = pieChartData
    }
    
}

// MARK: axisFormatDelegate
extension ViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

