//
//  Idea_BoxApp.swift
//  Idea Box
//
//  Created by Ben Cooper on 6/15/23.
//
import ComposableArchitecture
import SwiftUI

struct Idea: Equatable, Codable {
    var id: UUID
    var date: Date = Date()
    var description: String
    var parent: UUID?
}

struct IdeaList: ReducerProtocol {
    var fm: FileManager
    
    public struct State: Equatable {
        var ideas: [Idea]
        
        init() {
            // get ideas from file storage
            let fm = FileManager()
            let ideasFromStorage = fm.getIdeasFromStorage()
            // set the state
            self.ideas = ideasFromStorage
        }
    }
    enum Action: Equatable {
        case addIdea(idea: String, parentId: UUID?)
        case hydrateIdeasFromStorage
    }
    
    init() {
        fm = FileManager()
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .addIdea(idea, parentId):
            // append new idea to state
            state.ideas.append(Idea(id: UUID(), description: idea, parent: parentId))
            
            // save updated ideas to file
            fm.updateIdeasInStorage(ideas: state.ideas)
            
            return .none

        case .hydrateIdeasFromStorage:
            // get ideas from file storage
            let ideasFromStorage = fm.getIdeasFromStorage()
            // set the state
            state.ideas = ideasFromStorage
            return .none
        }
    }

    
    @main
    struct Idea_BoxApp: App {
        var body: some Scene {
            WindowGroup {
                ContentView(
                    store: Store(initialState: IdeaList.State()) {
                        IdeaList()
                    }
                )
            }
        }
    }
}


extension FileManager {
    private func getFileStorageUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("ideas.json")
    }
    
    
    func updateIdeasInStorage(ideas: [Idea]) -> Void {
        let jsonEncoder = JSONEncoder()
        let fileStorageUrl = self.getFileStorageUrl()
        do {
            let json = try jsonEncoder.encode(ideas)
            try json.write(to: fileStorageUrl)
        } catch {
            print("Could not upload ideas")
            // TODO: add an error toast/alert of some kind
        }
    }
    
    func getIdeasFromStorage() -> [Idea] {
        let jsonDecoder = JSONDecoder()
        let fileStorageUrl = self.getFileStorageUrl()
        
        do {
            let json = try Data(contentsOf: fileStorageUrl)
            let decoded = try jsonDecoder.decode([Idea].self, from: json)
            return decoded
        } catch {
            print(error.localizedDescription)
            // TODO: add an error toast/alert of some kind
            return []
        }
    }
}
