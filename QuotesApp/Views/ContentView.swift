//
//  ContentView.swift
//  QuotesApp
//
//  Created by Claire Coding Account on 2022-02-23.
//

import SwiftUI

struct ContentView: View {
    @State var currentQuote: Quote = Quote(quoteText: "",
                                           quoteAuthor: "",
                                           quoteLink: "")
    
    @State var favourites: [Quote] = []
    
    
    @State var currentQuoteAddedToFavourites: Bool = false
    
    //MARK: Computed Properties
    var body: some View {
        VStack {
            
            VStack{
            
            Text(currentQuote.quoteText)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(10)
                
                
                
                HStack{
                    
                    Spacer()
                    
                    Text("-\(currentQuote.quoteAuthor)")
                        .italic()
                        .padding()
                        .font(.body)
                }
               
            }
            .overlay(
                Rectangle()
                    .stroke(Color.primary, lineWidth: 4)
            )
            .padding(10)
            
            Image(systemName: "heart.circle")
                .foregroundColor(currentQuoteAddedToFavourites == true ? .red : .secondary)
                .font(.largeTitle)
                .padding(.bottom)
                .onTapGesture {
                    
                    
                    if currentQuoteAddedToFavourites == false {
                        
                        
                        favourites.append(currentQuote)
                        
                        
                        currentQuoteAddedToFavourites = true
                        
                    }
                }
            
            Button(action: {
                
                
                Task {
                 
                    await loadNewQuote()
                    
                }
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)
            
            HStack{
                
                Text("Favourites")
                    .bold()
                    .multilineTextAlignment(.leading)
                    .font(.title3)
                    .padding()
                
                Spacer()
            }
            
            
            List(favourites, id: \.self) { currentFavourite in
                Text(currentFavourite.quoteText)
            }
            
            Spacer()
            
        }
        .task {
    
            await loadNewQuote()
            
            print("I tried to load a new quote")
            
        }
        .navigationTitle("Quotes")
        .padding()
    }
    
    func loadNewQuote() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://api.forismatic.com/api/1.0/?method=getQuote&key=457653&format=json&lang=en")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentJoke"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentQuote = try JSONDecoder().decode(Quote.self, from: data)
            
            // Reset the flag that tracks whether the current joke is a favourite
            currentQuoteAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
