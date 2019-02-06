//
//  mainViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var settingButton: CircularButton!
    @IBOutlet weak var profileButton: CircularButton!
    @IBOutlet weak var newsButton: CircularButton!
    @IBOutlet weak var favoriteButton: CircularButton!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet var PageView: UIView!
    
    @IBOutlet weak var poldarsho: MainButton!
    @IBOutlet weak var jadidtarinha: MainButton!
    @IBOutlet weak var nazdikeman: MainButton!
    @IBOutlet weak var sepantaie: MainButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let pc = UIPageControl.appearance()
        pc.pageIndicatorTintColor = UIColor.lightGray
        pc.currentPageIndicatorTintColor = UIColor.black
        pc.backgroundColor = UIColor.white
        
        let btn = UIButton(type: .system)
        btn.setTitle("Restart", for: [])
        btn.addTarget(self, action: "restartAction:", for: .touchUpInside)
        
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self as! UIPageViewControllerDataSource
        self.restartAction(sender: self)
        self.addChildViewController(self.pageViewController)
        
        let views = [
            "pg": self.pageViewController.view,
            "btn": btn,
            ]
        for (_, v) in views {
            v?.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(v!)
        }
        NSLayoutConstraint.activate(
            [NSLayoutConstraint(
                item: btn,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
             ] +
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[pg]|",               options: .alignAllCenterX, metrics: [:], views: views) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[pg]-[btn]-15-|", options: .alignAllCenterX, metrics: [:], views: views)
        )
        self.pageViewController.didMove(toParentViewController: self)
    }
    
    func restartAction(sender: AnyObject) {
        self.pageViewController.setViewControllers([self.viewControllerAtIndex(index: 0)], direction: .forward, animated: true, completion: nil)
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        if (PAGES.count == 0) || (index >= PAGES.count) {
            return ContentViewController()
        }
        let vc = ContentViewController()
        vc.pageIndex = index
        return vc
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        index = index - 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if (index == NSNotFound) {
            return nil
        }
        index = index + 1
        if (index == PAGES.count) {
            return nil
        }
        return self.viewControllerAtIndex(index: index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return PAGES.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

class ContentViewController: UIViewController {
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = PAGES[self.pageIndex].title
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        ImageLoader.sharedLoader.imageForUrl(urlString: PAGES[self.pageIndex].image) { (image, url) -> () in
            iv.image = image
        }
        
        let views = [
            "iv": iv,
            "lb": lb,
            ]
        for (_, v) in views {
            v.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(v)
        }
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lb]-|",      options: .alignAllCenterX, metrics: [:], views: views) +
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-[iv]-|",      options: .alignAllCenterX, metrics: [:], views: views) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-[lb]-[iv]-|", options: .alignAllCenterX, metrics: [:], views: views)
        )
    }
}
class ImageLoader {
    // source and license: https://github.com/natelyman/SwiftImageLoader
    let cache = NSCache<AnyObject, AnyObject>()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler: @escaping (_ image: UIImage?, _ url: String) -> ()) {
        let background = DispatchQueue.global()
        let main = DispatchQueue.main
        background.async {
            //        dispatch_async(DispatchQueue.globalDispatchQueue.global(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            let data = self.cache.object(forKey: urlString as AnyObject) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
                //dispatch_async(dispatch_get_main_queue(), {() in
                main.async{
                    completionHandler(image, urlString)
                }
                return
            }
            
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    self.cache.setObject(data as AnyObject, forKey: urlString as AnyObject)
                    main.async{
                        //dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image, urlString)
                    }
                    return
                }
                
            })
            downloadTask.resume()
        }
        
    }
}


