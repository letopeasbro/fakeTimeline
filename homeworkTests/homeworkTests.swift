//
//  homeworkTests.swift
//  homeworkTests
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import XCTest
@testable import homework

class homeworkTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPageTweets() {
        let provider = MomentsTweetProvider()
        
        let JSONData = try! Data(contentsOf: Bundle(for: homeworkTests.self).url(forResource: "tweets", withExtension: "json")!)
        let dataSource = try! JSONDecoder().decode([Moments.Tweet].self, from: JSONData)
        var next = 0
        let count = 5
        var tweets: [Moments.Tweet] = []
        
        let page1 = provider.page(dataSource, start: next, count: count)
        tweets = page1.result
        next = page1.next
        tweets.forEach({ XCTAssertTrue(provider.checkTweet($0)) })
        XCTAssertTrue(tweets.count == count)
        // 按文档里需求只有发送人头像为无效tweet, 计算出这里确实为第一页最后一条
        XCTAssertTrue(tweets.last?.content == "这是第二页第一条")
        XCTAssertTrue(next == 7)
        
        let page2 = provider.page(dataSource, start: next, count: count)
        tweets = page2.result
        next = page2.next
        XCTAssertTrue(tweets.last?.content == "第10条！")
        tweets.forEach({ XCTAssertTrue(provider.checkTweet($0)) })
        XCTAssertTrue(tweets.count == count)
        XCTAssertTrue(next == 16)
        
        let page3 = provider.page(dataSource, start: next, count: count)
        tweets = page3.result
        next = page3.next
        XCTAssertTrue(tweets.first?.content == "楼下保持队形，第11条")
        tweets.forEach({ XCTAssertTrue(provider.checkTweet($0)) })
        XCTAssertTrue(tweets.last?.comments == nil)
        XCTAssertTrue(tweets.count == count)
        XCTAssertTrue(next == 22)
        
        let page4 = provider.page(dataSource, start: next, count: count)
        tweets = page4.result
        next = page4.next
        XCTAssertTrue(tweets.count == 0)
        XCTAssertTrue(next == 22)
        
        let test1 = provider.page(dataSource, start: 21, count: 5)
        tweets = test1.result
        next = test1.next
        tweets.forEach({ XCTAssertTrue(provider.checkTweet($0)) })
        XCTAssertTrue(tweets.last?.sender?.username == "hengzeng")
        XCTAssertTrue(tweets.count == 1)
        XCTAssertTrue(next == 22)
    }
    
    func testWebImageMemoryMultithreadedCache() {
        let queue = DispatchQueue(label: "testWebImageMemoryMultithreadedCache", attributes: .concurrent)
        let image = UIImage(contentsOfFile: Bundle(for: homeworkTests.self).path(forResource: "test", ofType: "png")!)!
        var count = 0
        
        let exception = self.expectation(description: "testWebImageMemoryMultithreadedCache")
        
        for i in 0 ..< 100 {
            queue.async {
                WebImageLoader.cacheImage(image, toMemory: "\(i)")
                count += 1
                if count == 100 {
                    exception.fulfill()
                }
            }
        }
        
        self.wait(for: [exception], timeout: 10)
    }
}
