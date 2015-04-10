//
//  AppDelegate.swift
//  PagedIteratorExample
//
//  Created by Korey Hinton on 4/10/15.
//  Copyright (c) 2015 Korey Hinton. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PagedDisablingDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.blackColor()
        
        self.window?.makeKeyAndVisible()
        
        
        
        var one = UIViewController()
        one.view.backgroundColor = UIColor.redColor()
        var two = UIViewController()
        two.view.backgroundColor = UIColor.whiteColor()
        var three = UIViewController()
        three.view.backgroundColor = UIColor.yellowColor()
        
        
        var toolbar = UIView()
        toolbar.backgroundColor = UIColor.clearColor()
        toolbar.frame = CGRectMake(0, 0, 300, 70)
        

        var firstBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        firstBtn.setTitle("|<", forState: .Normal)
        firstBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 70)
        
        var prevBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        prevBtn.setTitle("<", forState: .Normal)
        prevBtn.frame = CGRect(x: firstBtn.frame.size.width, y: 0, width: 40, height: 70)
        
        var nextBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        nextBtn.setTitle(">", forState: .Normal)
        nextBtn.frame = CGRect(x: 2*prevBtn.frame.size.width, y: 0, width: 40, height: 70)
        
        var lastBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        lastBtn.setTitle(">|", forState: .Normal)
        lastBtn.frame = CGRect(x: 3*nextBtn.frame.size.width, y: 0, width: 40, height: 70)
        
        var delBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        delBtn.setTitle("-", forState: .Normal)
        delBtn.frame = CGRect(x: 4*nextBtn.frame.size.width, y: 0, width: 40, height: 70)


        var addBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        addBtn.setTitle("+", forState: .Normal)
        addBtn.frame = CGRect(x: 5*nextBtn.frame.size.width, y: 0, width: 40, height: 70)
        
        toolbar.addSubview(firstBtn)
        toolbar.addSubview(prevBtn)
        toolbar.addSubview(nextBtn)
        toolbar.addSubview(lastBtn)
        toolbar.addSubview(delBtn)
        toolbar.addSubview(addBtn)
        
        buttons = [firstBtn,prevBtn,nextBtn,lastBtn,delBtn, addBtn]

        pagedDataSource = PagedDataSource(viewControllers: [one,two,three], loops:false) {
            (state: PageState) -> Void in
            
            delBtn.hidden = false
            
            switch (state) {
            case .NoNextNoPrevious:
                prevBtn.hidden = true
                nextBtn.hidden = true
                delBtn.hidden = true
            case .HasNext:
                prevBtn.hidden = true
                nextBtn.hidden = false
            case .HasPrevious:
                prevBtn.hidden = false
                nextBtn.hidden = true
            case .HasNextHasPrevious:
                prevBtn.hidden = false
                nextBtn.hidden = false
            }
            firstBtn.hidden = prevBtn.hidden
            lastBtn.hidden = nextBtn.hidden
        }
        
        
        prevBtn.addTarget(pagedDataSource, action: "movePrevious", forControlEvents: .TouchUpInside)
        firstBtn.addTarget(pagedDataSource, action: "moveFirst", forControlEvents: .TouchUpInside)
        nextBtn.addTarget(pagedDataSource, action: "moveNext", forControlEvents: .TouchUpInside)
        lastBtn.addTarget(pagedDataSource, action: "moveLast", forControlEvents: .TouchUpInside)
        delBtn.addTarget(pagedDataSource, action: "removeCurrent", forControlEvents: .TouchUpInside)
        addBtn.addTarget(self, action: "addVC", forControlEvents: .TouchUpInside)
        
        var pagedController = PagedController(dataSource: pagedDataSource, disableFastPaging:true, transitionStyle: .Scroll, navigationOrientation: .Horizontal)
        
        pagedController.disableFastPagingDelegate = self
        
        pagedDataSource.load(pagedController)
        
        
        pagedController.view.addSubview(toolbar)
        
        
        
        self.window?.rootViewController = pagedController
        
        return true
    }

    var pagedDataSource: PagedDataSource!
    
    func addVC() {
        var controller = UIViewController()
        controller.view.backgroundColor = UIColor.lightGrayColor()
        pagedDataSource.addNext(controller, animated: false)
        pagedDataSource.moveNext(true)
    }
    
    var buttons: [UIButton]!
    
    func shouldEnablePaging() {
        for button in buttons {
            button.userInteractionEnabled = true
            button.enabled = true
        }
    }
    
    func shouldDisablePaging() {
        for button in buttons {
            button.userInteractionEnabled = false
            button.enabled = false
        }
    }


}

