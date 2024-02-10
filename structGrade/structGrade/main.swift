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
        let stream = InputStream(fileAtPath: "/Users/nguyenhuyen/Desktop/grades.csv")
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
        grades.append(student[i])
        if let gradeOfEachAssignment = Double(student[i]){
            assignment += gradeOfEachAssignment
        }
    }
    let averageOfSingleStudent = assignment / 10
    let inputStudent: Student = Student(studentName: name, grades: grades, averageGrade: averageOfSingleStudent)
    data.append(inputStudent)
}
func findStudent(byName name : String, accessThrough data: [Student]) -> Student?{
    let lowercaseName = name.lowercased() //turn all name to lowercase
    for student in data {
        if student.studentName.lowercased() == lowercaseName {
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
    //dropFirst means remove the first element without changing the original array
    let gradesString = student.grades.joined(separator: ", ")
    print(gradesString)
}
func showAllGradesOfAll(students: [Student]){
    for i in students.indices{
        // terminator is to connect the second print to this line
        print("\(students[i].studentName) grades are:", terminator: " ")
        // map is pulling each element out and joined with each other with comma
        let gradesString = students[i].grades.joined(separator: ", ")
        print(gradesString)
    }
}
func calculateAverageGradeOfTheClass(with data: [Student]) {
    var totalAverage = 0.0
    for i in data.indices{
        totalAverage += data[i].averageGrade
    }
    totalAverage /= Double(data.count)
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
func findHighest(with data: [Student]){
    
}
showMainMenu()
