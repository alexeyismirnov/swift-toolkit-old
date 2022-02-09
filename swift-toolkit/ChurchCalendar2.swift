//
//  ChurchCalendar2.swift
//  ponomar
//
//  Created by Alexey Smirnov on 1/13/22.
//  Copyright © 2022 Alexey Smirnov. All rights reserved.
//

import Foundation

public class ChurchDay : Hashable, Equatable  {
    public var name : String
    public var type : FeastType
    public var date: Date?
    public var reading : String
    public var comment: String
    
    init(_ name: String = "", _ type: FeastType = .none, date: Date? = nil, reading: String = "", comment: String = "") {
        self.name = name
        self.type = type
        self.date = date
        self.reading = reading
        self.comment = comment
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(reading)
    }
    
    public static func == (lhs: ChurchDay, rhs: ChurchDay) -> Bool {
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.date == rhs.date &&
        lhs.reading == rhs.reading
    }
}

public class ChurchCalendar2 {
    public var year: Int
    var days = [ChurchDay]()
    
    public var startOfYear, endOfYear : Date
    public var greatLentStart, pascha, pentecost : Date
    
    static var calendars = [Int:ChurchCalendar2]()
    
    static public func fromDate(_ date: Date) -> ChurchCalendar2 {
        let year = DateComponents(date: date).year!
        
        if calendars[year] == nil {
            calendars[year] = ChurchCalendar2(date)
        }
        
        return calendars[year]!
    }
    
    init(_ date: Date) {
        let dateComponents = DateComponents(date: date)
        year = dateComponents.year!
        
        startOfYear = Date(1, 1, year)
        endOfYear = Date(31, 12, year)
        
        pascha = Cal2.paschaDay(year)
        greatLentStart = pascha-48.days
        pentecost = pascha+49.days
        
        initDays()
        initGreatLent()
        initSatSun()
        initMisc()
        initBeforeAfterFeasts()
    }
    
