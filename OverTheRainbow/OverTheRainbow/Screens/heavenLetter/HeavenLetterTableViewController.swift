//
//  HeavenLetterTableViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/26.
//

import UIKit

class HeavenLetterListTableViewController: UITableViewController {
    
    let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var letters = [LetterResultDto]()
    var titleButton = UIButton(type: .custom)
    var monthPickerView = UIPickerView()
    var toolBar = UIToolbar()
    let years = (2000...2030)
    var yearList = [String]()
    let monthList = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    var selectedYear = ""
    var selectedMonth = ""
    
    var stringDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for year in years {
            yearList.append("\(year)년")
        }
        let yearAndMonth = stringDate.components(separatedBy: " ")
        selectedYear = yearAndMonth[0]
        selectedMonth = yearAndMonth[1]

        // TODO: 현재 Pet의 ID UserDefaults에서 가져오기
        do {
            letters = try service.findSentLetters("62df7c5eedd840ec0d2c01c2", stringDate)
        } catch {
            print("Error finding sent letters : \(error)")
        }
        setTitleButton(title: selectedMonth)
    }

    private func setTitleButton(title: String) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.down")?.withTintColor(.black)
        let fullString = NSMutableAttributedString(string: "\(title) ")
        fullString.append(NSAttributedString(attachment: imageAttachment))

        titleButton.setAttributedTitle(fullString, for: .normal)
        titleButton.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.addTarget(self, action: #selector(self.chooseDate), for: .touchUpInside)

        navigationBar.title = title
        navigationBar.titleView = titleButton
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return letters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Letter", for: indexPath)
        if letters.count == 0 {
            cell.textLabel?.text = "No letter."
        } else {
            cell.textLabel?.text = letters[indexPath.row].title
        }
        return cell
    }
}

// MARK: - UIPicker
extension HeavenLetterListTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return yearList.count
        } else {
            return monthList.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return yearList[row]
        } else {
            return monthList[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = yearList[monthPickerView.selectedRow(inComponent: 0)]
        selectedMonth = monthList[monthPickerView.selectedRow(inComponent: 1)]
    }

    @objc func chooseDate() {
        titleButton.isEnabled = false

        monthPickerView = UIPickerView.init()
        monthPickerView.dataSource = self
        monthPickerView.delegate = self
        monthPickerView.contentMode = .center
        monthPickerView.backgroundColor = .systemGray6
        monthPickerView.selectRow(yearList.firstIndex(of: selectedYear)!, inComponent: 0, animated: true)
        monthPickerView.selectRow(monthList.firstIndex(of: selectedMonth)!, inComponent: 1, animated: true)

        self.view.addSubview(self.monthPickerView)

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let done = UIBarButtonItem()
        done.title = "확인"
        done.tintColor = .black
        done.style = .done
        done.target = self
        done.action = #selector(onDoneButtonTapped)
        toolBar = UIToolbar.init()

        monthPickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 1080, width: UIScreen.main.bounds.width, height: 250)

        UIView.animate(withDuration: 0.5) {
            self.monthPickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 850, width: UIScreen.main.bounds.width, height: 250)
            self.toolBar.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 600, width: UIScreen.main.bounds.size.width, height: 45)
        }

        toolBar.barTintColor = .systemGray6
        toolBar.isTranslucent = true
        toolBar.setItems([flexSpace, done, flexSpace], animated: true)
        self.view.addSubview(toolBar)
    }

    @objc func onDoneButtonTapped() {

        titleButton.isEnabled = true
        setTitleButton(title: selectedMonth)
        // TODO: 현재 Pet의 ID UserDefaults에서 가져오기
        do {
            letters = try service.findSentLetters("62df7c5eedd840ec0d2c01c2", "\(selectedYear) \(selectedMonth)")
        } catch {
            print("Error finding sent letters : \(error)")
        }
        tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.monthPickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 1200, width: UIScreen.main.bounds.width, height: 250)
            self.toolBar.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 1000, width: UIScreen.main.bounds.size.width, height: 45)
        } completion: { _ in
            self.toolBar.removeFromSuperview()
            self.monthPickerView.removeFromSuperview()
        }
    }
}
