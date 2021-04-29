//
//  CodingCode2Tests.swift
//  CodingCode2Tests
//
//  Created by Jonathan Pappas on 4/29/21.
//

import XCTest

class CodingCode2Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Simple Test with an `add function`
    func test1() {
        
        var saved = 0
        let shortProgram: [StackCode] = [
            
            .functionWithParams(name: "print", parameters: .any, returnType: .void, code: { param in [
                .program({ magicPrint(param) }),
                .program({ saved = int(param[0]) }),
            ]}),
            
            .functionWithParams(name: "add", parameters: .tuple([.int, .int]), returnType: .int, code: { param in [
                .program({ print("It was too harsh \(int(param[0]) + int(param[1]))") }),
                .returnValue([ (.int, (int(param[0]) + int(param[1]))) ])
            ]}),
            
            .goToFunction(name: "print", parameters: [(.int, .goToFunction(name: "add", parameters: [(.int, .literal(.int, 5)), (.int, .literal(.int, 6))]))]),   
        ]

        shortProgram.run()
        XCTAssert(saved == 5 + 6)

        
    }

}
