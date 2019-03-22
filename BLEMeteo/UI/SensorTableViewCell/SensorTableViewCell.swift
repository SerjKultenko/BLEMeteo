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
    var sensorData: SensorDataSet?
    
    // MARK: - IB Outlets
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var chartValueLabel: UILabel!
    @IBOutlet weak var hintView: UIView!
    
    // MARK: - View Lificycle
    override func awakeFromNib() {
        super.awakeFromNib()
        hintView.isHidden = true
    }

    // MARK: Helper Functions
    
    func initializeChart() {
        guard let sensorData = sensorData else { return }

        chart.delegate = self
        chart.removeAllSeries()

        // Initialize data series and labels
        var seriesData: [(Double, Double)] = []
        var labels: [Double] = []
        var labelsAsString: Array<String> = []

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        formatter.dateFormat = "HH:mm:ss"
        
        guard let minDate = sensorData.minTimeStamp(), let maxDate = sensorData.maxTimeStamp() else { return }
        
        let seconds = maxDate.timeIntervalSince(minDate)
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
            let periodAsString = formatter.string(from: minDate.addingTimeInterval(Double(i) * Double(period)))
            labelsAsString.append(periodAsString)
        }

        // Date formatter to retrieve the month names
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        for i in 0..<sensorData.pointsNumber {
            guard let value = sensorData.valueForPoint(withIndex: i),
                let time = sensorData.timestampForPoint(withIndex: i) else { break }
            //let time = i * 2
            let currentPeriod = Double(time.timeIntervalSince(minDate)) / Double(period)
            seriesData.append((Double(currentPeriod), value))
        }
        
        guard seriesData.count > 0 else { return }

        let series = ChartSeries(data: seriesData)
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
        chart.minY = seriesData.compactMap({ (x, y) -> Double? in
            return y
        }).min()! - 5
        
        chart.add(series)
    }
}

extension SensorTableViewCell: ChartDelegate {
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        guard let sensorData = sensorData, !indexes.isEmpty else { return }
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
            let numberFormatter = sensorData.numberFormatter
            let text = numberFormatter.string(from: NSNumber(value: value)) ?? ""
            chartValueLabel.text = text
            
            let font = chartValueLabel.font
            var attributes: [NSAttributedString.Key: Any] = [:]
            attributes[.font] = font
            let constraintSize = CGSize(width: .greatestFiniteMagnitude, height: chartValueLabel.frame.height)
            let labelFrameCulculated = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let labelWidth = labelFrameCulculated.width
            hintView.frame = CGRect(x: left, y: hintView.frame.origin.y, width: labelWidth + 10, height: hintView.frame.height)
            let hintViewWidth = hintView.frame.width

            chartValueLabel.frame = CGRect(x: (hintViewWidth - labelWidth)/2, y: chartValueLabel.frame.origin.y, width: labelWidth, height: chartValueLabel.frame.height)
            
            hintView.isHidden = false
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        hintView.isHidden = true
    }
}
