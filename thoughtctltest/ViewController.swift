//
//  ViewController.swift
//  thoughtctltest
//
//  Created by Abhishek Dhamdhere on 10/09/23.
//

import UIKit
import Photos

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   

    @IBOutlet weak var navigationcontroller: UINavigationItem!
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var imagesTableView: UITableView!
    let imagePicker = UIImagePickerController()
    var images = [UIImage]()
    var allPhotos : PHFetchResult<PHAsset>? = nil
    var latestPhotoAssetsFetched: PHFetchResult<PHAsset>? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor  = UIColor.red;
        self.imagesTableView.register(UINib.init(nibName: "ImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "ImagesTableViewCell")
        self.imagesTableView.delegate = self
        self.imagesTableView.dataSource = self
        self.imagesTableView.reloadData()
        self.imagesTableView.tableFooterView = UIView()
        self.getPhotolibrary()
        self.getPhonePhotos()
        
    }
    func fetchLatestPhotos(forCount count: Int?) -> PHFetchResult<PHAsset> {
        
        // Create fetch options.
        let options = PHFetchOptions()
        
        // If count limit is specified.
        if let count = count { options.fetchLimit = count }
        
        // Add sortDescriptor so the lastest photos will be returned.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        DispatchQueue.main.async {
            self.imagesTableView.reloadData()
        }
        
        // Fetch the photos.
        
        return PHAsset.fetchAssets(with: .image, options: options)
        
    }
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
    func getPhonePhotos()
    {
        let fetchOptions = PHFetchOptions()
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        print("Found number of:  \(allPhotos.count) images")
        self.allPhotos = allPhotos
        print(self.allPhotos!)
        self.latestPhotoAssetsFetched = self.fetchLatestPhotos(forCount:self.allPhotos?.count)
       // setFirstAssetImage()
        self.imagesTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPhotos?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.imagesTableView.dequeueReusableCell(withIdentifier: "ImagesTableViewCell", for: indexPath)as! ImagesTableViewCell
        cell.datelabel.text = "Date-:12:112:12:00:00"
        cell.titlelabel.text = "header"
        cell.imageview.contentMode = .scaleToFill
        
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
            }
        }
        
        return cell
    }
    
}