    func initDays() {
        days = [
            ChurchDay("palmSunday", .great, reading: "Phil 4:4-9 John 12:1-18"),
            ChurchDay("pascha", .great, reading: "Acts 1:1-8 John 1:1-17"),
            ChurchDay("ascension", .great, reading: "Acts 1:1-12 Luke 24:36-53"),
            ChurchDay("pentecost", .great, reading: "Acts 2:1-11 John 7:37-52,8:12"),
            ChurchDay("nativityOfGod", .great, date:  Date(7,  1, year), reading: "Matthew 1:18-25 Gal 4:4-7 Matthew 2:1-12"),
            ChurchDay("theophany", .great, date:  Date(19, 1, year), reading: "Mark 1:9-11 Tit 2:11-14,3:4-7 Matthew 3:13-17"),
            ChurchDay("meetingOfLord", .great, date: Date(15, 2, year), reading: "Luke 2:25-32 Heb 7:7-17 Luke 2:22-40"),
            ChurchDay("annunciation", .great, date: Date(7,  4, year), reading: "Luke 1:39-49,56 Heb 2:11-18 Luke 1:24-38 # Theotokos"),
            ChurchDay("peterAndPaul", .great, date: Date(12, 7, year), reading: "John 21:15-25 2Cor 11:21-12:9 Matthew 16:13-19"),
            ChurchDay("transfiguration", .great, date: Date(19, 8, year), reading: "Luke 9:28-36 2Pet 1:10-19 Matthew 17:1-9"),
            ChurchDay("dormition", .great, date: Date(28, 8, year), reading: "Luke 1:39-49,56 Phil 2:5-11 Luke 10:38-42,11:27-28"),
            ChurchDay("nativityOfTheotokos", .great, date: Date(21, 9, year), reading: "Luke 1:39-49,56 Phil 2:5-11 Luke 10:38-42,11:27-28"),
            ChurchDay("exaltationOfCross", .great, date: Date(27, 9, year), reading: "John 12:28-36 1Cor 1:18-24 John 19:6-11,13-20,25-28,30-35"),
            ChurchDay("entryIntoTemple", .great, date: Date(4,  12, year), reading: "Luke 1:39-49,56 Heb 9:1-7 Luke 10:38-42,11:27-28"),
            ChurchDay("circumcision", .great, date: Date(14, 1, year), reading: "John 10:1-9 Col 2:8-12 Luke 2:20-21,40-52"),
            ChurchDay("veilOfTheotokos", .great, date: Date(14, 10, year), reading: "Luke 1:39-49,56 Heb 9:1-7 Luke 10:38-42,11:27-28"),
            ChurchDay("nativityOfJohn", .great, date: Date(7,  7, year), reading: "Luke 1:24-25,57-68,76,80 Rom 13:12-14:4 Luke 1:5-25,57-68,76,80"),
            ChurchDay("beheadingOfJohn", .great, date: Date(11, 9, year), reading: "Matthew 14:1-13 Acts 13:25-32 Mark 6:14-30"),
            
            ChurchDay("", .doxology, date: Date(20, 1, year),
                      reading: "Acts 19:1-8 John 1:29-34 # Forerunner",
                      comment: "Synaxis of John Baptist"),
            
            ChurchDay("eveOfNativityOfGod", .noSign, date: Date(6,  1, year), reading: "Heb 1:1-12 Luke 2:1-20"),
            ChurchDay("eveOfTheophany", .noSign, date: Date(18, 1, year), reading: "1Cor 9:19-27 Luke 3:1-18 # Epiphany Eve"),
            
            ChurchDay("sundayOfPublicianAndPharisee", .none),
            ChurchDay("sundayOfProdigalSon", .none),
            ChurchDay("sundayOfDreadJudgement", .none),
            ChurchDay("cheesefareSunday", .none),
            ChurchDay("beginningOfGreatLent", .none),
            ChurchDay("beginningOfDormitionFast", .none, date: Date(14, 8, year)),
            ChurchDay("beginningOfNativityFast", .none, date: Date(28, 11, year)),
            ChurchDay("beginningOfApostlesFast", .none),
            ChurchDay("sundayOfForefathers", .none),
            
            ChurchDay("saturdayAfterNativity", .none, reading: "1Tim 6:11-16 Matthew 12:15-21 # Saturday after the Nativity"),
            ChurchDay("sundayAfterNativity", .none, reading: "Gal 1:11-19 Matthew 2:13-23 # Sunday after the Nativity"),

            ChurchDay("saturdayBeforeExaltation", .none, reading: "1Cor 2:6-9 Matthew 10:37-11:1 # Saturday before the Universal Elevation"),
            ChurchDay("sundayBeforeExaltation", .none, reading: "Gal 6:11-18 John 3:13-17 # Sunday before the Universal Elevation"),
            ChurchDay("saturdayAfterExaltation", .none, reading: "1Cor 1:26-29 John 8:21-30 # Saturday after the Universal Elevation"),
            ChurchDay("sundayAfterExaltation", .none, reading: "Gal 2:16-20 Mark 8:34-9:1 # Sunday after the Universal Elevation"),

            ChurchDay("saturdayBeforeTheophany", .none, reading: "1Tim 3:14-4:5 Matthew 3:1-11 # Saturday before the Theophany"),
            ChurchDay("sundayBeforeTheophany", .none, reading: "2Tim 4:5-8 Mark 1:1-8 # Sunday before the Theophany"),
            ChurchDay("saturdayAfterTheophany", .none, reading: "Ephes 6:10-17 Matthew 4:1-11 # Saturday after the Theophany"),
            ChurchDay("sundayAfterTheophany", .none, reading: "Ephes 4:7-13 Matthew 4:12-17 # Sunday after the Theophany"),
            
            ChurchDay("saturday1GreatLent", .noSign, reading: "2Tim 2:1-10 John 15:17-16:2 # Great Martyr"),
            ChurchDay("sunday1GreatLent", .none),
            ChurchDay("saturday2GreatLent", .none, reading: "1Thess 4:13-17 John 5:24-30 # Departed"),
            ChurchDay("sunday2GreatLent", .noSign, reading: "Heb 7:26-8:2 John 10:9-16 # Saint"),
            ChurchDay("saturday3GreatLent", .none, reading: "1Thess 4:13-17 John 5:24-30 # Departed"),
            ChurchDay("sunday3GreatLent", .none),
            ChurchDay("saturday4GreatLent", .none, reading: "1Cor 15:47-57 John 5:24-30 # Departed"),
            ChurchDay("sunday4GreatLent", .noSign, reading: "Ephes 5:8-19 Matthew 4:25-5:12 # Venerable"),
            ChurchDay("thursday5GreatLent", .none),
            ChurchDay("saturday5GreatLent", .none, reading: "Heb 9:1-7 Luke 10:38-42,11:27-28 # Theotokos"),
            ChurchDay("sunday5GreatLent", .none, reading: "Gal 3:23-29 Luke 7:36-50 # Venerable"),
            
            ChurchDay("sunday2AfterPascha", .none),
            ChurchDay("sunday3AfterPascha", .none),
            ChurchDay("sunday4AfterPascha", .none),
            ChurchDay("sunday5AfterPascha", .none),
            ChurchDay("sunday6AfterPascha", .none),
            ChurchDay("sunday7AfterPascha", .none),
            
            ChurchDay("sunday1AfterPentecost", .none),
            ChurchDay("sunday2AfterPentecost", .none, reading: "Heb 11:33-12:2 Matthew 4:25-5:12 # Saints"),
            
            ChurchDay("saturdayOfFathers", .noSign, reading: "Gal 5:22-6:2 Matthew 11:27-30 # Fathers"),
            ChurchDay("saturdayTrinity", .none, reading: "1Cor 15:47-57 John 6:35-39 # Departed"),
            ChurchDay("saturdayOfDeparted", .none, reading: "1Thess 4:13-17 John 5:24-30 # Departed"),
            ChurchDay("lazarusSaturday", .none),
            
            ChurchDay("newMartyrsConfessorsOfRussia", .vigil, reading: "Rom 8:28-39 Luke 21:8-19 # Martyrs"),
            ChurchDay("demetriusSaturday", .none),
            ChurchDay("radonitsa", .none),
            ChurchDay("killedInAction", .none, date: Date(9,  5, year)),
            ChurchDay("josephBetrothed", .noSign),
            ChurchDay("holyFathersSixCouncils", .none, reading: "Heb 13:7-16 John 17:1-13 # Fathers"),
            ChurchDay("holyFathersSeventhCouncil", .none),
            
            ChurchDay("", .vigil, date: Date(30, 1, year),
                      reading: "Heb 13:17-21 Luke 6:17-23 # Venerable",
                      comment: "Anthony the Great"),
            
            ChurchDay("", .vigil, date: Date(2, 2, year),
                      reading: "Heb 13:17-21 Luke 6:17-23 # Venerable",
                      comment: "Euthymius the Great"),
            
            ChurchDay("", .vigil, date: Date(12, 2, year),
                      reading: "Heb 13:7-16 Matthew 5:14-19 # Hierarchs",
                      comment: "Synaxis of the Three Hierarchs"),
            
            ChurchDay("", .vigil, date: Date(6, 5, year),
                      reading: "Acts 12:1-11 John 15:17-16:2 # Great Martyr",
                      comment: "Victory-bearer George"),
            
            ChurchDay("", .vigil, date: Date(21, 5, year),
                      reading: "1John 1:1-7 John 19:25-27,21:24-25 # Apostle",
                      comment: "Apostle John"),
            
            ChurchDay("", .vigil, date: Date(24, 5, year),
                      reading: "Heb 7:26-8:2 Matthew 5:14-19 # Equals-to-the Apostles",
                      comment: "Methodius and Cyril"),
            
            ChurchDay("", .vigil, date: Date(28, 7, year),
                      reading: "Gal 1:11-19 John 10:1-9 # Equal-to-the Apostles",
                      comment: "Great Prince Vladimir"),
            
            ChurchDay("", .vigil, date: Date(1, 8, year),
                      reading: "Gal 5:22-6:2 Luke 6:17-23 # Venerable",
                      comment: "Seraphim of Sarov"),
            
            ChurchDay("", .vigil, date: Date(2, 8, year),
                      reading: "James 5:10-20 Luke 4:22-30 # Prophet",
                      comment: "Prophet Elias"),
            
            ChurchDay("", .polyeleos, date: Date(14, 9, year),
                      reading: "1Tim 2:1-7 Luke 4:16-22 # New Year",
                      comment: "New Year"),
            
            ChurchDay("", .vigil, date: Date(9, 10, year),
                      reading: "1John 4:12-19 John 19:25-27,21:24-25 # Repose of the John the Theologian",
                      comment: "Apostle John"),
            
            ChurchDay("", .vigil, date: Date(26, 11, year),
                      reading: "Heb 7:26-8:2 John 10:9-16 # St. John",
                      comment: "St. John Chrysostom"),
            
            ChurchDay("", .vigil, date: Date(18, 12, year),
                      reading: "Gal 5:22-6:2 Matthew 11:27-30 # Venerable",
                      comment: "Venerable Sabbas"),
            
            ChurchDay("", .vigil, date: Date(19, 12, year),
                      reading: "Heb 13:17-21 Luke 6:17-23 # St. Nicholas",
                      comment: "St. Nicholas"),
            
        ]
    }
    
