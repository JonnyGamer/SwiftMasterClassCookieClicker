//
//  main.swift
//  LLDB
//
//  Created by Jonathan Pappas on 6/9/21.
//

import Foundation
import SwiftSoup





var go = true
func redirectUrl() {
    
    let url = URL(string: "https://cors-anywhere.herokuapp.com/https://community.gethopscotch.com/api/v2/users/2")!
    //let url = URL(string: "https://unusuallybrilliant.com")!
 
    
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in

        let html = String(data: data!, encoding: .utf8) ?? "none"
        parse(html: html)
        go = false
    }.resume()


}

func parse(html: String) {

    do {

        let doc = try SwiftSoup.parse(html)
        let link: Element = try doc.select("a").first()!
        let linkHref = try link.attr("href")

        print(doc)
        print(linkHref)
    } catch let error {
        print(error.localizedDescription)
    }

}

redirectUrl()
while go {}
go = true
print("DONE")
fatalError()



func tester() {
    let url = URL(string: "https://unusuallybrilliant.com")!

    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else { return }
        guard let htmlString = String(data: data, encoding: .utf8) else { return }

        let names = htmlString.matching(regex: "href=\"/user/(.*?)\"")
        let imageUrls = htmlString.matching(regex: "><img src=\"(.*?)\" style")
        print(htmlString)
        print(names)
        print(imageUrls)
        go = false
    }
    task.resume()
}

extension String {
    func matching(regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let result  = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return result.map {
            return String(self[Range($0.range, in: self)!])
        }
    }
}

print("foo")
tester()

while go {}


//let $_$ = 1
//let fo$ = 1
//let $$$$$$$ = 1
//
//print($$)
//
//
//
//enum Foo: String {
//    // Use of '#file' literal as raw value for enum case is not supported
//    case b = #file
//    // Use of '#function' literal as raw value for enum case is not supported
//    case c = #function
//}
//
//enum B: Int {
//    // Error: Use of '#line' literal as raw value for enum case is not supported
//    case b = #line
//    // Error: Use of '#column' literal as raw value for enum case is not supported
//    case c = #column
//
//}
//
//extension UnsafeRawPointer: ExpressibleByIntegerLiteral {}
//enum Wo: UnsafeRawPointer {
//    // Error: Use of '##dsohandle' literal as raw value for enum case is not supported
//    case wo = #dsohandle
//}
//
//
//extension Optional: ExpressibleByIntegerLiteral where Wrapped == Int {}
//enum Foo: Int? {
//    // Compiler Crashes: Segmentation fault: 11
//    //case c = nil
//}
//

//let url = URL(string: "https://awesome-e.github.io/hs-tools/explore-channel/user.html?u=2-&channel=Published")!
