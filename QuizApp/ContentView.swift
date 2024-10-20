//
//  ContentView.swift
//  QuizApp
//
//  Created by Gabriela Ruiz on 10/6/24.
//

import SwiftUI
import UIKit

struct CustomPageControl: View {
    var numberOfPages: Int
    @Binding var currentPage: Int
    var activeColor: Color
    var inactiveColor: Color
    var dotSize: CGFloat
    var dotSpacing: CGFloat // Add spacing between the dots
    
    var body: some View {
        HStack(spacing: dotSpacing) { // Adjust space between dots
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(width: dotSize, height: dotSize)
                    // Add stroke (outline) around the dots
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                    )
            }
        }
    }
}


extension Color {

    init(hex: String) {

            var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if hex.hasPrefix("#") {

                hex.remove(at: hex.startIndex)

            }

            var rgb: UInt64 = 0

            Scanner(string: hex).scanHexInt64(&rgb)

            

            let red = Double((rgb >> 16) & 0xFF) / 255.0

            let green = Double((rgb >> 8) & 0xFF) / 255.0

            let blue = Double(rgb & 0xFF) / 255.0

            

            self.init(red: red, green: green, blue: blue)

        }

    }


struct Quiz: Identifiable {
    let id = UUID()
    let name: String
    let mainImageName: String
    let questions: [Question]
}

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let answers: [String]
    let correctAnswer: String
}

struct QuizDetailView: View {
    let quiz: Quiz
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var score = 0
    @State private var showScore = false
    @State private var answersSummary: [(question: String, selectedAnswer: String, isCorrect: Bool)] = []
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#BFE4F7")
                
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                if showScore {
                    Text("Your Score: \(score) / \(quiz.questions.count)")
                        .font(.largeTitle)
                        .padding()
                    
                    List(answersSummary, id: \.question) { item in
                        VStack(alignment: .leading) {
                            Text(item.question)
                                .font(.headline)
                            Text("Your answer: \(item.selectedAnswer)")
                                .foregroundColor(item.isCorrect ? .green : .red)
                            Text("Correct answer: \(quiz.questions.first { $0.text == item.question }?.correctAnswer ?? "")")
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 5)
                    }
                    Spacer()
                } else {
                    let question = quiz.questions[currentQuestionIndex]
                    
                    // Apply the same style as the images outside
                    Image(quiz.mainImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 310, height: 330)
                        .clipShape(Rectangle())
                        .cornerRadius(50.0)
                        .shadow(radius: 5)
                        .padding(.bottom, 10)
                        .offset(x: 20)
                    
        VStack(alignment: .leading) {
                    Text(question.text)
                    .font(.headline)
                    .padding(.bottom, 10)
                        
        ForEach(question.answers, id: \.self) { answer in
                    HStack {
                    Button(action: {
                    selectedAnswer = answer
                                }) {
                    Circle()
                                        .fill(selectedAnswer == answer ? Color.blue.opacity(0.5)  : Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(
                    Circle().stroke(Color.blue.opacity(0.5), lineWidth: 2)
                        )
                            }
                    .buttonStyle(PlainButtonStyle())
                                
                    Text(answer)
                    .padding(.leading, 10)
                            }
                    .padding(.bottom, 5)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 10)
                    .offset(x: 10)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            if let selectedAnswer = selectedAnswer {
                                let isCorrect = selectedAnswer == question.correctAnswer
                                answersSummary.append((question.text, selectedAnswer, isCorrect))
                                if isCorrect {
                                    score += 1
                                }
                                
                                if currentQuestionIndex < quiz.questions.count - 1 {
                                    currentQuestionIndex += 1
                                    self.selectedAnswer = nil
                                } else {
                                    showScore = true
                                }
                            }
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
//                                    Color(hex: "#388DFF"))
                        }
                    }
                }
            }
            .padding()
            .navigationTitle(quiz.name)
        }
    }
}


