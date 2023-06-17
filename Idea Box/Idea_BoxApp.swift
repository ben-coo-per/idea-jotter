//
//  Idea_BoxApp.swift
//  Idea Box
//
//  Created by Ben Cooper on 6/15/23.
//
import ComposableArchitecture
import SwiftUI

struct Idea: Equatable {
    var description: String
    var id: UUID
    var date: Date = Date()
}

struct IdeaList: ReducerProtocol {
    public struct State: Equatable {
        var ideas: [Idea] = [
            Idea(description: "Fooby dooby", id: UUID()),
            Idea(description: "Fooby dooby 2: Electric shoe", id: UUID())
        ]
    }
    enum Action: Equatable {
        case addIdea(String)
        case removeIdea(Int)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            case let .addIdea(idea):
                state.ideas.append(Idea(description: idea, id: UUID()))
                return .none
        case let .removeIdea(index):
            state.ideas.remove(at: index)
            return .none
            }
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
