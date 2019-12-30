//
//  ComplicationController.swift
//  iCheckCrypto WatchKit Extension
//
//  Created by Tacenda on 12/14/19.
//  Copyright © 2019 Tacenda. All rights reserved.
//

import ClockKit
import WatchKit
import RxSwift

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    private let disposeBag = DisposeBag()
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date().addingTimeInterval(15 * 60))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let price = PriceService.cachedPrice {
            handler(templateForFamily(family: complication.family, price: price))
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        if let price = PriceService.cachedPrice {
            handler([templateForFamily(family: complication.family, price: price)])
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        if let price = PriceService.cachedPrice {
            handler([templateForFamily(family: complication.family, price: price)])
        } else {
            handler(nil)
        }
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(templateForFamily(family: complication.family, price: "OMG PRICE").complicationTemplate)
    }
    
    private func templateForFamily(family: CLKComplicationFamily, price: String) -> CLKComplicationTimelineEntry {
        let entry = CLKComplicationTimelineEntry()
        entry.date = Date()
        var template: CLKComplicationTemplate
        switch family {
        case .modularSmall:
            let localTemplate = CLKComplicationTemplateModularSmallSimpleText()
            localTemplate.textProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        case .modularLarge:
            let localTemplate = CLKComplicationTemplateModularLargeStandardBody()
            localTemplate.headerTextProvider = CLKSimpleTextProvider(text: "OMG PRICE")
            localTemplate.body1TextProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        case .utilitarianSmall:
            let localTemplate = CLKComplicationTemplateUtilitarianSmallRingText()
            localTemplate.textProvider = CLKSimpleTextProvider(text: price)
            localTemplate.fillFraction = 1
            template = localTemplate
            break
        case .utilitarianSmallFlat:
            let localTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            localTemplate.textProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        case .utilitarianLarge:
            let localTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
            localTemplate.textProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        case .circularSmall:
            let localTemplate = CLKComplicationTemplateCircularSmallSimpleText()
            localTemplate.textProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        case .extraLarge:
            let localTemplate = CLKComplicationTemplateExtraLargeSimpleText()
            localTemplate.textProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        case .graphicCorner:
            let localTemplate = CLKComplicationTemplateGraphicCornerStackText()
            localTemplate.outerTextProvider = CLKSimpleTextProvider(text: "OMG PRICE")
            localTemplate.innerTextProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        case .graphicBezel:
            let localTemplate = CLKComplicationTemplateGraphicBezelCircularText()
            localTemplate.textProvider = CLKSimpleTextProvider(text: price)
            localTemplate.circularTemplate = CLKComplicationTemplateGraphicCircular()
            template = localTemplate
            break
        case .graphicCircular:
            let localTemplate = CLKComplicationTemplateGraphicCircularStackText()
            localTemplate.line1TextProvider = CLKSimpleTextProvider(text: "OMG PRICE")
            localTemplate.line2TextProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        case .graphicRectangular:
            let localTemplate = CLKComplicationTemplateGraphicRectangularStandardBody()
            localTemplate.headerTextProvider = CLKSimpleTextProvider(text: "OMG PRICE")
            localTemplate.body1TextProvider = CLKSimpleTextProvider(text: price)
            template = localTemplate
            break
        @unknown default:
            fatalError("Check new complication style")
        }
        entry.complicationTemplate = template
        return entry
    }
}
