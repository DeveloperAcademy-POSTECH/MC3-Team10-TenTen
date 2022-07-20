//
//  HeavenLetterListTableViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/20.
//

import UIKit

class HeavenLetterListTableViewController: UITableViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    var letters: [Letter]?
    var titleButton = UIButton(type: .custom)
    var monthPickerView = UIPickerView()
    var toolBar = UIToolbar()
    let yearList = ["2003년", "2004년", "2005년", "2006년", "2007년", "2008년", "2009년", "2010년", "2011년", "2012년", "2013년", "2014년", "2015년", "2016년", "2017년", "2018년", "2019년", "2020년", "2021년", "2022년"]
    let monthList = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    var selectedYear = ""
    var selectedMonth = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let currentDate = Date()
        var formatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 M월"
            return formatter
        }
        let yearAndMonth = formatter.string(from: currentDate).components(separatedBy: " ")
        selectedYear = yearAndMonth[0]
        selectedMonth = yearAndMonth[1]

        loadLetters(year: selectedYear, month: selectedMonth)
        setTitleButton(title: selectedMonth)
    }

    func setTitleButton(title: String) {
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

    func loadLetters(year: String, month: String) {
        letters = mockLetters.filter {
            $0.year == year && $0.month == month
        }.sorted { $0.year == $1.year ? $0.month < $1.month : $0.year < $1.year }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return letters?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Letter", for: indexPath)

        if let letter = letters?[indexPath.row] {
            cell.textLabel?.text = letter.title
        } else {
            cell.textLabel?.text = "No letter."
        }

        return cell
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as? LetterDetailViewController
//
//        if let indexPath = tableView.indexPathForSelectedRow {
//            destinationVC.selectedLetter = letters?[indexPath.row]
//        }
//    }
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

        print("\(selectedYear) \(selectedMonth) selected!")
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
        loadLetters(year: selectedYear, month: selectedMonth)
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

// MARK: - Letter Model
struct Letter {
    var title: String
    var content: String
    var year: String
    var month: String
}

var mockLetters: [Letter] = [
    Letter(title: "1번", content: "1번 편지 내용입니다.", year: "2000년", month: "1월"),
    Letter(title: "2번", content: "2번 편지 내용입니다.", year: "2001년", month: "2월"),
    Letter(title: "3번", content: "3번 편지 내용입니다.", year: "2002년", month: "3월"),
    Letter(title: "4번", content: "4번 편지 내용입니다.", year: "2003년", month: "4월"),
    Letter(title: "5번", content: "5번 편지 내용입니다.", year: "2004년", month: "5월"),
    Letter(title: "6번", content: "6번 편지 내용입니다.", year: "2005년", month: "6월"),
    Letter(title: "7번", content: "7번 편지 내용입니다.", year: "2006년", month: "7월"),
    Letter(title: "8번", content: "8번 편지 내용입니다.", year: "2007년", month: "8월"),
    Letter(title: "9번", content: "9번 편지 내용입니다.", year: "2008년", month: "9월"),
    Letter(title: "10번", content: "10번 편지 내용입니다.", year: "2022년", month: "7월")
]
