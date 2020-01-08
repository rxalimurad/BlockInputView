# BlockInputView

[![Version](https://img.shields.io/cocoapods/v/BlockInputView.svg?style=flat)](https://cocoapods.org/pods/BlockInputView)
[![Platform](https://img.shields.io/cocoapods/p/BlockInputView.svg?style=flat)](https://cocoapods.org/pods/BlockInputView)

## Installation

BlockInputView is available through [CocoaPods](https://cocoapods.org/pods/BlockInputView). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BlockInputView'
```
## Usage

BlockInputView is very simple to use, to setup BlockInputView follow below step,
* Assign class BlockInputView to that UIView on with you want to make blockInput.
* Make it's outlet in ViewController
* Call following method 
```ruby 
  public func activate(widgetAppearance: WidgetAppearance = WidgetAppearance()) 
  ```

## Properties
  ```ruby 
    public func activate(widgetAppearance: WidgetAppearance = WidgetAppearance()) 
  ``` 
Function above takes WidgetAppearance Object as parameter in which you can configure following properties.

#### Functional Properties ####
* isMandatory: Bool 
* minNumberOfSections: Int 
* sectionWidth: Int
* minLength: Int
* maxLength: Int 
* isSecureTextEntry: Bool 

#### Input Fields ####
* textColor: UIColor 
* FontSize: CGFloat
* FontName: String
* hintColor: String
* hintText: String

#### Error Message ####
* errorFontName: String 
* errorFontSize: String 
* errorTextColor: UIColor 
* errorMessage: String 
* emptyMessage: String 

#### Bottom Lines ####
* bottomLineFocusOutColor: UIColor
* bottomLineFocusedColor: UIColor
* bottomLineErrorColor: UIColor

#### Other Properties ####
* blockSpacing: CGFloat
* cursorColor: CGFloat
* keyboardType: UIKeyboardType


## Methods

  * Following method will return text written in inputview.
``` ruby 
  public func getFieldText() -> String 
```
  * Following method will validate contraints (e.g maxLenght, isMandatory, minLength) and return true or false on result of validation.
```ruby 
  public func validate() -> Bool 
```
* Activate will initialize BlockInputView
```ruby 
  public func activate(widgetAppearance: WidgetAppearance = WidgetAppearance()) 
  ```

## Demo
BlockInputView provides natural way to input card number, pin, one-time password.
Following are some examples.

* Card Number
![](/Screenshots/card.gif)
* Secure PIN
![](/Screenshots/error.gif)
* Invalid Input
![](/Screenshots/errordisplay.gif)


## Author

herralimurad, herralimurad@gmail.com

## License

BlockInputView is available under the MIT license. See the LICENSE file for more info.
