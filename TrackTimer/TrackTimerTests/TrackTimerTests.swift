//
//  TrackTimerTests.swift
//  TrackTimerTests
//
//  Created by Miguel Davalos on 4/20/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import XCTest
@testable import TrackTimer
import CoreData

class TrackTimerTests: XCTestCase {
    
    let coreDataStack = CoreDataStack.shared
    var moc: NSManagedObjectContext! = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInsertion() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        func insertTestData() {
            let coreDataStack = CoreDataStack.shared
            var moc: NSManagedObjectContext! = nil
            
            moc = coreDataStack.viewContext
            let person: Athlete = Athlete(context: moc)
            person.firstName = "Miguel"
            person.lastName = "Davalos"
            person.gender = "Male"
            person.dateOfBirth = "3/31/1995"
            person.teamName = "Capital"
            person.year = "Senior"
            
            let person2 = Athlete(context: moc)
            person2.firstName = "John"
            person2.lastName = "Doe"
            person2.gender = "Male"
            person2.dateOfBirth = "1/1/1996"
            person2.teamName = "Capital"
            person2.year = "Junior"
            
            let person3 = Athlete(context: moc)
            person3.firstName = "Tyler"
            person3.lastName = "Franks"
            person3.gender = "Male"
            person3.dateOfBirth = "7/5/1996"
            person3.teamName = "Capital"
            person3.year = "Sophomore"
            
            let person4 = Athlete(context: moc)
            person4.firstName = "Santiago"
            person4.lastName = "Dominguez"
            person4.gender = "Male"
            person4.dateOfBirth = "2/23/1997"
            person4.teamName = "Capital"
            person4.year = "Freshman"
            
            let person5 = Athlete(context: moc)
            person5.firstName = "Jose"
            person5.lastName = "Fernandez"
            person5.gender = "Male"
            person5.dateOfBirth = "8/13/1994"
            person5.teamName = "Capital"
            person5.year = "Senior"
            
            let person6 = Athlete(context: moc)
            person6.firstName = "Erica"
            person6.lastName = "Jospeh"
            person6.gender = "Female"
            person6.dateOfBirth = "12/1/1995"
            person6.teamName = "Capital"
            person6.year = "Senior"
            
            let person7 = Athlete(context: moc)
            person7.firstName = "Jane"
            person7.lastName = "Doe"
            person7.gender = "Female"
            person7.dateOfBirth = "1/9/1996"
            person7.teamName = "Capital"
            person7.year = "Junior"
            
            let person8 = Athlete(context: moc)
            person8.firstName = "Kelly"
            person8.lastName = "Franks"
            person8.gender = "Female"
            person8.dateOfBirth = "10/23/1996"
            person8.teamName = "Capital"
            person8.year = "Sophomore"
            
            let person9 = Athlete(context: moc)
            person9.firstName = "Maria"
            person9.lastName = "Dominguez"
            person9.gender = "Female"
            person9.dateOfBirth = "8/3/1997"
            person9.teamName = "Capital"
            person9.year = "Freshman"
            
            let person10 = Athlete(context: moc)
            person10.firstName = "Teresa"
            person10.lastName = "Fernandez"
            person10.gender = "Female"
            person10.dateOfBirth = "5/5/1994"
            person10.teamName = "Capital"
            person10.year = "Senior"
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
