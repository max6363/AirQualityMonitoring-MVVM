# AirQualityMonitoring-MVVM
Demo project for the air quality monitoring using MVVM in Swift

# Example

### Demo
![AirQualityIndex-Websocket](https://user-images.githubusercontent.com/21213161/130838693-b12dcdcd-b26d-4c79-90dd-7e9e54444f4f.gif)

### Realtime Graph
<img width="746" alt="Realtime-graph-AQI" src="https://user-images.githubusercontent.com/21213161/130839074-771499ec-39a7-458b-99b2-497e0cca6a74.png">

# Details

#### WebSocket
- Subscribe to websocket `ws://city-ws.herokuapp.com` to receive Air Quality Indices for the Cities.
- Pod: `Starscream` => https://github.com/daltoniam/Starscream

#### MVVM
Used MVVM design pattern.

- Model: is used as data source.
- View: has ability to show list. i.e. Table and information
- ViewModel: has all the logic and a mediator between `View` & `Model`.

#### Realtime Graph
- Show the realtime graph for the City AQI (Air Quality Index) Data.
- Pod: `Charts` => https://github.com/danielgindi/Charts

#### Unit/UI tests
- Added Unit and UI Tests using `XCTest`.





