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
        handler(Date().addingTimeInterval(24 * 60 * 60))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        if complication.family == .graphicCorner {
            PriceService.getPrice().subscribe(onSuccess: { price in
                let template = CLKComplicationTemplateGraphicCornerTextImage()
                template.textProvider = CLKSimpleTextProvider(text: price)
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            }) { _ in
                handler(nil)
            }.disposed(by: disposeBag)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = CLKComplicationTemplateGraphicCornerTextImage()
        
        template.textProvider = CLKSimpleTextProvider(text: "Loading...")
        //template.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "omisego")!)
        
        handler(template)
    }
}