    func initGreatLent() {
        // TRIODION
        day("sundayOfPublicianAndPharisee").date = greatLentStart-22.days
        day("sundayOfProdigalSon").date = greatLentStart-15.days
        day("saturdayOfDeparted").date = greatLentStart-9.days
        day("sundayOfDreadJudgement").date = greatLentStart-8.days
        day("saturdayOfFathers").date = greatLentStart-2.days
        day("cheesefareSunday").date = greatLentStart-1.days
        
        // GREAT LENT
        day("beginningOfGreatLent").date = greatLentStart
        day("saturday1GreatLent").date = greatLentStart+5.days
        day("sunday1GreatLent").date = greatLentStart+6.days
        day("saturday2GreatLent").date = greatLentStart+12.days
        day("sunday2GreatLent").date = greatLentStart+13.days
        day("saturday3GreatLent").date = greatLentStart+19.days
        day("sunday3GreatLent").date = greatLentStart+20.days
        day("saturday4GreatLent").date = greatLentStart+26.days
        day("sunday4GreatLent").date = greatLentStart+27.days
        day("thursday5GreatLent").date = greatLentStart+31.days
        day("saturday5GreatLent").date = greatLentStart+33.days
        day("sunday5GreatLent").date = greatLentStart+34.days
        
        day("lazarusSaturday").date = pascha-8.days
        day("palmSunday").date = pascha-7.days
        days.append(ChurchDay("greatMonday", .none, date: pascha-6.days))
        days.append(ChurchDay("greatTuesday", .none, date: pascha-5.days))
        days.append(ChurchDay("greatWednesday", .none, date: pascha-4.days))
        days.append(ChurchDay("greatThursday", .none, date: pascha-3.days))
        days.append(ChurchDay("greatFriday", .none, date: pascha-2.days))
        days.append(ChurchDay("greatSaturday", .none, date: pascha-1.days))
        
        // PASCHA
        day("pascha").date = pascha
        day("sunday2AfterPascha").date = pascha+7.days
        day("radonitsa").date = pascha+9.days
        day("sunday3AfterPascha").date = pascha+14.days
        day("sunday4AfterPascha").date = pascha+21.days
        days.append(ChurchDay("midPentecost", .none, date: pascha+24.days))
        day("sunday5AfterPascha").date = pascha+28.days
        day("sunday6AfterPascha").date = pascha+35.days
        day("ascension").date = pascha+39.days
        day("sunday7AfterPascha").date = pascha+42.days
        day("saturdayTrinity").date = pascha+48.days
        
        // PENTECOST
        day("pentecost").date = pascha+49.days
        days.append(ChurchDay("holySpirit", .none, date: pentecost+1.days))
        day("beginningOfApostlesFast").date = pentecost+8.days
        day("sunday1AfterPentecost").date = pentecost+7.days
        day("sunday2AfterPentecost").date = pentecost+14.days
    }
    
