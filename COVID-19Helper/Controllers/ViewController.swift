//
//  ViewController.swift
//  COVID-19Helper
//
//  Created by Sushree Swagatika on 22/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit
import Alamofire

enum CasesType:Int {
    case confirmed = 1
    case death
    case recovered
}


class ViewController: UIViewController {
    
    @IBOutlet var mapBarButtonItem: UIBarButtonItem!
    @IBOutlet var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet var tblDropDown: UITableView!
    @IBOutlet var btnCountry: UIButton!
    
    @IBOutlet var LabelsInStackView: [UILabel]!
    
    var selectedCountryCode = "IN"
    var selectedCountryName = "India"
    
    let base_URL = "https://coronavirus-tracker-api.herokuapp.com/v2"
    let all_location_key = "/locations"
    let location_India_key = "/locations?country_code=IN"
    
    var all_COVID_19_Data: Report?
    var selectedCountry_COVID_19_Data: Report?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // all data
        fetch_COVID_19_Data(withKey: all_location_key)
        
        // India data
        fetch_COVID_19_Data(withKey: location_India_key)
        
        tableSetup()
    }
    
    func refreshAllData() {
        fetch_COVID_19_Data(withKey: all_location_key)
    }
    
    func tableSetup() {
        self.tblDropDown.register(UITableViewCell.self, forCellReuseIdentifier: "dropdownCell")
        self.tblDropDown.isHidden = true
    }
    
    @IBAction func openMap(_ sender: UIBarButtonItem) {
        self.push(newVC: MapViewController.self)
    }
    
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        refreshAllData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.updateView()
        }
    }
    
    @IBAction func updateCountryData(_ sender: UIButton) {
        self.tblDropDown.isHidden = false
        self.tblDropDown.reloadData()
    }
    
    func fetch_COVID_19_Data(withKey key: String?) {
        let request = AF.request(base_URL+key!, method: .get)
        
        request.responseDecodable(of: Report.self) { (response) in
            guard let report = response.value else { return }
            if key == self.location_India_key {
                self.selectedCountry_COVID_19_Data = report
                let myReport: Covid19 = report.locations[0]
                
                debugPrint(myReport)
            }
            else {
                self.all_COVID_19_Data = report
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateView()
            }
            
        }
        
    }
    
    func updateView() {
        let latestData_All = self.all_COVID_19_Data?.latest_cases
        let latestData_SelectedCountry = self.selectedCountry_COVID_19_Data?.latest_cases
        for label in LabelsInStackView {
            let caseType = CasesType(rawValue: label.tag)
            var text = ""
            switch caseType {
            case .confirmed:
                let confirmedAll = latestData_All?.confirmed!
                let confirmedSelected = latestData_SelectedCountry?.confirmed!
                text = " World :: \(confirmedAll!)\t"+"\(selectedCountryName) :: \(confirmedSelected!)"
            case .death:
                let deathAll = latestData_All?.deaths!
                let deathSelected = latestData_SelectedCountry?.deaths!
                text = "World :: \(deathAll!)\t"+"\(selectedCountryName) :: \(deathSelected!)"
            case .recovered:
                let recoveredAll = latestData_All?.recovered!
                let recoveredSelected = latestData_SelectedCountry?.recovered!
                text = "World :: \(recoveredAll!)\t"+"\(selectedCountryName) :: \(recoveredSelected!)"
            default:
                debugPrint("")
            }
            if latestData_All != nil && latestData_SelectedCountry != nil {
                label.text = text
            }
        }
        
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return all_COVID_19_Data?.locations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dropdownCell")
        
        let eachLocationReport = all_COVID_19_Data!.locations[indexPath.row]
        cell.textLabel?.text = eachLocationReport.country + " (" + eachLocationReport.country_code + ")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eachLocationReport = all_COVID_19_Data!.locations[indexPath.row]
        
        self.selectedCountryName = eachLocationReport.country
        self.selectedCountryCode = eachLocationReport.country_code
        
        let newTitle = self.selectedCountryName + " ( \(self.selectedCountryCode) )"
        btnCountry.setTitle(newTitle, for: .normal)
        
        self.tblDropDown.isHidden = true
        self.updateView()
    }
}
