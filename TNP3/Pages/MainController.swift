//
//  MainController.swift
//  TNP3
//
//  Created by alisher toleberdyyev on 10/28/18.
//  Copyright © 2018 alisher toleberdyyev. All rights reserved.
//

import Foundation
import SideMenu
import UIKit
import GoogleMaps
import SnapKit

struct menuItem {
    var icon_name:String!
    var title: String!
    var vw: UIViewController?
}

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sidemenuToggled:Bool = false
    var menuBtn: UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tintColor = UIColor.blueDefault
        btn.setImage(UIImage(named: "menu"), for: .normal)
        btn.backgroundColor = UIColor.white
        btn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn.addTarget(self, action: #selector(toggleSidemenu), for: .touchUpInside)
        return btn
    }()
    
    let WrapperView:UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()
    
    var sideMenuTable: UITableView = UITableView(frame: CGRect.zero)
    private let myArray: NSArray =  [
        menuItem(icon_name: "menu", title: "Profile", vw: ProfileViewController()),
        menuItem(icon_name: "menu", title: "Find Parking", vw: nil),
        menuItem(icon_name: "menu", title: "Report Parking", vw: nil),
        menuItem(icon_name: "menu", title: "Logout", vw: nil),
    ]

//=================================================== HOOKS =======================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "MAP"
        
        self.setupSideMenu()
        self.setupWrapper()
        self.setupGoogleMap()
        self.setupMenuBtn()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
//=================================================== SETUPS =======================

    func setupWrapper()  {
        self.view.addSubview(WrapperView)
        self.WrapperView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    func setupMenuBtn()  {
        self.WrapperView.addSubview(menuBtn)
        self.menuBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(self.WrapperView.snp.top).offset(50)
            make.left.equalTo(self.WrapperView.snp.left).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(60)
        })
        self.menuBtn.layer.cornerRadius = 30
    }
    
    func setupGoogleMap(){
        GMSServices.provideAPIKey("AIzaSyBjH-VxvPzeIERE_38UW4sXd5MrjQiN910")
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.WrapperView.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
           make.edges.equalTo(self.WrapperView)
        }
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func setupNavBar()  {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func setupSideMenu()  {
        self.view.addSubview(sideMenuTable)
        self.sideMenuTable.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        self.sideMenuTable.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.sideMenuTable.separatorStyle = .none
        self.sideMenuTable.dataSource = self
        self.sideMenuTable.delegate = self
    }
    
    //=================================================== TOGGLES =======================

    @objc func toggleSidemenu(sender: UIButton!) {
        let width = self.WrapperView.frame.width
        let height = self.WrapperView.frame.height
        if (self.sidemenuToggled) {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.WrapperView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
                self.WrapperView.frame = CGRect(x: 250, y: 0, width: width, height: height)
            }, completion: nil)
            self.view.setNeedsDisplay()
        }
        self.sidemenuToggled = !self.sidemenuToggled
        print(self.sidemenuToggled)
    }
    
    //=================================================== TABLE OVERIDES =======================

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        let item = (myArray[indexPath.row] as! menuItem).vw
        if (item != nil) {
            self.navigationController?.show(item as! UIViewController, sender: nil)
        }
        print("Value: \(myArray[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = (myArray[indexPath.row] as! menuItem).title
//        cell.menu_title.text = (myArray[indexPath.row] as! menuItem).title
//        cell.menu_icon.image = UIImage(named: (myArray[indexPath.row] as! menuItem).icon_name)
        return cell
    }
        
}


