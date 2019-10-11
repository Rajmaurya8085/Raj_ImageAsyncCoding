//
//  ViewController.swift
//  Raj_HikeCoding
//
//  Created by Interview on 03/08/19.
//  Copyright © 2019 Interview. All rights reserved.
//

import UIKit


var baseURL = "https://farm"

class ViewController:UITableViewController {
    var  photoDataModel:Photos?
    
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 500.0

        // Remove separator line from UITableView
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeApiCall(page: 1, query: "rose")
    }

    
    func makeApiCall(page:Int, query:String){
//        if !activityLoader.isAnimating{
//        self.activityLoader.isHidden  = false
//        activityLoader.startAnimating()
        ApiManager.makeApiCall(query:query, page: page) {[weak self] (resultedData) in
          
            
            if resultedData.page == 1 || self?.photoDataModel == nil {
            self?.photoDataModel = resultedData
            }else{
                    if self?.photoDataModel?.photo != nil{
                    self?.photoDataModel?.photo = (self?.photoDataModel?.photo)! + resultedData.photo
                    }
                }
              DispatchQueue.main.async {
//                self?.activityLoader.stopAnimating()
//                self?.activityLoader.isHidden  = true
//
                self?.tableView.reloadData()
            }
            }
        }
        }
    
//}



extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photoDataModel?.photo.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:DisplayTabelViewCell  = .dequeueResuableCell(from: tableView, at: indexPath)
          
         
       // cell.tableView  = tableView
//        guard   let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayTabelViewCell", for: indexPath) as? DisplayTabelViewCell else{
//            return UITableViewCell()}
        
        guard  let dataModel = photoDataModel?.photo[indexPath.row] else{return cell}
        cell.product = dataModel
        // cell.setDisplayData(dataModel: dataModel)
       // cell.titleLbl.text = dataModel.title
//        cell.displayImageView?.downloaded(from: dataModel.imageUrl!, complitionHandler: { [weak self](image) in
//            DispatchQueue.main.async {
//                UIView.setAnimationsEnabled(false)
//            self?.tableView.beginUpdates()
//
//let screen_width = UIScreen.main.bounds.width
//                let ratio =  image.size.height / image.size.width
               // print(image.size.height / image.size.width)
//                // Calculated Height for the picture
//                let newHeight = screen_width * ratio
//                cell.heightConstraint.constant = newHeight
//                 cell.displayImageView.image = image
//            self?.tableView.endUpdates()
//
//                UIView.setAnimationsEnabled(true)
//            }
//        })
//
//        if indexPath.row == (photoDataModel?.photo.count)! - 5 { // last cell
//            if (photoDataModel?.pages)! > (photoDataModel?.page)! { // more items to fetch
//               // makeApiCall(page:(photoDataModel?.page)! + 1, query: "") // increment `fromIndex` by 20 before server call
//            }
//        }
//
//
//        cell.setNeedsUpdateConstraints()
//        cell.updateConstraintsIfNeeded()
//        cell.sizeToFit()
       return cell
  }
}

extension ViewController :UISearchBarDelegate{

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        makeApiCall(page:1, query: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        makeApiCall(page:1, query: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}





class DisplayTabelViewCell:UITableViewCell{
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    weak var tableView:UITableView?
    
   var product: DataModel?
     {
       didSet { display(product) }
     }
     
     static let cellIdentifier = String(describing: DisplayTabelViewCell.self)
     
     static func dequeueResuableCell<T: UITableViewCell>(from tableView: UITableView, at indexPath: IndexPath) -> T
     {
       let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
       return cell as? T ?? T(style: .default, reuseIdentifier: cellIdentifier)
     }

     private var generation = 0
     override func prepareForReuse()
     {
       super.prepareForReuse()
       titleLbl.text = nil
       tableView = nil
       displayImageView.image = nil
       generation += 1
     }
     
     override func didMoveToSuperview() {
       super.didMoveToSuperview()
       display(product)
     }

     private func display(_ product: DataModel?)
     {
       guard let product = product else { return }
        titleLbl.text = product.title
        
      
       guard let imageURL = product.imageUrl else { return }
       let currentGeneration = generation
       loadImage(from: imageURL) {[weak self] (image) in
         guard currentGeneration == self?.generation else { return }
//         UIView.setAnimationsEnabled(false)
      //  self?.tableView?.beginUpdates()

          let screen_width = UIScreen.main.bounds.width
          let ratio =  image.size.height / image.size.width
          let newHeight = screen_width * ratio
         self?.heightConstraint.constant = newHeight
         self?.displayImageView.image = image
      //  self?.tableView?.endUpdates()
//         UIView.setAnimationsEnabled(false)
       }
       
     }
   }

    
   
let imageSession = URLSession(configuration: .ephemeral)

let cache = NSCache<NSURL, UIImage>()

func loadImage(from url: URL, completion: @escaping (UIImage) -> Void)
{
  if let image = cache.object(forKey: url as NSURL)
  {
    completion(image)
  }
  else
  {
    let task = imageSession.dataTask(with: url) { (imageData, _, _) in
      guard let imageData = imageData,
      let image = UIImage(data: imageData)
      else { return }
      
      cache.setObject(image, forKey: url as NSURL)
      DispatchQueue.main.async {
        completion(image)
      }
      
    }
    task.resume()
  }
}