struct ContentView: View {
    @State private var currentPage = 0
    let quizzes = [
        Quiz(name: "Swift", mainImageName: "swift", questions: [
            Question(text: "What keyword is used in Swift to declare a constant?", answers: ["var", "let", "const", "static"], correctAnswer: "let"),
            Question(text: "How do you declare an optional in Swift?", answers: ["Int?", "Optional Int", "Int!", "Optional<Int>"], correctAnswer: "Int?"),
            Question(text: "Which of the following statements is used to safely unwrap an optional in Swift?", answers: ["force unwrap !", "optional chaining ?.", "optional binding &", "if let or guard let"], correctAnswer: "if let or guard let"),
            Question(text: "Which protocol in Swift is used for handling asynchronous code, such as network requests or long-running tasks?", answers: ["AsyncSequence", "Codable", "Observable", "Delegate"], correctAnswer: "AsyncSequence"),
            Question(text: "What is the default access control level for properties and methods in Swift?", answers: ["private", "internal", "public", "fileprivate"], correctAnswer: "internal"),
            Question(text: "How do you declare a function that accepts a variadic parameter in Swift?", answers: ["func sum(_ numbers: Int...)", "func sum(numbers: [Int])", "func sum(numbers: Int[])", "func sum(numbers...)"], correctAnswer: "func sum(_ numbers: Int...)"),
            Question(text: "Which Swift keyword is used to indicate that a class cannot be inherited?", answers: ["static", "private", "final", "required"], correctAnswer: "final"),
            Question(text: "Which of the following types is a value type in Swift?", answers: ["Class", "Array", "Protocol", "Delegate"], correctAnswer: "Array"),
            Question(text: "What is the correct way to handle errors in Swift using do-catch?", answers: ["try", "try-catch", "do-try-catch", "do { try ... } catch { ... }"], correctAnswer: "do { try ... } catch { ... }"),
            Question(text: "How do you define a computed property in Swift?", answers: ["var value = 10", "var value: Int { return 10 }", "let value = { 10 }", "func value() -> Int { return 10 }"], correctAnswer: "var value: Int { return 10 }")
            
        ]),
        Quiz(name: "Python", mainImageName: "python", questions: [
            Question(text: "What is the correct way to define a function in Python?", answers: ["function functionName():", " def functionName[]:", "def functionName():", "function functionName[]:"], correctAnswer: "def functionName():"),
            Question(text: "Which keyword is used to handle exceptions in Python?", answers: ["try", "catch", "handle", "exception"], correctAnswer: "try"),
            Question(text: "What is the output of the following code: print(type([]))?", answers: ["<class 'tuple'>", "<class 'dict'>", "<class 'list'>", "<class 'set'>"], correctAnswer: "<class 'list'>"),
            Question(text: "How do you create a set in Python?", answers: ["set = {}", "set = []", "set = ()", "set = set()"], correctAnswer: "set = set()"),
            Question(text: "Which of the following is used to insert an element at a specific position in a Python list?", answers: ["append()", "insert()", "add()", "push()"], correctAnswer: "insert()"),
            Question(text: "Which of the following is the correct way to create a dictionary in Python?", answers: ["d = {}", "d = ()", "d = []", "d = dict[]"], correctAnswer: "d = {}"),
            Question(text: "What is the correct way to check if a key exists in a Python dictionary?", answers: ["if key is dictionary:", "if dictionary.has_key(key):", "if key in dictionary:", "if key exists in dictionary:"], correctAnswer: "if key in dictionary:"),
            Question(text: "What is the output of print(3 * 'abc')?", answers: ["'abc*3'", "'abc 3 times'", "['abc', 'abc', 'abc']", "'abcabcabc'"], correctAnswer: "'abcabcabc'"),
            Question(text: "Which Python keyword is used to define an anonymous function (lambda function)?", answers: ["def", "lambda", "func", "anon"], correctAnswer: "lambda"),
            Question(text: "What is the correct syntax to import the entire math module in Python?", answers: ["import math", "import math as m", "include(math)", "from math import *"], correctAnswer: "import math")
        ]),
        Quiz(name: "Data Structures", mainImageName: "DataStructures", questions: [
            Question(text: "When new allocates a dynamic variable or a dynamic array, the memory comes from a location called the program's?", answers: ["Heap", "Free store", "Dynamic memory", "Memory pool"], correctAnswer: "heap"),
            Question(text: "Which data structure follows the Last in First Out (LIFO) principle", answers: ["Queue", "Linked List", "Tree", "Stack"], correctAnswer: "Stack"),
            Question(text: "What is the time complexity of accessing an element in a balanced binary search tree (BST)?", answers: ["O(n)", "O(log n)", "O(1)", "O(n^2)"], correctAnswer: "O (log n)"),
            Question(text: "What is the best data structure for implementing a priority queue?", answers: ["Stack", "Single Linked List", "Binary Heap", "Hash Table"], correctAnswer: "Binary Heap"),
            Question(text: "Which of the following data structures can store duplicate values?", answers: ["Set", "Array", "HashMaop", "Binary Search Tree (BST)"], correctAnswer: "Array"),
            Question(text: "Which data structure is most efficient for implementing breadth-first search (BFS) in a graph?", answers: ["Stack", "Priority Queue", "Queue", "Linked List"], correctAnswer: "Queue"),
            Question(text: "In which data structure is searching for an element with a given key most efficient?", answers: ["Array", "Hash Table", "Linked List", "Stack"], correctAnswer: "Hash Table"),
            Question(text: "Which traversal method visits the nodes of a binary tree in the order: left subtree, root, right subtree?", answers: ["In-order", "Pre-order", "Post-order", "Level-order"], correctAnswer: "In-order"),
            Question(text: "What is the minimum number of edges in a connected graph with n vertices?", answers: ["n+1", "2n-1", "n-1", "n(n-1)/2"], correctAnswer: "n-1"),
            Question(text: "Which data structure is used for implementing recursion?", answers: ["Stack", "Queue", "Hash Table", "Graph"], correctAnswer: "Stack")
            
        ])
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#70D8FF"),
                        Color(hex: "#FFA3F2")  // Orange #DFC5FE
                                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
)
.edgesIgnoringSafeArea(.all)
                
                VStack {
                    TabView(selection: $currentPage) {
                        ForEach(0..<quizzes.count) { index in
                            NavigationLink(destination: QuizDetailView(quiz: quizzes[index])) {
                                VStack {
                                    Image(quizzes[index].mainImageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 350, height: 370)
                                        .clipShape(Rectangle())
                                        .cornerRadius(50.0)
                                        .shadow(radius: 5)
                                        .padding(.bottom, 10)
                                    
                                    Text(quizzes[index].name)
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        
                                        .padding(.top,  25)
                                }
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default pagination dots
                 
                    CustomPageControl(
                                    numberOfPages: quizzes.count,
                                    currentPage: $currentPage,
                                    activeColor: Color.white.opacity(0.8),
                                    inactiveColor: Color.white.opacity(0.2),
                                    dotSize: 10, dotSpacing: 15 // You can adjust the size here
                                )
                                .padding(.top, 10)
                                .offset(y: -20)


                }
            }
            .navigationTitle("Quizzes")
        }
    }
}

#Preview {
    ContentView()
}
