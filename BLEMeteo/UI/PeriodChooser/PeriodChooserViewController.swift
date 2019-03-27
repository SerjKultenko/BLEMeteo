//
//  PeriodChooserViewController.swift
//  BLEMeteo
//
//  Created by Sergey Kultenko on 28/12/2018.
//  Copyright © 2018 Sergey Kultenko. All rights reserved.
//

import UIKit
import RxCocoa
import CrispyCalendar

class PeriodChooserViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var thisWeekButton: UIButton!
    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var thisYearButton: UIButton!
    @IBOutlet weak var last7DaysButton: UIButton!
    @IBOutlet weak var last30DaysButton: UIButton!
    @IBOutlet weak var customPeriodButton: UIButton!

    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var midlleContainerView: UIView!
    
    // MARK: - Vars
    
    var timePeriod: BehaviorRelay<TimePeriod>? {
        didSet {
            internalTimePeriod = timePeriod?.value
        }
    }
    private var internalTimePeriod: TimePeriod? {
        didSet {
            guard internalTimePeriod != nil else { return }
            switch internalTimePeriod!.type {
            case .customPeriod(let date1, let date2):
                dateFrom = date1
                dateTill = date2
            default:
                break
            }
        }
    }
    private var dateFrom: Date?
    private var dateTill: Date?
    
    private var periodButtonsGroup: [UIButton] {
        return [ todayButton,
                 thisWeekButton,
                 thisMonthButton,
                 thisYearButton,
                 last7DaysButton,
                 last30DaysButton,
                 customPeriodButton]
    }
    
    
    // MARK: - View Controller Lifecycle
    override func loadView() {
        view = Bundle.main.loadNibNamed(self.classString(), owner: self, options: nil)?[0] as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupControls()
        setupTitleLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.preferredContentSize = size
        
    }

    // MARK: - Utilites
    private func setupControls() {
        for button in periodButtonsGroup {
            set(radioButton: button, statusToSelected: false)
        }
        guard let timePeriod = internalTimePeriod else {
            updateApplyButton()
            return
        }
        
        var buttonToSelect: UIButton!
        switch timePeriod.type {
        case .today:
            buttonToSelect = todayButton
        case .thisWeek:
            buttonToSelect = thisWeekButton
        case .thisMonth:
            buttonToSelect = thisMonthButton
        case .thisYear:
            buttonToSelect = thisYearButton
        case .last7Days:
            buttonToSelect = last7DaysButton
        case .last30Days:
            buttonToSelect = last30DaysButton
        case .customPeriod(_, _):
            buttonToSelect = customPeriodButton
        }
        set(radioButton: buttonToSelect, statusToSelected: true)
        
        updateApplyButton()
    }
    
    private func setupTitleLabel() {
        let dateRange = getCurrentTimePeriod()
        titleLabel.text = dateRange?.description
    }

    private func set(radioButton button: UIButton, statusToSelected selected: Bool) {
        let buttonImageName = selected == true ? "radio-btn-selected-image" : "radio-btn-image"
        button.setImage(UIImage(named: buttonImageName), for: .normal)
        button.isSelected = selected
    }
    
    private var canApply: Bool {
        return getCurrentTimePeriod() != nil
    }
    
    private func getCurrentTimePeriod() -> TimePeriod? {
        let indexSelected = periodButtonsGroup.firstIndex { (button) -> Bool in
            return button.isSelected
        }
        
        guard indexSelected != nil else {
            return nil
        }
        
        switch indexSelected! {
        case 0:
            return TimePeriod(period: .today)
        case 1:
            return TimePeriod(period: .thisWeek)
        case 2:
            return TimePeriod(period: .thisMonth)
        case 3:
            return TimePeriod(period: .thisYear)
        case 4:
            return TimePeriod(period: .last7Days)
        case 5:
            return TimePeriod(period: .last30Days)
        case 6:
            if let date1 = dateFrom, let date2 = dateTill {
                return TimePeriod(period: .customPeriod(date1, date2))
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    func loadCalendar() {
        let vc = CalendarViewController()
        vc.delegate = self
        
        self.addChild(vc)
        vc.view.frame = self.midlleContainerView.frame;
        view.addSubview(vc.view)
        vc.view.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0).cgColor
        vc.view.layer.borderWidth = 1
        vc.view.layer.cornerRadius = 10
        vc.view.clipsToBounds = true
        
        vc.didMove(toParent: self)
    }

    func loadTimePicker() {
        let vc = ChooseTimeViewController()
        vc.delegate = self
        
        self.addChild(vc)
        vc.view.frame = self.midlleContainerView.frame;
        view.addSubview(vc.view)
        vc.dateFrom = internalTimePeriod?.dateSince
        vc.dateTill = internalTimePeriod?.dateTill
        vc.updateControls()
        
        vc.didMove(toParent: self)
    }
    
    fileprivate func updateApplyButton() {
        let enabled = canApply
        applyButton.alpha = enabled ? 1 : 0.5
        applyButton.isEnabled = enabled
    }
    
    // MARK: - Actions

    @IBAction func radioButtonAction(_ sender: UIButton) {
        for button in periodButtonsGroup {
            if button.isSelected && button != sender {
                set(radioButton: button, statusToSelected: false)
            }
            if button == sender {
                set(radioButton: button, statusToSelected: true)
            }
        }
        updateApplyButton()
        setupTitleLabel()
        if sender == customPeriodButton {
            loadCalendar()
        }
    }
    
    @IBAction func chooseTimeAction(_ sender: Any) {
       loadTimePicker()
    }
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        guard let currentTimePeriod = getCurrentTimePeriod() else { return }
        timePeriod?.accept(currentTimePeriod)
    }
    
}

// MARK: - CalendarCustomDateRangeProtocol
extension PeriodChooserViewController: CalendarCustomDateRangeProtocol {
    func didSelectDateRange(_ dateRange: CountableRange<CPCDay>) {
        dateFrom = dateRange.lowerBound.date
        dateTill = dateRange.upperBound.date
        updateApplyButton()
        setupTitleLabel()
    }
}

// MARK: - CalendarCustomDateRangeProtocol
extension PeriodChooserViewController: CalendarCustomTimeRangeDelegate {
    func didSelectTimePeriod(_ timePeriod: TimePeriod) {
        internalTimePeriod = timePeriod
        setupControls()
        updateApplyButton()
        setupTitleLabel()
    }
}