    func initSatSun() {
        func saturdayBeforeNativity(_ date: Date) -> ChurchDay {
            ChurchDay("saturdayBeforeNativity", .none, date: date, reading: "Gal 3:8-12 Luke 13:18-29 # Saturday before the Nativity")
        }
        
        func sundayBeforeNativity(_ date: Date) -> ChurchDay {
            ChurchDay("sundayBeforeNativity", .none, date: date, reading: "Heb 11:9-10,17-23,32-40 Matthew 1:1-25 # Sunday before the Nativity")
        }
        
        // EXALTATION SAT & SUN
        let exaltation = Date(27, 9, year)
        let exaltationWeekday = DateComponents(date: exaltation).weekday!
        let exaltationSatOffset = (exaltationWeekday == 7) ? 7 : 7-exaltationWeekday
        let exaltationSunOffset = (exaltationWeekday == 1) ? 7 : exaltationWeekday-1

        day("sundayAfterExaltation").date = exaltation + (8-exaltationWeekday).days
        day("saturdayAfterExaltation").date = exaltation + exaltationSatOffset.days
        day("sundayBeforeExaltation").date = exaltation - exaltationSunOffset.days
        day("saturdayBeforeExaltation").date = exaltation - exaltationWeekday.days
       
        // NATIVITY SAT & SUN
        let nativity = Date(7, 1, year)
        let nativityWeekday = DateComponents(date:nativity).weekday!
        let nativitySunOffset = (nativityWeekday == 1) ? 7 : (nativityWeekday-1)
        let nativitySatOffset = (nativityWeekday == 7) ? 7 : 7-nativityWeekday
        
        if nativitySunOffset != 7 {
            days.append(sundayBeforeNativity(nativity - nativitySunOffset.days))
        }

        if nativityWeekday != 7 {
            days.append(saturdayBeforeNativity(nativity - nativityWeekday.days))
        }

        day("sundayAfterNativity").date = nativity + (8-nativityWeekday).days
        day("saturdayAfterNativity").date = nativity + nativitySatOffset.days

        if nativityWeekday == 1 {
            day("josephBetrothed").date = nativity + 1.days

        } else {
            day("josephBetrothed").date = nativity + (8-nativityWeekday).days
        }
        
        let nativityNextYear = Date(7, 1, year+1)
        let nativityNextYearWeekday = DateComponents(date:nativityNextYear).weekday!
        var nativityNextYearSunOffset = (nativityNextYearWeekday == 1) ? 7 : (nativityNextYearWeekday-1)

        if nativityNextYearSunOffset == 7 {
            days.append(sundayBeforeNativity(Date(31, 12, year)))
        }
        
        if nativityNextYearWeekday == 7 {
            days.append(saturdayBeforeNativity(Date(31, 12, year)))
        }
        
        nativityNextYearSunOffset += 7
        day("sundayOfForefathers").date = nativityNextYear - nativityNextYearSunOffset.days
        
        // THEOPHANY SAT & SUN
        let theophany = Date(19, 1, year)
        let theophanyWeekday = DateComponents(date:theophany).weekday!

        let theophanySunOffset = (theophanyWeekday == 1) ?  7 : (theophanyWeekday-1)
        let theophanySatOffset = (theophanyWeekday == 7) ? 7 : 7-theophanyWeekday
        
        day("sundayBeforeTheophany").date = theophany - theophanySunOffset.days
        day("saturdayBeforeTheophany").date = theophany - theophanyWeekday.days
        day("sundayAfterTheophany").date = theophany + (8-theophanyWeekday).days
        day("saturdayAfterTheophany").date = theophany + theophanySatOffset.days
        
        // DEMETRIUS SAT
        let demetrius = Date(8, 11, year)
        let demetriusWeekday = DateComponents(date: demetrius).weekday!
        day("demetriusSaturday").date = demetrius - demetriusWeekday.days
        
    }
    
