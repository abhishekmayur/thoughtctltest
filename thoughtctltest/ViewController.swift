//
//  ViewController.swift
//  thoughtctltest
//
//  Created by Abhishek Dhamdhere on 10/09/23.
//

import UIKit
import Photos

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
   

    @IBOutlet weak var swicthbutton: UIBarButtonItem!
    @IBOutlet weak var imagescollectionview: UICollectionView!
    @IBOutlet weak var navigationcontroller: UINavigationItem!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var imagesTableView: UITableView!
    let imagePicker = UIImagePickerController()
    var images = [UIImage]()
    var allPhotos : PHFetchResult<PHAsset>? = nil
    var latestPhotoAssetsFetched: PHFetchResult<PHAsset>? = nil
    var switchview:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: register tableview cell
        self.imagesTableView.register(UINib.init(nibName: "ImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "ImagesTableViewCell")
        //MARK: register collection view cell
        self.imagescollectionview.register(UINib.init(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCollectionViewCell")
        self.imagesTableView.delegate = self
        self.imagesTableView.dataSource = self
        self.imagesTableView.reloadData()
        self.imagesTableView.tableFooterView = UIView()
        self.getPhotolibrary()
        self.getPhonePhotos()
        self.imagescollectionview.delegate = self
        self.imagescollectionview.dataSource = self
        self.imagescollectionview.reloadData()
    }
    
    // MARK: - search method
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count ?? 0 > 0
//        {
//           // self.allPhotos.removeAll()
//            self.getPhotolibrary()
//            self.getPhonePhotos()
//            self.imagesTableView.isHidden = true
//            self.imagesTableView.isHidden = false
//
//        }
//        else
//        {
//            DispatchQueue.main.async {
////                self.allPhotos.removeAll()
//                self.getPhotolibrary()
//                self.getPhonePhotos()
//                self.imagesTableView.isHidden = false
//                self.imagesTableView.isHidden = true
//                self.imagesTableView.reloadData()
//            }
//
//
//        }
//        filteredContacts = contact.filter {
//            $0.firstName.range(of: searchText,options : [NSString.CompareOptions.anchored, NSString.CompareOptions.caseInsensitive]) != nil ||
//                $0.telephone.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive ]) != nil ||
//             $0.lastName.range(of: searchText,options : [NSString.CompareOptions.anchored, NSString.CompareOptions.caseInsensitive]) != nil
//        }
//        searchTableView.reloadData()
//
//        print(filteredContacts)
//        //self.searchTableView.reloadData()
//
//    }
    //MARK: switch button action
    @IBAction func switchbuttonAction(_ sender: Any) {
        
        if switchview == false{
            self.imagesTableView.isHidden = true
            self.imagescollectionview.isHidden = false
            self.swicthbutton.title = "GRID"
            self.switchview = true
           
        }else{
            self.imagesTableView.isHidden = false
            self.imagescollectionview.isHidden = true
            self.swicthbutton.title = "LIST"
            self.switchview = false
           
        }
    }
    //MARK: Fetch latest photos
    func fetchLatestPhotos(forCount count: Int?) -> PHFetchResult<PHAsset> {
        
        // Create fetch options.
        let options = PHFetchOptions()
        
        // If count limit is specified.
        if let count = count { options.fetchLimit = count }
        
        // Add sortDescriptor so the lastest photos will be returned.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        options.sortDescriptors = [sortDescriptor]
        
        DispatchQueue.main.async {
            self.imagesTableView.reloadData()
            self.imagescollectionview.reloadData()
        }
        return PHAsset.fetchAssets(with: .image, options: options)
        
    }
    //MARK: fetch photolibrary
    func getPhotolibrary()
    {
        PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
            if(status == .authorized){
                self.getPhonePhotos()
            }else{
                //self.view.makeToast("Access Denied")
            }
        })
    }
    //MARK: fetch phone photos
    func getPhonePhotos()
    {
        let fetchOptions = PHFetchOptions()
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        print("Found number of:  \(allPhotos.count) images")
        self.allPhotos = allPhotos
        print(self.allPhotos!)
        self.latestPhotoAssetsFetched = self.fetchLatestPhotos(forCount:self.allPhotos?.count)
       // setFirstAssetImage()
        DispatchQueue.main.async {
            self.imagesTableView.reloadData()
            self.imagescollectionview.reloadData()
        }
        
    }
    //MARK: table view Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 228
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPhotos?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.imagesTableView.dequeueReusableCell(withIdentifier: "ImagesTableViewCell", for: indexPath)as! ImagesTableViewCell
        cell.datelabel.text = "Date-:12:112:12:00:00"
        cell.titlelabel.text = "title"
        cell.imageview.contentMode = .scaleToFill
        cell.selectionStyle = .none
        guard let asset = self.latestPhotoAssetsFetched?[indexPath.item] else {
            return cell
        }
        // Here we bind the asset with the cell.
        cell.representedAssetIdentifier = asset.localIdentifier
        // Request the image.
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: cell.imageview.frame.size,
                                              contentMode: .aspectFill,
                                              options: nil) { (image, _) in
            // By the time the image is returned, the cell may has been recycled.
            // We update the UI only when it is still on the screen.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageview.image = image
                cell.datelabel.text =  asset.creationDate?.toString(dateFormat: "dd/MM/yy hh:mm a")
                
            }
        }
        
        return cell
    }
    //MARK: collection view Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.imagescollectionview.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath)as!ImagesCollectionViewCell

        cell.titlelabel.text = "title"
        cell.imageview.contentMode = .scaleAspectFit
        
        guard let asset = self.latestPhotoAssetsFetched?[indexPath.item] else {
            return cell
        }
        // Here we bind the asset with the cell.
        cell.representedAssetIdentifier = asset.localIdentifier
        // Request the image.
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: cell.imageview.frame.size,
                                              contentMode: .aspectFill,
                                              options: nil) { (image, _) in
            // By the time the image is returned, the cell may has been recycled.
            // We update the UI only when it is still on the screen.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageview.image = image
                cell.datelabel.text =  asset.creationDate?.toString(dateFormat: "dd/MM/yy hh:mm a")

            }
        }
        
        return cell

    }
    //MARK: collection view flow layout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width-10)/4, height: (collectionView.bounds.width)/4)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        return UIEdgeInsets(top: 0, left:0, bottom:0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
//MARK: date formatter extenion to convert date to string
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
