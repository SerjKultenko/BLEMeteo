//
//  ChooseTimeViewController.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 23/03/2019.
//  Copyright © 2019 Sergey Kultenko. All rights reserved.
//

import UIKit

protocol CalendarCustomTimeRangeDelegate: class {
    func didSelectTimePeriod(_ timePeriod: TimePeriod)
}

class ChooseTimeViewController: UIViewController {

    enum DateEditingStatus {
        case noEditing
        case dateFromEditing
        case dateTillEditing
    }
    
    // MARK: - Vars
    var dateFrom: Date?
    var dateTill: Date?
    
    weak var delegate: CalendarCustomTimeRangeDelegate?
    
    private var dateEditingStatus: DateEditingStatus = .noEditing {
        didSet {
            updateOnChangeEditingStatus()
        }
    }
    private var datePickerView: UIDatePicker?
    
    // MARK: - IBOutlets
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var fromDateViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tillDateView: UIView!
    @IBOutlet weak var tillDateLabel: UILabel!
    @IBOutlet weak var tillDateViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - View Controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateControls()
    }

    // MARK: - Utitlites
    
    func updateControls() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        if dateFrom != nil {
            fromDateLabel.text = dateFormatter.string(from: dateFrom!)
        } else {
            fromDateLabel.text = nil
        }

        if dateTill != nil {
            tillDateLabel.text = dateFormatter.string(from: dateTill!)
        } else {
            tillDateLabel.text = nil
        }
    }
    
    private let kCellDefaultHeight: CGFloat = 44.0
    private let kEditingCellHeight: CGFloat = 216.0
    
    private func updateOnChangeEditingStatus() {
        datePickerView?.removeFromSuperview()
        datePickerView = nil

        updateControls()
        
        switch dateEditingStatus {
        case .noEditing:
            fromDateLabel.isHidden = false
            tillDateLabel.isHidden = false
            fromDateViewHeightConstraint.constant = kCellDefaultHeight
            tillDateViewHeightConstraint.constant = kCellDefaultHeight
        case .dateFromEditing:
            fromDateLabel.isHidden = true
            tillDateLabel.isHidden = false
            fromDateViewHeightConstraint.constant = kEditingCellHeight
            tillDateViewHeightConstraint.constant = kCellDefaultHeight
            let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: fromDateView.bounds.width, height: kEditingCellHeight))
            if dateFrom != nil {
                picker.date = dateFrom!
            }
            datePickerView = picker
            fromDateView.addSubview(picker)
        case .dateTillEditing:
            fromDateLabel.isHidden = false
            tillDateLabel.isHidden = true
            fromDateViewHeightConstraint.constant = kCellDefaultHeight
            tillDateViewHeightConstraint.constant = kEditingCellHeight
            let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: tillDateView.bounds.width, height: kEditingCellHeight))
            if dateTill != nil {
                picker.date = dateTill!
            }
            datePickerView = picker
            tillDateView.addSubview(picker)
        }
        datePickerView?.addTarget(self, action: #selector(dateChanged(sender:)
            ), for: .valueChanged)
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        switch dateEditingStatus {
        case .dateFromEditing:
            dateFrom = sender.date
            if let dateFrom = dateFrom, let dateTill = dateTill {
                if dateFrom > dateTill {
                    self.dateTill = dateFrom.addingTimeInterval(24 * 60 * 60)
                    updateControls()
                }
            }
        case .dateTillEditing:
            dateTill = sender.date
            if let dateFrom = dateFrom, let dateTill = dateTill {
                if dateFrom > dateTill {
                    self.dateFrom = dateTill.addingTimeInterval(-24 * 60 * 60)
                    updateControls()
                }
            }
        default:
            break
        }
        if let dateFrom = dateFrom, let dateTill = dateTill {
            delegate?.didSelectTimePeriod(TimePeriod(period: .customPeriod(dateFrom, dateTill)))
        }
    }
    
    // MARK: - Actions
    
    @IBAction func fromButtonAction(_ sender: Any) {
        dateEditingStatus = .dateFromEditing
    }
    
    @IBAction func tillButtonAction(_ sender: Any) {
        dateEditingStatus = .dateTillEditing
    }
    
}