    func initMisc() {
        day("newMartyrsConfessorsOfRussia").date = nearestSunday(Date(7,2,year))
        day("holyFathersSixCouncils").date = nearestSunday(Date(29, 7, year))
        day("holyFathersSeventhCouncil").date = nearestSunday(Date(24, 10, year))
        
        // SYNAXIS
        days.append(ChurchDay("synaxisKievCavesSaints", .none, date: greatLentStart+13.days))
        days.append(ChurchDay("synaxisMartyrsButovo", .none, date: pascha+27.days))
        days.append(ChurchDay("synaxisMountAthosSaints", .none, date: pentecost+14.days))
        
        if Translate.language == "ru" {
            days.append(ChurchDay("synaxisMoscowSaints", .none, date: ChurchCalendar2.nearestSundayBefore(Date(8, 9, year))))
            days.append(ChurchDay("synaxisNizhnyNovgorodSaints", .none, date: ChurchCalendar2.nearestSundayAfter(Date(8, 9, year))))
        }
        
        let synaxisTheotokos = Date(8, 1, year)
        let synaxisTheotokosW = DayOfWeek(rawValue: synaxisTheotokos.weekday)
        
        if synaxisTheotokosW == .monday {
            days.append(ChurchDay("", .doxology, date: synaxisTheotokos, reading: "Heb 2:11-18 # Theotokos"))
            days.append(ChurchDay("", .doxology, date: synaxisTheotokos, reading: "Gal 1:11-19 Matthew 2:13-23 # Holy Ancestors"))
            
        } else if synaxisTheotokosW != .sunday {
            days.append(ChurchDay("", .doxology, date: synaxisTheotokos, reading: "Heb 2:11-18 Matthew 2:13-23 # Theotokos"))
        }
        
        days.append(ChurchDay("josephArimathea", .noSign, date: pascha+14.days))
        days.append(ChurchDay("tamaraGeorgia", .noSign, date: pascha+14.days))
        days.append(ChurchDay("abrahamBulgar", .noSign, date: pascha+21.days))
        days.append(ChurchDay("tabithaJoppa", .noSign, date: pascha+21.days))
        
        // ICONS OF THEOTOKOS
        days.append(ChurchDay("iveronTheotokos", .none, date: pascha+2.days))
        days.append(ChurchDay("springTheotokos", .none, date: pascha+5.days))
        days.append(ChurchDay("mozdokTheotokos", .none, date: pascha+24.days))
        days.append(ChurchDay("chelnskoyTheotokos", .none, date: pascha+42.days))
        days.append(ChurchDay("tupichevskTheotokos", .none, date: pentecost+1.days))
        days.append(ChurchDay("koretsTheotokos", .none, date: pentecost+4.days))
        days.append(ChurchDay("softenerTheotokos", .none, date: pentecost+7.days))
    }
    
