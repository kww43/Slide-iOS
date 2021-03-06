//
//  SettingsTheme.swift
//  Slide for Reddit
//
//  Created by Carlos Crane on 1/21/17.
//  Copyright © 2017 Haptic Apps. All rights reserved.
//

import MKColorPicker
import RLBAlertsPickers
import UIKit

class SettingsTheme: UITableViewController, ColorPickerViewDelegate {

    var tochange: SettingsViewController?
    var primary: UITableViewCell = UITableViewCell()
    var accent: UITableViewCell = UITableViewCell()
    var base: UITableViewCell = UITableViewCell()
    var night: UITableViewCell = UITableViewCell()
    var tintingMode: UITableViewCell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "tintingMode")
    var tintOutside: UITableViewCell = UITableViewCell()
    var tintOutsideSwitch: UISwitch = UISwitch()
    
    var reduceColor: UITableViewCell = UITableViewCell()
    var reduceColorSwitch: UISwitch = UISwitch()

    var isAccent = false
    
    var titleLabel = UILabel()

    var accentChosen: UIColor?
    var primaryChosen: UIColor?

    public func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        if isAccent {
            accentChosen = colorPickerView.colors[indexPath.row]
            titleLabel.textColor = self.accentChosen!
        } else {
            primaryChosen = colorPickerView.colors[indexPath.row]
            setupBaseBarColors(primaryChosen)
        }
    }

    func pickTheme() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        isAccent = false
        let margin: CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? 314 - margin * 4.0: alertController.view.bounds.size.width - margin * 4.0, height: 150)
        let MKColorPicker = ColorPickerView.init(frame: rect)
        MKColorPicker.delegate = self
        MKColorPicker.colors = GMPalette.allColor()
        MKColorPicker.selectionStyle = .check
        MKColorPicker.scrollDirection = .vertical
        let firstColor = ColorUtil.baseColor
        for i in 0 ..< MKColorPicker.colors.count {
            if MKColorPicker.colors[i].cgColor.__equalTo(firstColor.cgColor) {
                MKColorPicker.preselectedIndex = i
                break
            }
        }

        MKColorPicker.style = .circle

        alertController.view.addSubview(MKColorPicker)

        /*todo maybe ? let custom = UIAlertAction(title: "Custom color", style: .default, handler: { (alert: UIAlertAction!) in
            if(!VCPresenter.proDialogShown(feature: false, self)){
                let alert = UIAlertController.init(title: "Choose a color", message: nil, preferredStyle: .actionSheet)
                alert.addColorPicker(color: (self.navigationController?.navigationBar.barTintColor)!, selection: { (color) in
                    UserDefaults.standard.setColor(color: (self.navigationController?.navigationBar.barTintColor)!, forKey: "basecolor")
                    UserDefaults.standard.synchronize()
                    ColorUtil.doInit()
                })
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                    self.pickTheme()
                }))
                self.present(alert, animated: true)
            }
        })*/

        let somethingAction = UIAlertAction(title: "Save", style: .default, handler: { (_: UIAlertAction!) in
            if self.primaryChosen != nil {
                UserDefaults.standard.setColor(color: self.primaryChosen!, forKey: "basecolor")
                UserDefaults.standard.synchronize()
            }

            UserDefaults.standard.setColor(color: (self.navigationController?.navigationBar.barTintColor)!, forKey: "basecolor")
            UserDefaults.standard.synchronize()
            _ = ColorUtil.doInit()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_: UIAlertAction!) in
            self.setupBaseBarColors()
        })

        //alertController.addAction(custom)
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)

        alertController.modalPresentationStyle = .popover
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = selectedTableView
            presenter.sourceRect = selectedTableView.bounds
        }

        present(alertController, animated: true, completion: nil)
    }

    func pickAccent() {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

        let margin: CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? 314 - margin * 4.0: alertController.view.bounds.size.width - margin * 4.0, height: 150)
        let MKColorPicker = ColorPickerView.init(frame: rect)
        MKColorPicker.delegate = self
        MKColorPicker.colors = GMPalette.allColorAccent()
        MKColorPicker.selectionStyle = .check

        self.isAccent = true
        MKColorPicker.scrollDirection = .vertical
        let firstColor = ColorUtil.baseColor
        for i in 0 ..< MKColorPicker.colors.count {
            if MKColorPicker.colors[i].cgColor.__equalTo(firstColor.cgColor) {
                MKColorPicker.preselectedIndex = i
                break
            }
        }

        MKColorPicker.style = .circle

        alertController.view.addSubview(MKColorPicker)

        let somethingAction = UIAlertAction(title: "Save", style: .default, handler: { (_: UIAlertAction!) in
            if self.accentChosen != nil {
                UserDefaults.standard.setColor(color: self.accentChosen!, forKey: "accentcolor")
                UserDefaults.standard.synchronize()
                _ = ColorUtil.doInit()
                self.titleLabel.textColor = self.accentChosen!
                self.tochange!.tableView.reloadData()
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_: UIAlertAction!) in
            self.accentChosen = nil
            self.titleLabel.textColor = ColorUtil.baseAccent
        })

        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .popover
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = selectedTableView
            presenter.sourceRect = selectedTableView.bounds
        }

        present(alertController, animated: true, completion: nil)
    }

    public func createCell(_ cell: UITableViewCell, _ switchV: UISwitch? = nil, isOn: Bool, text: String) {
        cell.textLabel?.text = text
        cell.textLabel?.textColor = ColorUtil.fontColor
        cell.backgroundColor = ColorUtil.foregroundColor
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        if let s = switchV {
            s.isOn = isOn
            s.addTarget(self, action: #selector(SettingsLayout.switchIsChanged(_:)), for: UIControlEvents.valueChanged)
            cell.accessoryView = s
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBaseBarColors()
    }

    override func loadView() {
        super.loadView()
        setupBaseBarColors()

        self.view.backgroundColor = ColorUtil.backgroundColor
        // set the title
        self.title = "Edit theme"
        self.tableView.separatorStyle = .none

        self.primary.textLabel?.text = "Primary color"
        self.primary.accessoryType = .none
        self.primary.backgroundColor = ColorUtil.foregroundColor
        self.primary.textLabel?.textColor = ColorUtil.fontColor
        self.primary.imageView?.image = UIImage.init(named: "palette")?.toolbarIcon().withRenderingMode(.alwaysTemplate)
        self.primary.imageView?.tintColor = ColorUtil.fontColor

        self.accent.textLabel?.text = "Accent color"
        self.accent.accessoryType = .none
        self.accent.backgroundColor = ColorUtil.foregroundColor
        self.accent.textLabel?.textColor = ColorUtil.fontColor
        self.accent.imageView?.image = UIImage.init(named: "accent")?.toolbarIcon().withRenderingMode(.alwaysTemplate)
        self.accent.imageView?.tintColor = ColorUtil.fontColor

        self.base.textLabel?.text = "Base theme"
        self.base.accessoryType = .none
        self.base.backgroundColor = ColorUtil.foregroundColor
        self.base.textLabel?.textColor = ColorUtil.fontColor
        self.base.imageView?.image = UIImage.init(named: "colors")?.toolbarIcon().withRenderingMode(.alwaysTemplate)
        self.base.imageView?.tintColor = ColorUtil.fontColor

        self.night.textLabel?.text = "Night theme"
        self.night.accessoryType = .none
        self.night.backgroundColor = ColorUtil.foregroundColor
        self.night.textLabel?.textColor = ColorUtil.fontColor
        self.night.imageView?.image = UIImage.init(named: "night")?.toolbarIcon().withRenderingMode(.alwaysTemplate)
        self.night.imageView?.tintColor = ColorUtil.fontColor

        tintOutsideSwitch = UISwitch()
        tintOutsideSwitch.isOn = SettingValues.onlyTintOutside
        tintOutsideSwitch.addTarget(self, action: #selector(SettingsTheme.switchIsChanged(_:)), for: UIControlEvents.valueChanged)
        self.tintOutside.textLabel?.text = "Only tint outside of subreddit"
        self.tintOutside.accessoryView = tintOutsideSwitch
        self.tintOutside.backgroundColor = ColorUtil.foregroundColor
        self.tintOutside.textLabel?.textColor = ColorUtil.fontColor
        tintOutside.selectionStyle = UITableViewCellSelectionStyle.none

        self.tintingMode.textLabel?.text = "Subreddit tinting mode"
        self.tintingMode.detailTextLabel?.text = SettingValues.tintingMode
        self.tintingMode.backgroundColor = ColorUtil.foregroundColor
        self.tintingMode.textLabel?.textColor = ColorUtil.fontColor
        self.tintingMode.detailTextLabel?.textColor = ColorUtil.fontColor
        
        createCell(reduceColor, reduceColorSwitch, isOn: SettingValues.reduceColor, text: "Reduce color throughout app (affects all navigation bars)")

        self.tableView.tableFooterView = UIView()
        
        let button = UIButtonWithContext.init(type: .custom)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.setImage(UIImage.init(named: "back")!.navIcon(), for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        let barButton = UIBarButtonItem.init(customView: button)
        
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc public func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    func switchIsChanged(_ changed: UISwitch) {
        if changed == reduceColorSwitch {
            MainViewController.needsRestart = true
            SettingValues.reduceColor = changed.isOn
            UserDefaults.standard.set(changed.isOn, forKey: SettingValues.pref_reduceColor)
        } else if changed == tintOutsideSwitch {
            SettingValues.onlyTintOutside = changed.isOn
            UserDefaults.standard.set(changed.isOn, forKey: SettingValues.pref_onlyTintOutside)
        } else {
            SettingValues.nightModeEnabled = changed.isOn
            UserDefaults.standard.set(changed.isOn, forKey: SettingValues.pref_nightMode)
            _ = ColorUtil.doInit()
            self.loadView()
            self.tableView.reloadData(with: .automatic)
            self.tochange!.doCells()
            self.tochange!.tableView.reloadData()
        }
        loadView()
        tableView.reloadData()
        UserDefaults.standard.synchronize()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }

    override func viewWillDisappear(_ animated: Bool) {
        SubredditReorderViewController.changed = true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return self.primary
            case 1: return self.accent
            case 2: return self.base
            case 3: return self.night
            case 4: return self.reduceColor
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch indexPath.row {
            case 0: return self.tintingMode
            case 1: return self.tintOutside
            default: fatalError("Unknown row in section 1")
            }
        default: fatalError("Unknown section")
        }

    }

    var selectedTableView = UIView()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTableView = tableView.cellForRow(at: indexPath)!.contentView
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            pickTheme()
        } else if indexPath.section == 0 && indexPath.row == 1 {
            pickAccent()
        } else if indexPath.section == 0 && indexPath.row == 2 {
            showBaseTheme()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            //tintmode
        } else if indexPath.section == 0 && indexPath.row == 3 {
            if !VCPresenter.proDialogShown(feature: false, self) {
                showNightTheme()
            }
        }
    }

    func getHourOffset(base: Int) -> Int {
        if base == 0 {
            return 12
        }
        return base
    }

    func getMinuteString(base: Int) -> String {
        return String.init(format: "%02d", arguments: [base])
    }

    func selectTime() {
        let alert = UIAlertController(style: .actionSheet, title: "Select night hours", message: "Select a PM time and an AM time")

        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { _ -> Void in
            _ = ColorUtil.doInit()
            self.loadView()
            self.tableView.reloadData(with: .automatic)
            self.tochange!.doCells()
            self.tochange!.tableView.reloadData()
        }
        alert.addAction(cancelActionButton)

        var values: [[String]] = [[], [], [], [], [], []]
        for i in 0...11 {
            values[0].append("\(getHourOffset(base: i))")
            values[3].append("\(getHourOffset(base: i))")
        }
        for i in 0...59 {
            if i % 5 == 0 {
                values[1].append(getMinuteString(base: i))
                values[4].append(getMinuteString(base: i))
            }
        }
        values[2].append("PM")
        values[5].append("AM")

        var initialSelection: [PickerViewViewController.Index] = []
        initialSelection.append((0, SettingValues.nightStart))
        initialSelection.append((1, SettingValues.nightStartMin / 5))
        initialSelection.append((3, SettingValues.nightEnd))
        initialSelection.append((4, SettingValues.nightEndMin / 5))

        alert.addPickerView(values: values, initialSelection: initialSelection) { _, _, index, _ in
            switch index.column {
            case 0:
                SettingValues.nightStart = index.row
                UserDefaults.standard.set(SettingValues.nightStart, forKey: SettingValues.pref_nightStartH)
                UserDefaults.standard.synchronize()
            case 1:
                SettingValues.nightStartMin = index.row * 5
                UserDefaults.standard.set(SettingValues.nightStartMin, forKey: SettingValues.pref_nightStartM)
                UserDefaults.standard.synchronize()
            case 3:
                SettingValues.nightEnd = index.row
                UserDefaults.standard.set(SettingValues.nightEnd, forKey: SettingValues.pref_nightEndH)
                UserDefaults.standard.synchronize()
            case 4:
                SettingValues.nightEndMin = index.row * 5
                UserDefaults.standard.set(SettingValues.nightEndMin, forKey: SettingValues.pref_nightEndM)
                UserDefaults.standard.synchronize()
            default: break
            }
        }

        alert.modalPresentationStyle = .popover
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = selectedTableView
            presenter.sourceRect = selectedTableView.bounds
        }

        self.present(alert, animated: true, completion: nil)
    }

    func selectTheme() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Select a night theme", message: "", preferredStyle: .actionSheet)

        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)

        for theme in ColorUtil.Theme.cases {
            if theme != .LIGHT && theme != .MINT && theme != .CREAM {
                let saveActionButton: UIAlertAction = UIAlertAction(title: theme.displayName, style: .default) { _ -> Void in
                    SettingValues.nightTheme = theme
                    UserDefaults.standard.set(theme.rawValue, forKey: SettingValues.pref_nightTheme)
                    UserDefaults.standard.synchronize()
                    _ = ColorUtil.doInit()
                    self.loadView()
                    self.tableView.reloadData(with: .automatic)
                    self.tochange!.doCells()
                    self.tochange!.tableView.reloadData()
                }
                actionSheetController.addAction(saveActionButton)
            }
        }
        actionSheetController.modalPresentationStyle = .popover
        if let presenter = actionSheetController.popoverPresentationController {
            presenter.sourceView = selectedTableView
            presenter.sourceRect = selectedTableView.bounds
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }

    func showNightTheme() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Night Mode", message: "", preferredStyle: .actionSheet)

        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { _ -> Void in
        }
        actionSheetController.addAction(cancelActionButton)

        let enabled = UISwitch.init(frame: CGRect.init(x: 20, y: 20, width: 75, height: 50))
        enabled.isOn = SettingValues.nightModeEnabled
        enabled.addTarget(self, action: #selector(SettingsTheme.switchIsChanged(_:)), for: UIControlEvents.valueChanged)
        actionSheetController.view.addSubview(enabled)

        var button: UIAlertAction = UIAlertAction(title: "Select night hours", style: .default) { _ -> Void in
            self.selectTime()
        }
        actionSheetController.addAction(button)

        button = UIAlertAction(title: "Select night theme", style: .default) { _ -> Void in
            self.selectTheme()
        }
        actionSheetController.addAction(button)

        actionSheetController.modalPresentationStyle = .popover
        if let presenter = actionSheetController.popoverPresentationController {
            presenter.sourceView = selectedTableView
            presenter.sourceRect = selectedTableView.bounds
        }

        self.present(actionSheetController, animated: true, completion: nil)

    }

    func showBaseTheme() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Select a base theme", message: "", preferredStyle: .actionSheet)

        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)

        for theme in ColorUtil.Theme.cases {
            if !SettingValues.isPro && (theme == ColorUtil.Theme.SEPIA || theme == ColorUtil.Theme.DEEP) {
                actionSheetController.addAction(image: UIImage.init(named: "support")?.menuIcon().getCopy(withColor: GMColor.red500Color()), title: theme.rawValue + " (pro)", color: GMColor.red500Color(), style: .default, isEnabled: true) { (_) in
                    _ = VCPresenter.proDialogShown(feature: false, self)
                }
            } else {
                let saveActionButton: UIAlertAction = UIAlertAction(title: theme.displayName, style: .default) { _ -> Void in
                    UserDefaults.standard.set(theme.rawValue, forKey: "theme")
                    UserDefaults.standard.synchronize()
                    _ = ColorUtil.doInit()
                    SubredditReorderViewController.changed = true
                    self.loadView()
                    self.tableView.reloadData(with: .automatic)
                    self.tochange!.doCells()
                    self.tochange!.tableView.reloadData()
                    MainViewController.needsRestart = true
                }
                actionSheetController.addAction(saveActionButton)
            }
        }
        actionSheetController.modalPresentationStyle = .popover
        if let presenter = actionSheetController.popoverPresentationController {
            presenter.sourceView = selectedTableView
            presenter.sourceRect = selectedTableView.bounds
        }

        self.present(actionSheetController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        titleLabel = UILabel()
        titleLabel.textColor = ColorUtil.baseAccent
        titleLabel.font = FontGenerator.boldFontOfSize(size: 20, submission: true)
        let toReturn = titleLabel.withPadding(padding: UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 0))
        toReturn.backgroundColor = ColorUtil.backgroundColor

        switch section {
        case 0: titleLabel.text = "App theme"
        case 1: titleLabel.text = "Tinting"
        default: titleLabel.text = ""
        }
        return toReturn
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return 2
        default: fatalError("Unknown number of sections")
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
