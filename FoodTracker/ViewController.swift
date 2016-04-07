//
//  ViewController.swift
//  FoodTracker
//
//  Created by satan on 4/5/16.
//  Copyright © 2016 satan. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITextFieldDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // MARK: Properties
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var imageAssetUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textFieldName.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldName.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        labelName.text = textFieldName.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        imageAssetUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
        let assetList = PHAsset.fetchAssetsWithALAssetURLs([imageAssetUrl], options: nil)
        let asset = assetList.firstObject as! PHAsset
        let asset_location = asset.location as CLLocation!
        
        let location_lat = asset_location.coordinate.latitude
        let location_lon = asset_location.coordinate.longitude
        
        textFieldName.text = imageAssetUrl.absoluteString
        print(location_lat)
        print(location_lon)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Action
    @IBAction func selectImageFromGallery(sender: UITapGestureRecognizer) {
        textFieldName.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func labelButton(sender: UIButton) {
        let foo = Dictionary<String, String>()
        UploadRequest(imageView.image!, metadata: foo)
        labelName.text = "Hudson"
    }
    
    // MARK: Upload
    func UploadRequest(image: UIImage,
                       metadata: Dictionary<String, String>,
                       localUrl: String = "http://localhost:8000/uploader/")
    {
        let url = NSURL(string: localUrl)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let image_data = UIImagePNGRepresentation(image)
        if(image_data == nil)
        {
            return
        }
        
        
        let body = NSMutableData()
        let fname = "test.png"
        let mimetype = "image/png"
        
        
        
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"image\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(image_data!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        request.HTTPBody = body
        
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print(dataString)
            
        }
        
        task.resume()
        
        
    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }

}

