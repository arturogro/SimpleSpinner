# SimpleSpinner

SimpleSpinner is an iOS control written in Swift 3 that displays a spinner similar to the one used in Google Apps. <br /><br />

## Usage
1. Import the SimpleSpinner folder in your existing project.
2. Connect your `SimpleSpinner` to your View Controller.

  ```swift
  @IBOutlet weak var simpleSpinnerView: SimpleSpinner!
  ```
3.  Set the line width and the tint color of your spinner.

  ```swift
  simpleSpinnerView.lineWidth = 5
  simpleSpinnerView.tintColor = UIColor(red: 72/255.0, green: 133/255.0, blue: 237/255.0, alpha: 1)
  ```
4.  Start animating your spinner.

  ```swift
  simpleSpinnerView.startAnimating()
  ``` 
  
5.  Stop animating your spinner when you're done.

  ```swift
  simpleSpinnerView.stopAnimating()
  ``` 
## Preview
![](http://i.giphy.com/xUPGchtnB4ZsTWFcsg.gif)

