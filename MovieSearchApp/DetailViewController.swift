//
//  DetailViewController.swift
//  MovieSearchApp
//
//  Created by Sun&KK on 10/7/17.
//  Copyright © 2017 Washtinton University in St. Louis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var movieTitle: UINavigationItem!
    
    //详细的movie信息 https://api.themoviedb.org/3/movie/12180?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a&language=en-US
    //12180为电影的id 可以根据id再搜索一遍 获取更多的信息
    
    //let plistPath = Bundle.main.path(forResource: "FavoritesList", ofType: "plist")
    var image: UIImage!
    //var name: String!
    var releaseDate: String!
    var score: Double!
    var genres: [String] = []
    var revenue: Int!
    var id : Int!
    
//    var tempDict: NSMutableDictionary?
    
    var favortieViewController : FavoriteViewController? = nil
    
    //detialMovie is used to store a selected movie, when detailMovie receive a new moive it will update the view
    var detailMovie: Movie? {
        didSet {
            // Update the view.
            self.prepare()
        }
    }
    //update the view()
    func prepare() {
        self.movieTitle.title = detailMovie?.title
        fetchDetail(id: (detailMovie?.id)!) //get detailed information about this movie
    }
    
    //addToFavorites
    @IBAction func addFavorites(_ sender: Any) {
        let path = Bundle.main.path(forResource: "FavoritesList", ofType: "plist")
        //get document directory
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array
        let docPath = directories[0] as String
        let plistPath = docPath.appending("FavoritesList.plist")
        //check the file existence
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: plistPath)){
            do{
                try fileManager.copyItem(atPath: path!, toPath: plistPath)
            }
            catch{
                print("copy failure")
            }
        }
        else{
            print("file already exist")
        }
        
        // write some data to plist at document directory
        let writeArray = NSMutableArray(contentsOfFile: plistPath)
        print("ready to write data")
        print(detailMovie!.title)
        for item in writeArray!{
            let name = item as! String
            if(name == detailMovie!.title){
                print("same movie")
                let alert = UIAlertController(title: "Movie has been added in Favorites", message: nil, preferredStyle: .actionSheet)

                alert.addAction(UIAlertAction(title: "Yeah, I know, Close this", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        writeArray?.add(detailMovie!.title)
        writeArray?.write(toFile: plistPath, atomically: true)
        print("finish data writing")
        //      let writeDict = NSMutableDictionary(contentsOfFile: path!)
        //      writeDict?.setValue("Star wars", forKey: "movie")
        //      writeDict?.write(toFile: plistPath, atomically: true)
        //write data to FavoritesList.plist
        
//        if let tempdict = writeDict {
//            print(tempdict.value(forKey: "movie") ?? "default movie")
//        }
//        let dict : AnyObject = NSDictionary(contentsOfFile: path!)!
//        dict.object(forKey: "Favorites") as! Array<String>).append("abc")
    }
    func fetchDetail(id: Int) {
        let json = getJSON("https://api.themoviedb.org/3/movie/" + String(id) + "?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a&language=en-US")
        print("&&&&& detailJSON  &&&&&S")
        if(json != JSON.null)
        {
            let results = json.dictionaryValue
            self.releaseDate = results["release_date"]?.stringValue
            print(self.releaseDate)
            self.score = results["vote_average"]?.doubleValue
            let genresRes = results["genres"]
            for oneGenres in (genresRes?.arrayValue)! {
                let name = oneGenres["name"].stringValue
                print(name)
                self.genres.append(name)
            }
            self.revenue = results["revenue"]?.intValue
        }
        else
        {
            print("Movies not found")
            let alert = UIAlertController(title: "Movies not found...Please input another title", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yeah, I know, Close this", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    //********      get JSON from url     ********
    private func getJSON(_ url:String) -> JSON {
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                let json = try? JSON(data: data)
                return json!
            } else {
                return JSON.null
            }
        } else {
            return JSON.null
        }
    }
    
    func updateView(){
        releaseDateLabel.text = "Release Date: " + self.releaseDate
        scoreLabel.text = scoreLabel.text! + ": " + String(self.score) + "/10.0"
        genresLabel.text = genresLabel.text! + ": " + self.genres[0]
        revenueLabel.text = revenueLabel.text! + ": " + String(self.revenue) + "$"
        if(image != nil)
        {
            self.poster.image = image!
        }
    }
    
    //go to Youtube view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("$$$$$$$$$$  going to Youtube  $$$$$$$$")
        let  youtubeVC: YoutubeViewController = (segue.destination as? YoutubeViewController)!
        
        if segue.identifier == "youtube" {
            youtubeVC.movieTitle = (detailMovie?.title)!
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
