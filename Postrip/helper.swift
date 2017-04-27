//
//  Helper.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import Foundation
import Parse
import PopupDialog

struct Currency {
    
    var name: String
    var rate: Double
    
    init?(name: String, rate: Double) {
        self.name = name
        self.rate = rate
    }
}

struct countryInfo {
    var name = String()
    var code = String()
}

protocol CountriesPopoverDelegate: class {
    func updateCountriesFlags(withCountries countries: [countryInfo])
}

protocol CurrenciesPopoverDelegate: class {
    func updateCurrencyCode(withCountries countries: [countryInfo])
}

// croping picture and center it
func cropToBounds(_ image: UIImage, width: Double, height: Double) -> UIImage {
    
    let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
    
    let contextSize: CGSize = contextImage.size
    
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return image
}

// cut an image into the circle
func maskRoundedImage(_ image: UIImage, radius: Float) -> UIImage {
    let imageView: UIImageView = UIImageView(image: image)
    var layer: CALayer = CALayer()
    layer = imageView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(radius)
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage!
}


// resize image function
func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

// get currency references
func getCurrencyList(referenceCurrency: String) -> [Currency] {
    
    var finalCurrencyList = [Currency]()

    let requestURL = URL(string: "http://api.fixer.io/latest?base=" + referenceCurrency)
    let data = try! Data(contentsOf: requestURL!)
    
    finalCurrencyList.removeAll(keepingCapacity: false)
    if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)  as? [String: AnyObject]{
        for (name, rate) in json["rates"] as! [String: Double]{
            let currencyInstance = Currency(name: name, rate: rate)
            finalCurrencyList.append(currencyInstance!)
        }
    }
    
    return finalCurrencyList
}

func getCurrencyRate(referenceCurrency: String, searchCurrency: String) -> Double {
    var tempRate:Double = 0.0
    var tempCurrentList = [Currency]()
    tempCurrentList = getCurrencyList(referenceCurrency: referenceCurrency)
    for currency in tempCurrentList {
        if currency.name.uppercased() == searchCurrency.uppercased() {
            tempRate = currency.rate
            break
        }
    }
    return tempRate
}

func getValidCurrencyCode() -> String {
    
    // get the localized country name (in my case, it's US English)
    let englishLocale : NSLocale = NSLocale.init(localeIdentifier :  "en_US")
    
    // get the current locale
    let currentLocale = NSLocale.current
    
    let theEnglishName : String? = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: currentLocale.identifier)
    
    var countryName = String()
    if let theEnglishName = theEnglishName {
        countryName = theEnglishName.slice(from: "(", to: ")")!
        print("the localized country name is \(String(describing: countryName))")
    }
    let currency = IsoCountryCodes.searchByName(name: countryName).currency
    print("Currency is " + currency)
    if countryName.isEmpty {
        return "CZK"
    } else {
        return currency
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension UIImage {
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    func imageWithColor(tintColor: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)}
        
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)}
}

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}


