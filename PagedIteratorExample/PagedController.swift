//
//  ViewController.swift
//  PagedIteratorExample
//
//  Created by Korey Hinton on 4/10/15.
//  Copyright (c) 2015 Korey Hinton. All rights reserved.
//

import UIKit

/*
 * Delegate that gets informed when to disable and enable paging controls (for custom forward and back buttons)
 */
protocol PagedDisablingDelegate {
    func shouldDisablePaging()
    func shouldEnablePaging()
}

class PagedController: UIPageViewController, UIPageViewControllerDelegate {
    
    // MARK: - Data Source
    var pagedDataSource: PagedDataSource!

    // MARK: - Fast Paging Disabling
    
    /*
    * UIPageViewController is known for getting off track when the user swipes too fast
    * Prevent paging during page transition animation with this flag.
    */
    private(set) var disableFastPaging: Bool!
    
    // get callbacks when you need to prevent paging (forward/back) controls.
    // this also requires disableFastPaging to be set to true
    var disableFastPagingDelegate: PagedDisablingDelegate?
    
    // MARK: - Paging Disabling Helpers
    func enablePagingIfNecessary() {
        if disableFastPaging == true {
            view.userInteractionEnabled = true
            if disableFastPagingDelegate != nil {
                disableFastPagingDelegate!.shouldEnablePaging()
            }
        }
    }
    func disablePagingIfNecessary() {
        if disableFastPaging == true {
            view.userInteractionEnabled = false
            if disableFastPagingDelegate != nil {
                disableFastPagingDelegate!.shouldDisablePaging()
            }
        }
    }

    // MARK: - Designated Initializer
    init(dataSource: PagedDataSource, disableFastPaging: Bool, transitionStyle:UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [NSObject : AnyObject]? = nil) {
        super.init(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: options)
        self.dataSource = dataSource
        self.pagedDataSource = dataSource
        self.delegate = self
        self.disableFastPaging = disableFastPaging
    }

    // MARK: - UIViewController
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pagedDataSource.load(self)
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        disablePagingIfNecessary()
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        if finished == true {
            enablePagingIfNecessary()
            var idx = pagedDataSource.pagedIterator.indexOf(viewControllers[0] as! UIViewController)
            
            //assert(idx != NSNotFound, "Fatal error could not find index")
            
            pagedDataSource.pagedIterator.toIndex(idx)
            self.pagedDataSource.updatePageState()
        }
    }
}
