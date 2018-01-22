//
//  FirstViewController.swift
//  MovieSearchApp
//
//  Created by Sun&KK on 10/7/17.
//  Copyright © 2017 Washtinton University in St. Louis. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var introductionLabel: UILabel!
    var firstSearch: Int = 1
    var beforeCancelSearchText : String = "" //for Search bar cancel button use
    var tempSearchText: String = ""
    var theMovies: [Movie] = [] // store different movies objects
    var theImageCache: [UIImage] = [] // cache all the images of searching results
    var detailViewController: DetailViewController? = nil
    var theMovieDB = "https://api.themoviedb.org/3/movie/550?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var activityIndicator: UIActivityIndicatorView! //A view that shows that a task is in progress.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //test
        //let url = "https://api.themoviedb.org/3/search/movie?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a&language=en-US&query=star%20wars&page=2&include_adult=false"
        
        //setup processing indicator
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.isHidden = true
        activityIndicator.color = UIColor.cyan
        //activityIndicator.startAnimating()
        
        //setup CollectionView for movies
        self.setupCollectionView()
        //set searchBar delegate
        searchBar.delegate = self
    }
    //********      setup CollectionView       ********
    func setupCollectionView() {
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        //register collectionViewCell
        //moviesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
    }
    
    func updateMainView(){
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
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
    
    //********      fetch data from url for collectionView       ********
    func fetchDataCollectionView(_ url: String) {
        
        //test
        //let json = getJSON("https://research.engineering.wustl.edu/~todd/studio.json")
        //let movieTitle: String = "star%20wars"
        //let json = getJSON("https://api.themoviedb.org/3/search/movie?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a&language=en-US&query=star%20wars&page=2&include_adult=false")
        
        if(url == "")
        {
            return
        }
        let json = getJSON(url)
        let results = json.dictionaryValue
        let resultsJson = results["results"]
        
        //get relevant data
        for result in (resultsJson?.arrayValue)! {
            
            let title = result["title"].stringValue
            let overview = result["overview"].stringValue
            var url: String = ""
            let id = result["id"].intValue
            if(result["poster_path"].string != nil)
            {
                url = "https://image.tmdb.org/t/p/w500" + result["poster_path"].stringValue
            }
            print(url)
            
            //create movie object and append to theMovies
            theMovies.append(Movie(title: title, image_url: url, id: id, description: overview))
        }
        //test
        print("the data is \(theMovies)")
    }
    
    //********      cache Images        *********
    func cacheImages() {
        for movie in theMovies {
                let url = URL(string: movie.image_url)
                if(url != nil)
                {
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    theImageCache.append(image!)
                }
                else
                {
                    theImageCache.append(UIImage(named: "poster-not-available")!)
                }
        }
        print("cacheImages finish")
    }
    
    //********     relevant operation on CollectionView      ********s
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if theMovies.count==0 {
            introductionLabel.alpha = 1
        }
        else {
            introductionLabel.alpha = 0
        }
        return theMovies.count
    }
    
    //******  this method is modified based on directions from google    ******
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = theMovies[indexPath.row]
        
        cell.movieTitle.text = movie.title
        cell.movieTitle.numberOfLines = 2
        cell.movieTitle.textAlignment = NSTextAlignment.center
        
        if (movie.image_url == "") || (theImageCache.count == 0) {
            cell.moviePoster.image = UIImage(named: "poster-not-available")!
           return cell
        }
        if(indexPath.row < theImageCache.count) {
            cell.moviePoster.image = theImageCache[indexPath.row]
        }
        return cell
    }
    
    //go to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("$$$$$$$$$$  going to detail  $$$$$$$$")
        let  detailVC: DetailViewController = (segue.destination as? DetailViewController)!
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.moviesCollectionView.indexPath(for: sender as! UICollectionViewCell){
                print("****** indexPath.row = \(indexPath.row)")
                let movie = theMovies[indexPath.row]
                print(movie.title + "*******")
                detailVC.detailMovie = movie
                //print((detailVC.detailMovie?.title)! + "*******")
                detailVC.image = theImageCache[indexPath.row]
            }
        }
    }
    
    //Search cancel function, can go back to formal search result
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //  self.theMovies.removeAll()
    //  self.theImageCache.removeAll()
        searchBar.resignFirstResponder()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchBar.text = beforeCancelSearchText
        if(searchBar.text == ""){
            self.theMovies.removeAll()
            self.theImageCache.removeAll()
            self.moviesCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
            return
        }
        
        var searchText = searchBar.text!
        //clear all theMovies and theImageCache
        self.theMovies.removeAll()
        self.theImageCache.removeAll()
        self.moviesCollectionView.reloadData()
        searchText = searchText.replacingOccurrences(of: " ", with: "%20")
        //to test whether this search can find movie or not, if not, tell user
        let url1 = "https://api.themoviedb.org/3/search/movie?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a&language=en-US&query=" + searchText + "&page=1&include_adult=false"
        fetchDataCollectionView(url1)
        //if movies can not be found, tell user using alert
        if(theMovies.count == 0)
        {
            print("Movies not found")
            let alert = UIAlertController(title: "Movies not found...Please input another title", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yeah, I know, Close this", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
            return
        }
        //display process indicator
        
        //get first two pages of searching results, at most 40 movies
        let url2 = "https://api.themoviedb.org/3/search/movie?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a&language=en-US&query=" + searchText + "&page=2&include_adult=false"
        self.fetchDataCollectionView(url2)
        DispatchQueue.global().async {
            self.cacheImages()
            
            DispatchQueue.main.async {
                print("Q1: reloadData begin")
                self.moviesCollectionView.reloadData()
                print("Q1: reloadData end")
                self.activityIndicator.stopAnimating()
                print("process indicator stop")
            }
            
             self.updateMainView()
        }
//        DispatchQueue.global().async {
//            print("Q2: reloadData begin")
//            self.moviesCollectionView.reloadData()
//            print("Q2: reloadData end")
//            self.updateMainView()
//        }
        print("search finish")
        
        //exchange tempSearchText and beforeCancelSearchText
//        beforeCancelSearchText = tempSearchText
//        print(beforeCancelSearchText)
//        tempSearchText = searchText
//        print(tempSearchText)
       
    }
    
    //后期可以加入高级搜索，设置几个textField 然后设置一个search button 当用户输入完后点击search 然后传值几个textfield生成的url到MoviesViewController 产生搜索结果并显示
    
    //when searchBar is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if searchBar.text == "" {
            activityIndicator.stopAnimating()
            return
        }
        
        //clear all theMovies and theImageCache
        self.theMovies.removeAll()
        self.theImageCache.removeAll()
        self.moviesCollectionView.reloadData()
        //transfer searchText to the string that can be used in URL of themoviedb
        var searchText = searchBar.text!
        //save last time search data
        if(firstSearch == 1)
        {
            tempSearchText = searchText
            print(tempSearchText)
            firstSearch = 0
        }
        else
        {
            beforeCancelSearchText = tempSearchText
            print(beforeCancelSearchText)
            tempSearchText = searchText
            print(tempSearchText)
        }
        searchText = searchText.replacingOccurrences(of: " ", with: "%20")
        
        
        //to test whether this search can find movie or not, if not, tell user
        let url1 = "https://api.themoviedb.org/3/search/movie?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a&language=en-US&query=" + searchText + "&page=1&include_adult=false"
        fetchDataCollectionView(url1)
        //if movies can not be found, tell user using alert
        if(theMovies.count == 0)
        {
            print("Movies not found")
            let alert = UIAlertController(title: "Movies not found...Please input another title", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yeah, I know, Close this", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
            return
        }
        //display process indicator
        
        //get first two pages of searching results, at most 40 movies
        let url2 = "https://api.themoviedb.org/3/search/movie?api_key=b1e6d6c3cd13a8f7654185879d7a8d1a&language=en-US&query=" + searchText + "&page=2&include_adult=false"
        self.fetchDataCollectionView(url2)
        
        DispatchQueue.global().async {
            self.cacheImages()
            
            DispatchQueue.main.async {
                print("Q1: reloadData begin")
                self.moviesCollectionView.reloadData()
                print("Q1: reloadData end")
                self.activityIndicator.stopAnimating()
                print("process indicator stop")
            }
        }
        self.updateMainView()
//        DispatchQueue.global().async {
//            print("Q2: reloadData begin")
//            self.moviesCollectionView.reloadData()
//            print("Q2: reloadData end")
//        }
//        print("search finish")
//        //request backgroud
//        let cacheImagesQueue = DispatchQueue(label:"high", qos: .default)
//        //let fetchDataQueue = DispatchQueue(label: "high", qos: .default)
//        //let collectionViewReloadQueue = DispatchQueue(label:"low", qos: .background)
////        fetchDataQueue.async {
////            self.fetchDataCollectionView(url2)
////            self.moviesCollectionView.reloadData()
////        }
//        cacheImagesQueue.async {
//            self.cacheImages()
//            self.moviesCollectionView.reloadData()
//            self.activityIndicator.stopAnimating()
//        }
//        collectionViewReloadQueue.sync {
//            self.moviesCollectionView.reloadData()
//        }
        //moviesCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//multithreading

//        DispatchQueue.global().async {
//            DispatchQueue.main.async {
//            }
//        }

//        DispatchQueue.global().sync {
//            self.cacheImages()
//            self.moviesCollectionView.reloadData()
//            self.activityIndicator.stopAnimating()
//        }
//        let queue2 = DispatchQueue(label:"low", qos: .background)
//        queue2.async {
//
//        }
//
//        DispatchQueue.global().async {
//
//        }

//        DispatchQueue.async(execute: )
//activityIndicator.stopAnimating()
//        activityIndicator.isHidden = true
//        print(searchText)
//        activityIndicator.isHidden = false


//$$$$$  when movies can not be found, the screen will appear an alert window telling user to input another moive title
//            if(self.theMovies.count == 0)
////            {
//            if(isJustStart != 1)
//            {
//                print("Movies not found")
//                let alert = UIAlertController(title: "Movies not found...Please input another title", message: nil, preferredStyle: .actionSheet)
//
//                alert.addAction(UIAlertAction(title: "Yeah, I know, Close this", style: .default, handler: { (action) in self.dismiss(animated: true, completion: nil)}))
//                self.present(alert, animated: true, completion: nil)
//
//                //            presentingViewController(alert, animated: true, completion: nil)
//            }
//            else{
//                isJustStart = 0
//            }

