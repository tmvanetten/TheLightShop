//
//  Constants.swift
//  Demo Shop
//
//  Created by Nissi Vieira Miranda on 1/13/16.
//  Copyright © 2016 Nissi Vieira Miranda. All rights reserved.
//

import Foundation

    enum Config {
        // Stripe
        //static let stripeTestPublishableKey = "pk_test_mPxJJ23QTvmtACBDKbkwHwA4"
        // Apple Pay
        //static let appleMerchantId = "YOUR MERCHANT ID"
        
        static let moltinID = "SMWYOlEYTDaOPkVufkm3NIGYsVqHjbHFgQvwFcp1Yr"
    }

    enum Color { //30 65 76
        static let moltinColor = UIColor(red: 0.34, green: 0.77, blue: 0.78, alpha: 1.0)
        static let tablebackColor = UIColor.clearColor()
        static let appColor = UIColor.redColor()
    }

    struct Font {
        static let navlabel = UIFont.systemFontOfSize(25, weight: UIFontWeightRegular)
        static let cellheaderlabel = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
        static let collectlabel = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        static let collectlabel1 = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
    }

