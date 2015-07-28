<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/M13InfiniteTabBarBanner.png">

M13InfiniteTabBar
=============
M13InfiniteTabBar is an elegant replacement for UITabBar. UITabBar becomes a problem when you have more than five view controllers that have the need to be accessed an equal amount of times. It maskes no sense to hide any of the tabs away under the "More" tab, as it takes two extra clicks to reach those view controllers. M13InfiniteTabBar solves this problem by having all the view controllers on a single level. The "extra" view controllers can be reached by scrolling the tab bar left or right. The scrolling does pose a problem though, in which direction is my offscreen tab? M13InfiniteTabBar solves this by putting the tabs in an infinite scrolling loop. Any tab can be reached by scrolling in any direction. M13InfiniteTabBar also has a few other features that UITabBar doesn't offer on top of that.

<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/Screenshot.png" width="300px">

Features:
-----------
* Simple to setup; It can be setup programitically via a single initialization method, which is passed the UIViewControllers that will be displayed along with their tabs. Or, a single delegate method if using storyboards.
* All the colors and icons can be customized to match any application theme. Most properties follow the UIAppearance protocol.
* All the delegate methods work just like the UITabBarControllerDelegate methods. Allowing easy delegate implementation. 
* Handles device rotation in a unique way. The tab bar is sticks to either the top or bottom of the screen. When the device is rotated, the view controller and the tab bar icons rotate to the new orientation, the tab bar stays locked in position. Rotation for each view controller is handled separatly. Each view controller can have its own set of allowed orientations; unlike UITabBarController, where the view controllers either need to allow all orientations, or use only one orientation.
* Allows user attention to be directed to a specific tab, A tab that requires user attention will change color, and if offscreen the tab bar will show an animation to direct the user's attention to scroll to that tab.
* The tab bar, if it contains more tabs than what can fit on screen (5 for iPhone and 14 for iPad), will be come infinitly scrolling. If all the tabs can fit on screen, it will act like a normal tab bar.
* It is also possible to turn of infinite scrolling. The tab bar will only show one set of tabs, and will still scroll, but their will be boundaries to the scrolling.

***Tap To Change Tabs***

<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/TapToChange.gif" width="300px">

***Infinite Scrolling***

<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/InfiniteScrolling.gif" width="300px">

***Delegate Methods (Preventing tab selection)***

<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/DelegateMethods.gif" width="300px">

***Directing User Attention***

<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/UserAttention.gif" width="300px">

***Rotation***

<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/Rotation.gif" width="300px">

***Pinned To Top***

<img src="https://raw.github.com/Marxon13/M13InfiniteTabBar/master/ReadmeResources/Top.png" width="300px">




Rotation Handling:
-----------------
M13InfiniteTabBarController handles the rotation of all child view controllers. M13InfiniteTabBarController itself is locked to portrait orientation. It changes the frame, bounds, and angle of the child view controllers manually. It checks the values of the child view controller's "supportedInterfaceOrientations" before rotation. Unlike UITabBarController, rotation for each child UIViewController is handled individually. If one of five child controllers requires portrait orientation while the rest can use any, the other four are not locked to portrait only. Even if the portrait view controller is selected in landscape orientation, it will display in portrait.

Set Up:
--------------
* First create all the view controllers and their tabs.

```
UIViewController *vc1 = [[UIViewController alloc] init];
UIViewController *vc2 = [[UIViewController alloc] init];
UIViewController *vc3 = [[UIViewController alloc] init];
UIViewController *vc4 = [[UIViewController alloc] init];
UIViewController *vc5 = [[UIViewController alloc] init];

M13InfiteTabBarItem *item1 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Title" selectedIconMask:[UIImage imageNamed:@"image.png"] unselectedIconMask:[UIImage imageNamed:@"image.png"]];
M13InfiteTabBarItem *item2 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Title" selectedIconMask:[UIImage imageNamed:@"image.png"] unselectedIconMask:[UIImage imageNamed:@"image.png"]];
M13InfiteTabBarItem *item3 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Title" selectedIconMask:[UIImage imageNamed:@"image.png"] unselectedIconMask:[UIImage imageNamed:@"image.png"]];
M13InfiteTabBarItem *item4 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Title" selectedIconMask:[UIImage imageNamed:@"image.png"] unselectedIconMask:[UIImage imageNamed:@"image.png"]];
M13InfiteTabBarItem *item5 = [[M13InfiniteTabBarItem alloc] initWithTitle:@"Title" selectedIconMask:[UIImage imageNamed:@"image.png"] unselectedIconMask:[UIImage imageNamed:@"image.png"]];
```

* Next create the M13InfiniteTabBarController and set its delegate

```
M13InfiniteTabBarController *viewController = [[M13InfiniteTabBarController alloc] initWithViewControllers:@[vc1, vc2, vc3, vc4, vc5] pairedWithInfiniteTabBarItems:@[item1, item2, item3, item4, item5]];
```

* Customize any of the other attributes of M13InfiniteTabBar after it has been initalized.

* To be able to direct the user's attention, set the requires user attention background view. This feature is separated to allow easy subclassing and custom designs.

```
viewController.requiresAttentionBackgroundView = [[PulsingRequiresAttentionView alloc] init];
```


* Lastly display the controller by adding it to a UIWindow, or pushing it onto a UINavigationController stack.


To Do:
-------------------
These features will eventually be added to M13InfiniteTabBar:

* Adding badges to tab bar items.
* Allow switching the order, adding, and removing of tabs.

Known Issues:
--------------------

* M13InfiniteTabBar does not seem to work in the simulator. I have tested it on actual devices, and it works as expected. The two main issues are that the selection triangle does not appear, and that the tabs are cut off the bottom of the bar. I am not sure what is causing this. I am going to assume it is the simulator, since it works fine on actual devices.


Contact Me:
-------------
If you have any questions comments or suggestions, send me a message. If you find a bug, or want to submit a pull request, let me know.

License:
--------
MIT License

> Copyright (c) 2014 Brandon McQuilkin
> 
> Permission is hereby granted, free of charge, to any person obtaining 
>a copy of this software and associated documentation files (the  
>"Software"), to deal in the Software without restriction, including 
>without limitation the rights to use, copy, modify, merge, publish, 
>distribute, sublicense, and/or sell copies of the Software, and to 
>permit persons to whom the Software is furnished to do so, subject to  
>the following conditions:
> 
> The above copyright notice and this permission notice shall be 
>included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
>EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
>MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
>IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
>CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
>TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
>SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
