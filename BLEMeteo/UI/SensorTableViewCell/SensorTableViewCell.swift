//
//  SensorTableViewCell.swift
//  BLEMeteo
//
//  Created by Kultenko Sergey on 20/10/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import UIKit
import ScrollableGraphView

class SensorTableViewCell: UITableViewCell {

    // MARK: - Vars
    var sensorData: SensorData?
    
    // MARK: - IB Outlets
    @IBOutlet weak var graphView: ScrollableGraphView!
    
    // MARK: - View Lificycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        graphView.dataSource = self
        setupGraph(graphView: graphView)
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    
    // MARK: Helper Functions
    
    // When using Interface Builder, only add the plots and reference lines in code.
    func setupGraph(graphView: ScrollableGraphView) {
        
        // Setup the first line plot.
        let blueLinePlot = LinePlot(identifier: "one")
        
        blueLinePlot.lineWidth = 5
        blueLinePlot.lineColor = UIColor.colorFromHex(hexString: "#16aafc")
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        blueLinePlot.shouldFill = false
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = UIColor.colorFromHex(hexString: "#16aafc").withAlphaComponent(0.5)
        
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
//        // Setup the second line plot.
//        let orangeLinePlot = LinePlot(identifier: "two")
//
//        orangeLinePlot.lineWidth = 5
//        orangeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#ff7d78")
//        orangeLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
//
//        orangeLinePlot.shouldFill = false
//        orangeLinePlot.fillType = ScrollableGraphViewFillType.solid
//        orangeLinePlot.fillColor = UIColor.colorFromHex(hexString: "#ff7d78").withAlphaComponent(0.5)
//
//        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Customise the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        
        // All other graph customisation is done in Interface Builder,
        // e.g, the background colour would be set in interface builder rather than in code.
        // graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        //graphView.addPlot(plot: orangeLinePlot)
    }

}

extension SensorTableViewCell: ScrollableGraphViewDataSource {

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