    func generateBeforeAfter(feast: String,
                             daysBefore: Int = 0, signBefore: FeastType = .noSign,
                             daysAfter: Int = 0, signAfter: FeastType = .noSign,
                             signApodosis: FeastType = .doxology) {
        
        let date = d(feast)
        let eve1 = d("eveOfNativityOfGod")
        let eve2 = d("eveOfTheophany")

        if daysBefore > 0 {
            for forefeast in DateRange(date-daysBefore.days, date-1.days) {
                if forefeast != eve1 && forefeast != eve2 {
                    days.append(ChurchDay("forefeast_\(feast)", signBefore, date: forefeast))
                }
            }
        }
        
        if daysAfter > 0 {
            for afterfeast in DateRange(date+1.days, date+daysAfter.days) {
                days.append(ChurchDay("afterfeast_\(feast)", signAfter, date: afterfeast))
            }
        }
        
        days.append(ChurchDay("apodosis_\(feast)", signApodosis, date: date+(daysAfter+1).days))

    }
    
    func initBeforeAfterFeasts() {
        days.append(ChurchDay("apodosis_pascha", .none, date: pascha+38.days))
        
        generateBeforeAfter(feast: "ascension",
                            daysAfter: 7, signAfter: .none,
                            signApodosis: .none)
        
        generateBeforeAfter(feast: "pentecost",
                            daysAfter: 5, signAfter: .none,
                            signApodosis: .none)
                
        generateBeforeAfter(feast: "nativityOfGod", daysBefore: 5, daysAfter: 5)
        generateBeforeAfter(feast: "theophany", daysBefore: 4, daysAfter: 7, signApodosis: .noSign)
        generateBeforeAfter(feast: "transfiguration", daysBefore: 1, signBefore: .sixVerse, daysAfter: 6)
        generateBeforeAfter(feast: "dormition", daysBefore: 1, signBefore: .sixVerse, daysAfter: 7)
        generateBeforeAfter(feast: "nativityOfTheotokos", daysBefore: 1, signBefore: .sixVerse, daysAfter: 3)
        generateBeforeAfter(feast: "exaltationOfCross", daysBefore: 1, daysAfter: 6)
        generateBeforeAfter(feast: "entryIntoTemple", daysBefore: 1, daysAfter: 3)

        let annunciation = d("annunciation")
        
        switch annunciation {
        case greatLentStart ..< d("lazarusSaturday"):
            days.append(ChurchDay("forefeast_annunciation", .sixVerse, date: annunciation-1.days))
            days.append(ChurchDay("apodosis_annunciation", .doxology, date: annunciation+1.days))

        case d("lazarusSaturday"):
            days.append(ChurchDay("forefeast_annunciation", .sixVerse, date: annunciation-1.days))

        default:
            break
        }
        
        let meetingOfLord = d("meetingOfLord")
        days.append(ChurchDay("forefeast_meetingOfLord", .sixVerse, date: meetingOfLord-1.days))

        var lastDay = meetingOfLord
        
        switch (meetingOfLord) {
        case startOfYear ..< d("sundayOfProdigalSon")-1.days:
            lastDay = meetingOfLord+7.days

        case d("sundayOfProdigalSon")-1.days ... d("sundayOfProdigalSon")+2.days:
            lastDay = d("sundayOfProdigalSon")+5.days

        case d("sundayOfProdigalSon")+3.days ..< d("sundayOfDreadJudgement"):
            lastDay = d("sundayOfDreadJudgement") + 2.days
            
        case d("sundayOfDreadJudgement") ... d("sundayOfDreadJudgement")+1.days:
            lastDay = d("sundayOfDreadJudgement") + 4.days

        case d("sundayOfDreadJudgement")+2.days ... d("sundayOfDreadJudgement")+3.days:
            lastDay = d("sundayOfDreadJudgement") + 6.days

        case d("sundayOfDreadJudgement")+4.days ... d("sundayOfDreadJudgement")+6.days:
            lastDay = d("cheesefareSunday")

        default:
            break
        }
        
        if (lastDay != meetingOfLord) {
            for afterfeastDay in DateRange(meetingOfLord+1.days, lastDay-1.days) {
                days.append(ChurchDay("afterfeast_meetingOfLord", .noSign, date: afterfeastDay))
            }
            days.append(ChurchDay("apodosis_meetingOfLord", .doxology, date: lastDay))
        }

    }
    
