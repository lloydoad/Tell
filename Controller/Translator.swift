//
//  Translator.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/18/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let API_KEY = "trnsl.1.1.20180623T222842Z.cd534625e68f7030.93aee402fd3d0da1e85160a80be5e6da75fb06f1"
let YANDEX_URL = "https://translate.yandex.net/api/v1.5/tr.json/getLangs?"

func getRequest(url: URLConvertible, completion: @escaping (JSON?) -> Void) {
    Alamofire.request(url, method: .get).responseJSON { (response) in
        if let json = response.result.value {
            completion(JSON(json))
        } else {
            print("Fail")
            completion(nil)
        }
    }
}

func translateToEn(originalText: String, srclang: String, completion: @escaping (String)->Void) {
    let src = originalText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let beginningUrl = "https://translate.yandex.net/api/v1.5/tr.json/translate?key="+API_KEY
    let url = beginningUrl+"&text="+src+"&lang="+srclang+"-"+"en"
    
    getRequest(url: url) { (data) in
        DispatchQueue.main.async {
            guard let retrieved = data else { completion(originalText); return }
            
            let array = retrieved["text"].arrayObject as! [String]
            let translated = array.first
            guard let transText = translated else {completion(originalText) ;return}
            completion(transText)
        }
    }
}

func getTranslated(original: String, to: String, completion: @escaping (String)->Void) {
    let source = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let beginningUrl = "https://translate.yandex.net/api/v1.5/tr.json/translate?key="+API_KEY
    let url = beginningUrl+"&text="+source+"&lang="+"en"+"-"+to
    
    getRequest(url: url) { (data) in
        guard let retrieved = data else { completion(original); return }
        DispatchQueue.main.async {
            let array = retrieved["text"].arrayObject as! [String]
            let translated = array.first
            
            guard let transText = translated else {completion(original) ;return}
            completion(transText)
        }
    }
}

func getAvailableLanguages(completion: @escaping([String:String]?, [String]?)->Void) {
    let url = "\(YANDEX_URL)key=\(API_KEY)&ui=en"
    getRequest(url: url) { (data) in
        if let rec = data {
            DispatchQueue.main.async {
                let lang = rec["langs"].dictionaryObject as! [String:String]
                var languageQueryReference: [String:String] = [:]
                var languages: [String] = []
                
                for dict in lang {
                    languageQueryReference.updateValue(dict.key, forKey: dict.value)
                }
                
                languages = Array(lang.values)
                languages.sort(by: { (str1, str2) -> Bool in
                    return str1 < str2
                })
                completion(languageQueryReference,languages)
            }
            completion(nil,nil)
        }
    }
}
