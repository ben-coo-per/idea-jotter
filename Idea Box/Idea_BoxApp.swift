//
//  Idea_BoxApp.swift
//  Idea Box
//
//  Created by Ben Cooper on 6/15/23.
//
import ComposableArchitecture
import SwiftUI

struct Idea: Equatable {
    var id: UUID
    var date: Date = Date()
    var description: String
    var parent: UUID?
}

struct IdeaList: ReducerProtocol {
    public struct State: Equatable {
        var ideas: [Idea] = [Idea(id: UUID(), description: "Test")]
    }
    enum Action: Equatable {
        case addIdea(idea: String, parentId: UUID?)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .addIdea(idea, parentId):
            state.ideas.append(Idea(id: UUID(), description: idea, parent: parentId))
            
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