    public func d(_ name: String) -> Date {
        day(name).date!
    }
    
    public func day(_ name: String) -> ChurchDay {
        days.filter() { $0.name == name }.first!
    }
    
}

public extension ChurchCalendar2 {
    var isLeapYear: Bool {
        get { (year % 400) == 0 || ((year % 4 == 0) && (year % 100 != 0)) }
    }
    
    var leapStart: Date {
        get { Date(29, 2, year) }
    }
    
    var leapEnd: Date {
        get { Date(13, 3, year) }
    }
}

public extension ChurchCalendar2 {    
    static func paschaDay(_ year: Int) -> Date {
        // http://calendar.lenacom.spb.ru/index.php
        let a = (19*(year%19) + 15) % 30
        let b = (2*(year%4) + 4*(year%7) + 6*a + 6) % 7

        return  ((a+b > 10) ? Date(a+b-9, 4, year) : Date(22+a+b, 3, year)) + 13.days
    }
    
    static func nearestSundayAfter(_ date: Date) -> Date {
        let weekday = DateComponents(date:date).weekday!
        let sunOffset = (weekday == 1) ? 0 : 8-weekday
        return date + sunOffset.days
    }

    static func nearestSundayBefore(_ date: Date) -> Date {
        let weekday = DateComponents(date:date).weekday!
        let sunOffset = (weekday == 1) ? 0 : weekday-1
        return date - sunOffset.days
    }
    
