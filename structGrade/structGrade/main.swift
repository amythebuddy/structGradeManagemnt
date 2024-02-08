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
var students: [Student] = []
do {
    let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv")
    let csv = try CSVReader(stream: stream!)
    
    while let student = csv.next(){
        manageData(of: student)
    }
}

func manageData(of student: [String]){
    let name = student[0]
    var grades: [String] = []
    var average = 0.0
    var averageOfSingleStudent = 0.0
    for i in 1..<student.count {
        grades.append(student[i])
          if let gradeOfEachAssignment = Double(student[i]){
            average += gradeOfEachAssignment
        }
        averageOfSingleStudent = average / Double((student.count - 1))
    }
    let inputStudent: Student = Student(studentName: name, grades: grades, averageGrade: averageOfSingleStudent)
    students.append(inputStudent)
    print(students)
}
