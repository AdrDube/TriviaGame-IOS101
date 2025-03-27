//
//  Questions.swift
//  Trivia
//
//  Created by Adriel Dube on 3/12/25.
//

import Foundation

class Questions{
    static func get(number: Int, difficulty: String, completion: @escaping ([TriviaQuestion]?) -> Void){
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://opentdb.com/api.php?amount=\(String(number))&difficulty=\(difficulty)&type=multiple")!)){
            data, response, error in

            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            let decoder = JSONDecoder()
            let response = try! decoder.decode(TriviaResponse.self, from: data)
            completion(response.triviaQuestions)
        }
        task.resume()
    }
    
}



struct TriviaResponse: Decodable {
    let triviaQuestions : [TriviaQuestion]
    
    private enum CodingKeys : String , CodingKey {
        case triviaQuestions = "results"
    }
}


struct TriviaQuestion: Decodable {
    var question : String
    var answers : [String]
    var correctAnswer : String
    var category : String
    var genre: Genre
    
    private enum CodingKeys: String, CodingKey {
          case question
          case answers = "incorrect_answers"
          case correctAnswer = "correct_answer"
          case category
        }
    init(from decoder: Decoder) throws {
            var container = try decoder.container(keyedBy: CodingKeys.self)
            question = try container.decode(String.self, forKey: .question)
            correctAnswer = try container.decode(String.self, forKey: .correctAnswer).htmlDecoded()
            category = try container.decode(String.self, forKey: .category).htmlDecoded()
            answers = try container.decode([String].self, forKey: .answers )
            genre = Genre(rawValue: category) ?? .unknown
            answers = answers.map{ $0.htmlDecoded() }.shuffled()
            answers.append(correctAnswer)
        }
}


enum Genre: String {
    case generalKnowledge = "General Knowledge"
    case entertainmentBooks = "Entertainment: Books"
    case entertainmentFilm = "Entertainment: Film"
    case entertainmentMusic = "Entertainment: Music"
    case entertainmentMusicalsTheatres = "Entertainment: Musicals &amp; Theatres"
    case entertainmentTelevision = "Entertainment: Television"
    case entertainmentVideoGames = "Entertainment: Video Games"
    case entertainmentBoardGames = "Entertainment: Board Games"
    case scienceNature = "Science & Nature"
    case scienceComputers = "Science: Computers"
    case scienceMathematics = "Science: Mathematics"
    case mythology = "Mythology"
    case sports = "Sports"
    case geography = "Geography"
    case history = "History"
    case politics = "Politics"
    case art = "Art"
    case celebrities = "Celebrities"
    case animals = "Animals"
    case vehicles = "Vehicles"
    case entertainmentComics = "Entertainment: Comics"
    case scienceGadgets = "Science: Gadgets"
    case entertainmentAnimeManga = "Entertainment: Japanese Anime & Manga"
    case entertainmentCartoonsAnimations = "Entertainment: Cartoon & Animations"
    case unknown = "Unknown"

    var genreString: String {
        switch self {
        case .generalKnowledge: return "General Knowledge 🌍"
        case .entertainmentBooks: return "Books 📚"
        case .entertainmentFilm: return "Film 🎬"
        case .entertainmentMusic: return "Music 🎵"
        case .entertainmentMusicalsTheatres: return "Musicals & Theatres 🎭"
        case .entertainmentTelevision: return "Television 📺"
        case .entertainmentVideoGames: return "Video Games 🎮"
        case .entertainmentBoardGames: return "Board Games 🎲"
        case .scienceNature: return "Science & Nature 🔬"
        case .scienceComputers: return "Computers 💻"
        case .scienceMathematics: return "Mathematics 🧮"
        case .mythology: return "Mythology ⚡"
        case .sports: return "Sports 🏆"
        case .geography: return "Geography 🗺️"
        case .history: return "History 📜"
        case .politics: return "Politics 🗳️"
        case .art: return "Art 🎨"
        case .celebrities: return "Celebrities 🌟"
        case .animals: return "Animals 🐾"
        case .vehicles: return "Vehicles 🚗"
        case .entertainmentComics: return "Comics 📖"
        case .scienceGadgets: return "Gadgets 📱"
        case .entertainmentAnimeManga: return "Anime & Manga 🎌"
        case .entertainmentCartoonsAnimations: return "Cartoons & Animations 🐭"
        case .unknown: return "Unknown ❓"
        }
    }

}