    static func getGreatFeast(_ date: Date) -> [ChurchDay]  {
        Cal2.fromDate(date).days.filter({ $0.date == date && $0.type == .great})
    }
    
    func nearestSunday(_ date: Date) -> Date {
        let weekday = DayOfWeek(rawValue: DateComponents(date:date).weekday!)!
        
        switch (weekday) {
        case .sunday:
            return date
            
        case .monday, .tuesday, .wednesday:
            return ChurchCalendar2.nearestSundayBefore(date)
            
        default:
            return ChurchCalendar2.nearestSundayAfter(date)
        }
    }
    
    func getDayDescription(_ date: Date) -> [ChurchDay] {
        days
            .filter({ $0.date == date && $0.name.count > 0 })
            .sorted { $0.type.rawValue < $1.type.rawValue }
    }
    
    func getDayReadings(_ date: Date) -> [ChurchDay] {
        days
            .filter({ $0.date == date && $0.reading.count > 0 })
            .sorted { $0.type.rawValue < $1.type.rawValue }
    }
    
    func getAllReadings() -> [ChurchDay] {
        days.filter({ $0.reading.count > 0 })
    }
    
    func getWeekDescription(_ date: Date) -> String? {
        let weekday = DayOfWeek(date: date)!
        let dayOfWeek = (weekday == .sunday) ? "Sunday" : "Week"
    
        switch (date) {
        case startOfYear ..< d("sundayOfPublicianAndPharisee"):
            return  String(format: Translate.s("\(dayOfWeek)AfterPentecost"),
                           Translate.stringFromNumber(((Cal2.paschaDay(year-1)+50.days) >> date)/7+1))
            
        case d("sundayOfPublicianAndPharisee")+1.days ..< d("sundayOfProdigalSon"):
            return Translate.s("weekOfPublicianAndPharisee")

        case d("sundayOfProdigalSon")+1.days ..< d("sundayOfDreadJudgement"):
            return Translate.s("weekOfProdigalSon")

        case d("sundayOfDreadJudgement")+1.days ..< d("cheesefareSunday"):
            return Translate.s("weekOfDreadJudgement")

        case d("beginningOfGreatLent") ..< d("palmSunday"):
            return  String(format: Translate.s("\(dayOfWeek)OfGreatLent"),
                           Translate.stringFromNumber((d("beginningOfGreatLent") >> date)/7+1))
        
        case d("palmSunday")+1.days ..< pascha:
            return Translate.s("holyWeek")
            
        case pascha+1.days ..< pascha+7.days:
            return Translate.s("brightWeek")
            
        case pascha+8.days ..< pentecost:
            let weekNum = (pascha >> date)/7+1
            return (weekday == .sunday) ? nil : String(format: Translate.s("WeekAfterPascha"),
                                                       Translate.stringFromNumber(weekNum))
            
        case pentecost+1.days ... endOfYear:
            return  String(format: Translate.s("\(dayOfWeek)AfterPentecost"),
                           Translate.stringFromNumber(((pentecost+1.days) >> date)/7+1))
            
        default: return nil
        }
    }
    
    func getTone(_ date: Date) -> Int? {
        func tone(dayNum: Int) -> Int {
            let reminder = (dayNum/7) % 8
            return (reminder == 0) ? 8 : reminder
        }
                
        switch (date) {
        case startOfYear ..< d("palmSunday"):
            return tone(dayNum: Cal2.paschaDay(year-1) >> date)
            
        case pascha+7.days ... endOfYear:
            return tone(dayNum: pascha >> date)
            
        default: return nil
        }
    }
    
    func getToneDescription(_ date: Date) -> String? {
        if let tone = getTone(date) {
            return String(format: Translate.s("tone"), Translate.stringFromNumber(tone))

        } else {
            return nil
        }
    }
}

public typealias Cal2 = ChurchCalendar2