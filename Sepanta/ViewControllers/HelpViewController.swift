//
//  HelpViewController.swift
//  Sepanta
//
//  Created by Iman on 2/21/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class HelpViewController : UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    weak var coordinator : HomeCoordinator?
    let p1Label = "مراکز سپنتایی به فروشنده هایی که در باشگاه ما ثبت نام کرده اند گفته می شود که بصورت دسته به دسته در این بخش قابل مشاهده هستند"
    let p2Label = "فروشگاه های جدید در این بخش اعلام می شوند، کلیه فروشگاه های جدید بدون درنظر گرفتن دسته و صنف در این قسمت لیست می شوند"
    let p3Label = "فروشگاه های نزدیک خود را بر روی نقشه ببنید، در این بخش کلیه مراکز سپنتایی نزدیک شما بر روی نقشه علامت گذاری شده است"
    let p4Label = "نام فروشگاه را جستجو کنید، درصورتیکه نام فروشگاه را می دانید و حتی در صورتیکه پیشوند خاصی را درنظر دارید که فروشگاه های مورد نظر شما آنرا دارند، از جستجو استفاده کنید"
    var labels : [String] = ["1","2","3","4"]
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let cVC = viewController as! ContentViewController
        guard cVC.pageNo > 0 else { return nil }
        
        return self.createContent(cVC.pageNo - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let cVC = viewController as! ContentViewController
        guard cVC.pageNo < labels.count - 1 else { return nil }
        return self.createContent(cVC.pageNo + 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return labels.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        labels = [p1Label,p2Label,p3Label,p4Label]
        dataSource = self
        let firstVC = createContent(0)
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    func createContent(_ anIndex : Int)->ContentViewController{
        print("Createing : ",anIndex)
        let storyboard = UIStoryboard(name: "Help", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        vc.titleString = labels[anIndex]
        vc.coordinator = self.coordinator
        vc.pageNo = anIndex
        if anIndex == 0 {
            vc.pageType = PageType.Start
        }else if anIndex == labels.count - 1 {
            vc.pageType = PageType.End
        }else {
            vc.pageType = PageType.Series
        }
        return vc
    }
}
