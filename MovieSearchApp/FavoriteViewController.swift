//
//  SecondViewController.swift
//  MovieSearchApp
//
//  Created by Sun&KK on 10/7/17.
//  Copyright © 2017 Washtinton University in St. Louis. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: "favoriteMovie")
        myCell.textLabel!.text = favorites[indexPath.row]
        return myCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            favorites.remove(at: indexPath.row)
            let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array
            let docPath = directories[0] as String
            let plistPath = docPath.appending("FavoritesList.plist")
            let Array = NSMutableArray(contentsOfFile: plistPath)
            Array?.removeObject(at: indexPath.row)
            Array?.write(toFile: plistPath, atomically: true)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
        
    //go to youtube view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("$$$$$$$$$$  going to youtube  $$$$$$$$")
        let  youtubeVC: YoutubeViewController = (segue.destination as? YoutubeViewController)!
        
        if segue.identifier == "youtube" {
            if let indexPath = self.favoriteTableView.indexPath(for: sender as! UITableViewCell){
                print("****** indexPath.row = \(indexPath.row)")
                let movie = favorites[indexPath.row]
                youtubeVC.movieTitle = movie
                
            }
        }
    }
  
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var favorites: [String] = []
    var image_urls: [String] = []
    
    func loadDataFromPlist() {
        //let path = Bundle.main.path(forResource: "FavoritesList", ofType: "plist")
        //get document directory
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array
        let docPath = directories[0] as String
        let plistPath = docPath.appending("FavoritesList.plist")
//      let dict:AnyObject = NSDictionary(contentsOfFile: path!)!
        let array = NSMutableArray(contentsOfFile: plistPath)
//      let oneMovie = dict!.object(forKey: "movie") as! String
        
        favorites = array as! Array
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.dataSource = self
        favoriteTableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromPlist()
        favoriteTableView.reloadData()
    }
}

