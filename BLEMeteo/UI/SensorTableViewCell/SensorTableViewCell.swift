//
//  SensorTableViewCell.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 20/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import UIKit
import SwiftChart

class SensorTableViewCell: UITableViewCell {

    // MARK: - Vars
    var sensorData: SensorData?
    
    // MARK: - IB Outlets
    //@IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet weak var chart: Chart!
    
    // MARK: - View Lificycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        //initializeChart()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    
    // MARK: Helper Functions
    
    func initializeChart() {
        guard let sensorData = sensorData else { return }

        chart.delegate = self
        chart.removeAllSeries()

        // Initialize data series and labels
        //let stockValues = getStockValues()
        
        var serieData: [(Double, Double)] = []
        var labels: [Double] = []
        var labelsAsString: Array<String> = []

        
        
        let seconds = sensorData.pointsNumber * 2
        var periods = 0
        var period = 0
        if seconds > 24 * 60 * 60 {
            period = 60 * 60
        } else if seconds > 60 * 60 {
            period = 10 * 60
        } else if seconds > 60 {
            period = 60
        } else if seconds > 10 {
            period = 10
        } else {
            period = 1
        }
        periods = Int((Double(seconds) / Double(period)).rounded(.up))
        
        for i in 0...periods {
            labels.append(Double(i))
            let periodAsString = "-\((periods - i) * period) sec"
            labelsAsString.append(periodAsString)
        }

        // Date formatter to retrieve the month names
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        
        for i in 0..<sensorData.pointsNumber {
            let value = sensorData.valueForPoint(withIndex: i)!
            let time = i * 2
            let currentPeriod = Double(time) / Double(period)
            serieData.append((Double(currentPeriod), value))
        }
        
        
        /*
        for (i, value) in stockValues.enumerated() {
            
            serieData.append(value["close"] as! Double)
            
            // Use only one label for each month
            let month = Int(dateFormatter.string(from: value["date"] as! Date))!
            let monthAsString:String = dateFormatter.monthSymbols[month - 1]
            if (labels.count == 0 || labelsAsString.last != monthAsString) {
                labels.append(Double(i))
                labelsAsString.append(monthAsString)
            }
        }
 */
        guard serieData.count > 0 else { return }


        
        let series = ChartSeries(data: serieData)
        series.area = true
        
        // Configure chart layout
        
        chart.lineWidth = 0.5
        chart.labelFont = UIFont.systemFont(ofSize: 12)
        chart.xLabels = labels
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }
        chart.xLabelsTextAlignment = .center
        chart.yLabelsOnRightSide = true
        // Add some padding above the x-axis
        chart.minY = serieData.compactMap({ (x, y) -> Double? in
            return y
        }).min()! - 5
        
        chart.add(series)
        
    }


}

extension SensorTableViewCell: ChartDelegate {
    // Chart delegate
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        
//        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
//
//            let numberFormatter = NumberFormatter()
//            numberFormatter.minimumFractionDigits = 2
//            numberFormatter.maximumFractionDigits = 2
//            label.text = numberFormatter.string(from: NSNumber(value: value))
//
//            // Align the label to the touch left position, centered
//            var constant = labelLeadingMarginInitialConstant + left - (label.frame.width / 2)
//
//            // Avoid placing the label on the left of the chart
//            if constant < labelLeadingMarginInitialConstant {
//                constant = labelLeadingMarginInitialConstant
//            }
//
//            // Avoid placing the label on the right of the chart
//            let rightMargin = chart.frame.width - label.frame.width
//            if constant > rightMargin {
//                constant = rightMargin
//            }
//
//            labelLeadingMarginConstraint.constant = constant
//
//        }
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
//        label.text = ""
//        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
}

/*extension SensorTableViewCell: ScrollableGraphViewDataSource {

    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return sensorData?.valueForPoint(withIndex: pointIndex) ?? 0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "FEB \(pointIndex+1)"
    }
    
    func numberOfPoints() -> Int {
        return sensorData?.pointsNumber ?? 0
    }
}
*/
