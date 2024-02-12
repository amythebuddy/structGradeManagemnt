//
//  main.swift
//  structGrade
//
//  Created by StudentAM on 2/8/24.
//

import Foundation
import CSV

struct Student{
    var studentName: String
    var grades: [String]
    var averageGrade: Double
}

func readCSVFiles(data: inout [Student]) {
    do {
        let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv")
        let csv = try CSVReader(stream: stream!)
        
        while let student = csv.next(){
            manageData(of: student, appendTo: &data)
        }
    } catch {
        print("An error occurred: \(error)")
        fatalError("There is an error trying to read the files. Check if the file path is correct.")
    }
}
func manageData(of student: [String], appendTo data: inout [Student]){
    let name = student[0]
    var grades: [String] = []
    var assignment = 0.0
    for i in 1..<student.count {
        grades.append(student[i]) // append each grade to the grades variable
        if let gradeOfEachAssignment = Double(student[i]){
            assignment += gradeOfEachAssignment // add all the grades to find average
        }
    }
    let averageOfSingleStudent = assignment / 10 // divide by the amount of assignments
    let inputStudent: Student = Student(studentName: name, grades: grades, averageGrade: averageOfSingleStudent)
    data.append(inputStudent)
}
func findStudent(byName name : String, accessThrough data: [Student]) -> Student?{
    // find the student in lowercase
    let lowercaseName = name.lowercased() //turn all name to lowercase
    for student in data {
        if student.studentName.lowercased() == lowercaseName { // if there is a student with that name
            return student
        }
    }
    return nil
}
func showMainMenu(){
    var students: [Student] = []
    var menuRunning = true
    readCSVFiles(data: &students)
    while menuRunning {
        print("Welcome to the Grade Manager!\n"
              + "What would you like to do? (Enter the number):\n"
              + "1. Display average grade of a single student \n"
              + "2. Display all grades for a student\n"
              + "3. Display all grades of ALL students \n"
              + "4. Find the average grade of the class \n"
              + "5. Find the average grade of an assignment \n"
              + "6. Find the lowest grade in the class \n"
              + "7. Find the highest grade of the class\n"
              + "8. Filter students by grade range\n"
              + "9. Change grade of an assignment\n"
              + "10. Quit")
        if let userInput = readLine() {
            switch userInput {
                case "1", "2":
                    print("Which student would you like to choose?")
                    if let nameInput = readLine(), let name = findStudent(byName: nameInput, accessThrough: students){
                        print("\(name.studentName)'s grade(s) is/are:", terminator: " ")
                        if userInput == "1" {
                            print("\(name.averageGrade)") //get the grade of that student
                        } else {
                            showAllGradesOfAStudent(name)
                        }
                    } else {
                        print("There is no student with that name.")
                        continue
                    }
                case "3":
                    showAllGradesOfAll(students: students)
                case "4":
                    calculateAverageGradeOfTheClass(with: students)
                case "5":
                    findAverageGradeOfAssignment(with: students)
                case "6", "7":
                    if userInput == "7"{ // print the highest grade
                        //highestGrade stores the element of that students includes their name, grades, and averageGrade
                        if let highestGrade = students.max(by: {$0.averageGrade < $1.averageGrade}){
                                print("\(highestGrade.studentName) is the student with the highest grade: \(highestGrade.averageGrade)")
                        } else {
                            print("There is an error")
                        }
                    } else { //print the lowest grade
                        //lowestGrade stores the element of that students includes their name, grades, and averageGrade
                        if let lowestGrade = students.min(by: {$0.averageGrade < $1.averageGrade}){
                            print("\(lowestGrade.studentName) is the student with the lowest grade: \(lowestGrade.averageGrade)")
                        } else {
                            print("There is an error")
                        }
                    }
                case "8":
                    print("Enter the low range you would like to use: ")
                   guard let lowNumber = readLine(), let lowGrade = Double(lowNumber) else {
                       print("Please enter a number!")
                       continue
                   }
                   print("Enter the high range you would like to use: ")
                   guard let highNumber = readLine(), let highGrade = Double(highNumber) else {
                       print("Please enter a number!")
                       continue
                   }
                   if lowGrade > highGrade {
                       print("The low range is bigger than the high range. Please enter back.")
                   } else {
                       //filter the grade that is higher than lowGrade and lower than highGrade
                       // return back a dictionary of students with in range grade
                       let studentsInRange = students.filter({$0.averageGrade > lowGrade && $0.averageGrade < highGrade})
                       for student in studentsInRange { // for each student in range, print out their name and grade
                           print("\(student.studentName): \(student.averageGrade)")
                       }
                   }
                case "9":
                    print("What student do you want to change?")
                    guard let nameInput = readLine(), var studentName = findStudent(byName: nameInput, accessThrough: students) else {
                        print("There is no student with that name")
                        continue
                    }
                    print("Which assignent grade would you like to change (1-10):")
                    guard let number = readLine(), let assignmentNumber = Int(number), assignmentNumber > 0, assignmentNumber < 11 else {
                        print("Please enter a number from 1 to 10")
                        continue
                    }
                    print("What is the new grade of this student?")
                    guard let grade = readLine(), let new = Double(grade), new > 0.0 else {
                        print("Please enter a postive number.")
                        continue
                    }
                    studentName.grades[assignmentNumber-1] = grade // change the assignment grade
                    // recalculate the average grade after the change
                    var assignmentGrade = 0.0
                    for i in studentName.grades.indices {
                        if let gradeOfEachAssignment = Double(studentName.grades[i]){
                            assignmentGrade += gradeOfEachAssignment // add all the grades to find average
                        }
                    }
                    let averageOfSingleStudent = assignmentGrade / 10 // divide by the amount of assignments
                    studentName.averageGrade = averageOfSingleStudent // update the averageGrade
                    //find the index of the student to update
                    if let index = students.firstIndex(where: { $0.studentName == studentName.studentName }) {
                        students[index] = studentName
                    }
                    print("You have changed \(studentName.studentName)'s grades of assingment #\(assignmentNumber)")
                case "10":
                    print("Have a great rest of your day!")
                    menuRunning = false
                default:
                    print("Please enter an approriate choice!")
            }
        }
    }
}
func showAllGradesOfAStudent(_ student: Student){
    let gradesString = student.grades.joined(separator: ", ") // get the array grades and joined it
    print(gradesString)
}
func showAllGradesOfAll(students: [Student]){
    for i in students.indices{
        // terminator is to connect the second print to this line
        print("\(students[i].studentName) grades are:", terminator: " ")
        let gradesString = students[i].grades.joined(separator: ", ") // get the array grades and joined it
        print(gradesString)
    }
}
func calculateAverageGradeOfTheClass(with data: [Student]) {
    var totalAverage = 0.0
    for i in data.indices{
        totalAverage += data[i].averageGrade // add all the students' averageGrade
    }
    totalAverage /= Double(data.count) // divide it by the total students in the class
    print("The class average is: " + String(format: "%.2f", totalAverage))
}
func findAverageGradeOfAssignment(with data: [Student]) {
    print("Which assignent would you like to get the average of (1-10):")
        guard let number = readLine(), let assignmentNumber = Int(number), assignmentNumber > 0, assignmentNumber < 11 else {
            print("Please enter a number from 1 to 10")
            return
        }
    var sumOfAssignmentGrades = 0.0
    var sumOfAmountOfThatAssignment = 0.0
    for i in data.indices{
        if let gradeOfEachAssignment = Double(data[i].grades[assignmentNumber-1]){ // get that assignment grade
            sumOfAssignmentGrades += gradeOfEachAssignment // add each assignment grade to the sum
            sumOfAmountOfThatAssignment += 1 // add an amount of assignment
        }
    }
    let averageOfAnAssignment = sumOfAssignmentGrades / sumOfAmountOfThatAssignment
    print("The average for assignment #\(assignmentNumber) is: " + String(format: "%.2f", averageOfAnAssignment))
}

showMainMenu()
