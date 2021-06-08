# blogs

Language: Swift

Platforms Supported: iPhone and iPad

Modes Supported: Light Mode and Dark Mode

Frameworks used: UIKit, Foundation, Combine, CoreData

Architecture: Clean Architecture in which different modules are loosely coupled. MVVM is used as UI architecture.

Prominant Design Patterns Used: Abstract Factory, Factory, Composite, Decorator, Repository, Builder. 

App Components:

Flow: Makes navigation decisions. 

Router: Pushes view controllers to navigation controller, as directed by Flow

ViewControllerFactory: Creates and returns UIView Controllers required by Router.

Composition Root: Main module, Scene Delegate and iOSViewController Factory, act as composition root, where all the composnents are created and composed
                  within same module.
                  
View: Consisting of UIViewControllers is responsibile for displaying data to user and respond to user interactions.

Presenter: Responsible for formatting data, required by view.

Persistance: Responsible for persisting and retrieving data from local database, CoreData. 

Network: Fetches Data from the Internet. 

DataModel: Defines models and uses Repository design pattern to detach model from implementation details. Using the Repository desing pattern, we make sure
that our model layer shoud not depend upon any frameworks like Core Data. 


Requirement: Fully Implemented

A landing page to display the featured blog posts and the remaining in listing.

a. This must have a search feature and paging.

b. Serve the blog posts from local storage whenever there is no Internet
connection available.

Solution:
BlogPostsListViewController displays list of blogs fetched by BlogPostsListConcreteViewModel from network or local persistance, in case of offline. 
Strategy: BlogPostsListConcreteViewModel fetches list from network and saves to local database. 
             - Design patttern used: Decorator
             
          When new data is available, view is notified using CurrentValueSubject type provided by Combine - Reactive Programming.
          Next time, if network fails, it loads from previously saved data in local persistance, CoreData. 
             - Design Pattern used: Composite
             
          Images fetched from network are kept in Cache and Core Data
             - Decorator 
             
          Each image is first loaded from Cahce, if not found, check in Local Database, if not found there too, gets loaded from network.
             - Composite
             
          Search: Each time user enters text in search bar, API request is sent to get results and load into UI. 
          Paging: Intially 50 posts are fetched from network. After user reaches to the end of loaded results, it sends request to load next 50 items.

Requirement: Only UI implemented yet.
Login/ Registration using Firebase authentication with 1 social authentication - (e.g. Google Auth).

Solution:
UI is implemented for Login and Signup. After user fills information in Signup screens and submits, input validation is performed, which either returns 
UserCredentials struct or throws an error, if validation fails. 
        - Design Pattern Used: Builder
        
        

    
          
