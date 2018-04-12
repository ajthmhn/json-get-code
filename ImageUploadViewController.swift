//
//  ImageUploadViewController.swift
//  json.swift
//
//  Created by Islet on 12/04/18.
//  Copyright © 2018 islet. All rights reserved.
//

import UIKit

class ImageUploadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func uploadProductImage(image :UIImage, productId:Int,completion:ZaskaAPICompletion?)
    {
        let url = URL(string: "\(ZaskaAPIConfig.BaseUrl.baseServerpath)api/v2/productImage/product/\(productId)")
        debugPrint(url ?? "no url")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        var header = ""
        if let type = ZaskaAPIFacade.shared.session?.tokenType, let token = ZaskaAPIFacade.shared.session?.token {
            header = "\(type) \(token)"
        }
        let boundary = generateBoundaryString()
        request.setValue(header, forHTTPHeaderField: "authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //  self.resize
        let imageResize = self.resizeImage(image: image, targetSize: CGSize(width: 640, height: 480))
        let image_data = UIImagePNGRepresentation(imageResize)
        if(image_data == nil)
        {
            return
        }
        let body = NSMutableData()
        let fname = "shop.png"
        let mimetype = "image/png"
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"upload\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        
        if self.session?.expired == true {
            getToken(completion: { (result) in
                if result?.statusCode == 200 {
                    let task = session.dataTask(with: request) {(data, response, error) in
                        print("action performed")
                        let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print(dataString ?? "")
                        if let _:NSData = data as NSData?, let _:URLResponse = response, error == nil  {
                            completion?(ZaskaAPIResponse(success:true, data: nil, json: nil))
                        }else {
                            completion?(ZaskaAPIResponse(success:false, data: nil, json: nil))
                        }
                        
                    }
                    task.resume()
                }else {
                    completion?(ZaskaAPIResponse(success:false, data: nil, json: nil))
                }
            })
        }else {
            let task = session.dataTask(with: request) {(data, response, error) in
                print("action performed")
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString ?? "")
                if let _:NSData = data as NSData?, let _:URLResponse = response, error == nil  {
                    completion?(ZaskaAPIResponse(success:true, data: nil, json: nil))
                }else {
                    completion?(ZaskaAPIResponse(success:false, data: nil, json: nil))
                }
                
            }
            task.resume()
        }
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
