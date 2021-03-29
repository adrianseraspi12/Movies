## Goal
Create a master-detail application that contains at least one dependency. This application should display a list of items obtained from an iTunes Search API and show a detailed view for each item. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

#### Cocoapods

Before you could build and run the project you need to install the cocoapod dependencies. Assuming you aleady have installed cocoapods. Open a terminal at the root of the project and execute the command.

```
$ pod install
```

After everything is installed locate the generated workspace file and open the project using that to include the pod project.

## Features
- Search and show list of movies from iTunes
- View movie details
- Light/Dark mode
- Last Screen is saved (Data Persistence)

## UI/UX Design
[Movies Prototype](https://xd.adobe.com/view/05adde8c-2560-4f87-9a5c-0f4298546866-50fe/)
### **Colors**
**Light Theme**
* Background Color - #F9F9F9
* Card Background Color - #FFFFFF
* Text Color - #000000

**Dark Theme**
* Background Color - #050505
* Card Background Color - #191717
* Text Color - #FFFFFF

### **Typography**
**Font**
* Proxima Nova (Regular, Bold)

## Architectural pattern
I decided to use the most famous design pattern in iOS Development, MVVM or Model, View, ViewModel. With the combination of Combine Framework for handling asynchronous task.

MVVM is a design pattern that seperate the objects into three categories:
* Model - Plain structure of data that usually receives from the api or local database.
* View - Displays the current UI of the screen. Receives updates from the ViewModel.
* ViewModel - The middleman between the model and view. Contains the business logic of the feature/screen.

**Pros and Cons of Using MVVM**

**Pros**
* Separates the business logic to view. This means it is easier to conduct a unit test.
* Objects are bind to the view so any changes from api/local database will automatically updates the view.
* Good for small projects.

**Cons**
* Not preferrable for big projects but still usable.
* Need time to learn because of reactive programming.

## Source
All views are created using storyboard. 

### MovieListViewController
The `MovieListViewController` conforms to the `View` protocol. The `MovieListViewController` depends on the `ViewModel` designed to manage user input and the display data. Whenever the api/local database did some changes the `ViewModel` updates the `MovieListViewController` with `ScreenState`.
```
enum ScreenState: Equatable {
    case loading(Bool)
    case displayList([MainMovies])
    case error(String)
}
```

### MovieListViewModel
This is the ViewModel that is injected to `MovieListViewController` and defines what the screen is to show and how it behaves. `MovieListViewModel` conforms to `ViewModel` protocol.
```
protocol ViewModel {
    
    //  Setting up the view state. Check persist data
    func setupPersistedData()
    
    //  Handles the search operation
    func search(query: String)
    
    //  Handles changing the app state and save it to UserDefaults
    //  When state is details, movieId should be saved
    func change(state: AppState, movieId: Int?)
}
```
### APIClient
This is the class that handles the api request operation and it used by `MovieListViewModel`. `Combine` framework is implemented here to handle and set the api request to run in background thread. The `APIClient` conforms to `Client` protocol.
```
protocol Client {
    
    //  A request to search for a movie in iTunes
    func requestSearchMovies(query: String,
                             country: Country) -> AnyPublisher<[MovieList.Result], AFError>
    
}
```
### DatabaseManager
This is the class that handles the local database operation and it used by `MovieListViewModel`. `Combine` framework is also implemented here. The function return the data via publisher. The `DatabaseManager` conforms to `Database`.
```
protocol Database {
    
    //  A request to save all movie in database
    func saveAllMovies(list: [MainMovies])
    
    //  A request to get all movies from the database
    func getAllMovies() -> AnyPublisher<[Movie], Error>
    
    //  A request to delete all items in the database
    func deleteAllMovies()
    
}
```

### Persistence
Persistence takes place by saving the app current screen before it closes then restore the last screen when the app restart.

`Core Data` is used to save the data that received from the api. The `DatabaseManager` handles the interaction with the `Core Data` and operates the `get, save, delete` method. Whenever the app received a data from api via search, Delete the old data that has been saved last time then save a new set of list. Below are the attributes that is being saved in the database.

| Attribute Name |  Type      |
|     :----      |   :----:   |
|trackPrice      | Double     |
|previewUrl      | String     |
|name            | String     |
|longDescription | String     |
|imageUrl        | String     |
|id              | Integer 32 |
|genre           | String     |
|currency        | String     |

## Specifications
* Handles iOS 13 and up
* Combine Framework for handling asynchronous task
* Swift 5
* Core Data

## Dependencies
* [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP networking library
* [Kingfisher](https://github.com/onevcat/Kingfisher) - Downloading and caching images from the web

## Tools
* Adobe XD
* Xcode
* Cocoapods

## Author
Adrian Jun Seraspi - [LinkedIn](https://www.linkedin.com/in/ajseraspi), [Google Playstore](https://play.google.com/store/apps/dev?id=6959129598554363835)
