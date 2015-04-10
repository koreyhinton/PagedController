# PagedController

### What is this and Why is this?
UIPageViewController has always been difficult to implement. It can also be the source of many obscure and sometimes less-obscure bugs. I found myself writing the same code over and over again for index checking and also the code to disable fast paging which can be the cause bugs if the user swipes really quickly between view controllers. UIPageViewController can only be partially implemented in the Storyboard since the data source must be established in code. To simplify all of this I made it so you can create a page controller in 3 lines of code :) You also don't have to mess with any indices. Just give it the view controllers you want with the settings you want and tell it to load. 

### Features
* 3 lines of code to implement
* built-in disabling of fast scrolling
* looping and non-looping implementations by setting a single flag

### Installation
 
 Add the Swift files in PagedController directory to your project
 
#### Usage

**Non-looping w/ fast paging disabled example**

```swift

// one, two, three are UIViewControllers you've preloaded

var pagedDataSource = PagedDataSource(viewControllers: [one,two,three], loops:false) {
    (state: PageState) -> Void in
    switch (state) {
    case .NoNextNoPrevious:
    // hide all controls
    case .HasNext:
    // hide previous control
    case .HasPrevious:
    // hide forward control
    case .HasNextHasPrevious:
    // show all controls
    }
}

var pagedController = PagedController(dataSource: pagedDataSource, disableFastPaging:true, transitionStyle: .Scroll, navigationOrientation: .Horizontal)

pagedController.disableFastPagingDelegate = self
pagedDataSource.load(pagedController)

// ... 
// If using PagedDisablingDelegate and disableFastPaging is set to true
func shouldEnablePaging() {
    // enable paging controls (ie: left/right arrows)
}
func shouldDisablePaging() {
    // disable paging controls (ie: left/right arrows)
}
 ```
 
 **Looping w/ fast paging disabled and no controls to disable (just swiping) example**
 ```swift
 // one, two, three are UIViewControllers you've preloaded
var pagedDataSource = PagedDataSource(viewControllers: [one,two,three], loops:true)
var pagedController = PagedController(dataSource: pagedDataSource, disableFastPaging:true, transitionStyle: .Scroll, navigationOrientation: .Horizontal)
pagedDataSource.load(pagedController)
 ```
 
#### Things that still need to be done:
- Thorough testing of all features
- Add PageControl (dots) w/ flag to enable or disable it
- Improve performance after each transition ends (iterates to find the index)
- Add ability for dynamic view controllers as opposed to having all in memory

### Architecture
*PagedIterator*
The PagedIterator won't have to be touched unless you want to extend it or if you find a bug. It wraps an array of Objects that can be iterated over and keeps track of the current position. This makes the hairy data source methods a one-liner:

```swift
// MARK: - UIPageViewControllerDataSource
func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    return pagedIterator.previous(peek: true)
}
func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    return pagedIterator.next(peek: true)
}
```

The code above is already built-in for you so you don't have to do anything.

*PagedController*
The PagedController is a subclass of UIPageViewController and also a delegate to UIPageViewControllerDelegate. It will give you updates of the page state if you implement give its initializer a pageStateCompletion closure. 



*PagedDataSource*
The data source provides the view controllers to the page controller and also has a bunch of methods to move between, add, and remove view controllers. It also takes care of the initial load of the first view controller. It gives you the interface to load and modify the view controllers in UIPageViewController in place.
```swift
pagedDataSource.moveNext(true) // true means animate it
// Or
pagedDataSource.moveLast(true)
// Or
pagedDataSource.removeNext()
```

You can also set-up target-actions:
```swift
prevBtn.addTarget(pagedDataSource, action: "movePrevious", forControlEvents: .TouchUpInside)
firstBtn.addTarget(pagedDataSource, action: "moveFirst", forControlEvents: .TouchUpInside)
nextBtn.addTarget(pagedDataSource, action: "moveNext", forControlEvents: .TouchUpInside)
lastBtn.addTarget(pagedDataSource, action: "moveLast", forControlEvents: .TouchUpInside)
delBtn.addTarget(pagedDataSource, action: "removeCurrent", forControlEvents: .TouchUpInside)
addBtn.addTarget(self, action: "addVC", forControlEvents: .TouchUpInside)

// ...
func addVC() {
    var controller = UIViewController()
    controller.view.backgroundColor = UIColor.lightGrayColor()
    pagedDataSource.addNext(controller, animated: false)
    pagedDataSource.moveNext(true)
}
```

### Example
There is an example included that shows an implementation with controls allowing you to page to first, page to previous, page to next, page to last, add and move after current, delete current (if count > 1) and it properly disables and hides the controls as you'd expect

First                      | Middle                    | Last
:-------------------------:|:-------------------------:|:-------------------------:
![](screenshot0.png) | ![](screenshot1.png) | ![](screenshot2.png)
