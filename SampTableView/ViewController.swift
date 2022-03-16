//
//  ViewController.swift
//  SampTableView
//
//  Created by Gayathri on 15/03/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var tableArr : [[String : Any]] = []
    let tableView: UITableView = UITableView()
    var fromMoreBtn = Bool()
    var activityIndicator:UIActivityIndicatorView!
    var lmButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromMoreBtn = false
        
        // set TableView
        tableView.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width - 10, height: self.view.frame.size.height-10)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentTableViewCell")
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        // set LoadMoreButton
        lmButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: 40)))
        lmButton.setTitle("Load more", for: .normal)
        lmButton.backgroundColor = .lightGray
        lmButton.addTarget(self, action: #selector(moreButtonClicked(_:)), for: .touchUpInside)
            self.tableView.tableFooterView = lmButton
        lmButton.isHidden = true
        
        // set Indicator
        self.activityIndicator = UIActivityIndicatorView(frame:CGRect(x: 100, y: 100, width: 100, height: 100)) as UIActivityIndicatorView
        self.activityIndicator.style = UIActivityIndicatorView.Style.medium
        self.activityIndicator.color = .gray
        self.activityIndicator.center = self.view.center;
        self.view.addSubview(activityIndicator);
        self.activityIndicator.startAnimating();

        self.getValues(urlstring: "https://api.themoviedb.org/3/movie/top_rated?api_key=ec01f8c2eb6ac402f2ca026dc2d9b8fd")

        
    }
    
    // MARK: TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as! ContentTableViewCell
        cell.idLbl!.text = "Id: \(tableArr[indexPath.row]["id"] ?? 00)"
        cell.langLbl!.text = "Original Language: \(tableArr[indexPath.row]["original_language"] ?? "en")"
        cell.popularityLbl!.text = "Popularity: \(tableArr[indexPath.row]["popularity"] ?? 00)"
        cell.titleLbl!.text = "Title: \(tableArr[indexPath.row]["title"] ?? "EndGame")" 
        return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: Service Call

    func getValues(urlstring  : String){

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
          activityIndicator.stopAnimating()
          activityIndicator.isHidden = true
       
        AF.request(urlstring).responseString { response in
            
            do {
                let dict = try JSONSerialization.jsonObject(with: response.data!) as? Dictionary<String, AnyObject>
                if(self.fromMoreBtn == false){
                self.tableArr = dict?["results"] as! [[String : Any]]
                self.lmButton.isHidden = false
                }
                else{
                let newAr = dict?["results"] as! [[String : Any]]
                self.tableArr.append(contentsOf: newAr as [[String : Any]])
                self.lmButton.isHidden = true
                }
                print(self.tableArr[0])
                self.tableView.reloadData()

               } catch {
                   print("Exception occured \(error))")
               }
            
            }
        }
    }

    // MARK: Button Action

    @objc func moreButtonClicked(_ sender: UIButton) {
        self.activityIndicator.startAnimating();
        
        fromMoreBtn = true
        self.getValues(urlstring: "https://api.themoviedb.org/3/movie/top_rated?api_key=ec01f8c2eb6ac402f2ca026dc2d9b8fd&page=2")
    }
}

