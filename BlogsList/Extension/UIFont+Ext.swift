
import Foundation
import UIKit

extension UIFont {
    
    class var fontMontserratBlack: UIFont {
         return UIFont(name: "Montserrat-Black", size: 20)!
     }
    
    class var montserratBlackItalic: UIFont {
        return UIFont(name: "Montserrat-BlackItalic", size: 20)!
    }
    
    class var montserratBold: UIFont {
        return UIFont(name: "Montserrat-Bold", size: 20)!
    }
    
    class var montserratExtraBold: UIFont {
        return UIFont(name: "Montserrat-ExtraBold", size: 20)!
    }
    
    class var montserratBoldItalic: UIFont {
        return UIFont(name: "Montserrat-BoldItalic", size: 20)!
    }
    
    class var montserratExtraBoldItalic: UIFont {
        return UIFont(name: "Montserrat-ExtraBoldItalic", size: 20)!
    }
    
    class var montserratExtraLight: UIFont {
        return UIFont(name: "Montserrat-ExtraLight", size: 20)!
    }
    
    class var montserratExtraLightItalic: UIFont {
        return UIFont(name: "Montserrat-ExtraLightItalic", size: 20)!
    }
    
    class var montserratLight: UIFont {
        return UIFont(name: "Montserrat-Light", size: 20)!
    }
    
    class var montserratLightItalic: UIFont {
        return UIFont(name: "Montserrat-LightItalic", size: 20)!
    }
    
    class var montserratMedium: UIFont {
        return UIFont(name: "Montserrat-Medium", size: 20)!
    }
    
    class var montserratMediumItalic: UIFont {
        return UIFont(name: "Montserrat-MediumItalic", size: 20)!
    }
    
    class var montserratItalic: UIFont {
        return UIFont(name: "Montserrat-Italic", size: 20)!
    }
    
    class var montserratSemiBold: UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: 20)!
    }
    
    class var montserratSemiBoldItalic: UIFont {
        return UIFont(name: "Montserrat-SemiBoldItalic", size: 20)!
    }
    
    class var montserratThin: UIFont {
        return UIFont(name: "Montserrat-Thin", size: 20)!
    }
    
    class var montserratThinItalic: UIFont {
        return UIFont(name: "Montserrat-ThinItalic", size: 20)!
    }
    
    class var montserratRegular: UIFont {
        return UIFont(name: "Montserrat-Regular", size: 20)!
    }
    
    class var avenirNextBold: UIFont {
        return UIFont(name: "AvenirNext-Bold", size: 20)!
    }
    
    class var avenirNextMedium: UIFont {
        return UIFont(name: "AvenirNext-Medium", size: 20)!
    }
    
    class var avenir: UIFont {
        return UIFont(name: "Avenir", size: 20)!
    }
    
    class var avenirBlack: UIFont {
        return UIFont(name: "Avenir-Black", size: 20)!
    }
    
    class var avenirHeavy: UIFont {
        return UIFont(name: "Avenir-Heavy", size: 20)!
    }
    
    class var avenirRoman: UIFont {
        return UIFont(name: "Avenir-Roman", size: 20)!
    }
    
    class var avenirLight: UIFont {
        return UIFont(name: "Avenir-Light", size: 20)!
    }
    
    class var avenirMedium: UIFont {
        return UIFont(name: "Avenir-Medium", size: 20)!
    }
    
    class var avenirBook: UIFont {
        return UIFont(name: "Avenir-Book", size: 20)!
    }
    
    class var mediumOblique: UIFont {
        return UIFont(name: "Avenir-MediumOblique", size: 20)!
    }
    
    func withAdjustableSize(_ fontSize: CGFloat) -> UIFont {
        let multiplier = min((UIScreen.main.bounds.size.width / 375), 2)
        return withSize(fontSize * multiplier)
    }
}
