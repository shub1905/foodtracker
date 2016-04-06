//
//  ViewController.swift
//  FoodTracker
//
//  Created by satan on 4/5/16.
//  Copyright © 2016 satan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // MARK: Properties
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
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
        UploadRequest()
        labelName.text = "Hudson"
    }
    
    // MARK: Upload
    func UploadRequest()
    {
        let url = NSURL(string: "http://localhost:8000/uploader/")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (imageView.image == nil)
        {
            return
        }
        
        let image_data = UIImagePNGRepresentation(imageView.image!)
        
        
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

