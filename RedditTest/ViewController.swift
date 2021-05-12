//
//  ViewController.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 4/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView?
    
    private var viewControllerPresenter = ViewControllerPresenter()
    
    var topList = [TopModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewControllerPresenter.setDataViewDelegate(dataViewDelegate: self)
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topCellType", for: indexPath) as! PostCell
        
        cell.author?.text = topList[indexPath.row].author
        cell.created?.text = String(topList[indexPath.row].createdString)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: DataViewDelegate{
    func displayTopList(topList: [TopModel]) {
        if topList.count > 0{
            self.topList = topList
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
}

