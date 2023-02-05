# SDG-mapping-tool
Explore keywords from texts by K-means Cluster and calculate by Sum of Square Error(SSE) to label each of Sustainable Development Goals for prediction and classification 









## About the Project

* This software is used to control the flow of planes at an airport
* This project is one of the Digital Futures Academy Challenges
* This project approach - Test-driven development



## Built With
* [![Laravel][Laravel.com]][Laravel-url]


## Getting Started

### How can the viewer set up the project locally?
* Fork this repo, and clone to your local machine
* npm install to install project dependencies
* Convert stories into a representative domain model and test-drive your work.
* Run your tests using npm test or node specRunner.js

### Project Structure
* src folder
1. airport.js
2. plane.js
   
* test folder
1. airport.spec.js
2. testing-framework.js

## Problem Statements

We have a request from a client to write the software to control the flow of planes at an airport. The planes can land and take off provided that the weather is sunny. Occasionally it may be stormy, in which case no planes can land or take off.

### User Stories

```
As an air traffic controller
So I can get passengers to a destination
I want to instruct the airport to land a plane

As the system designer
So that the software can be used for many different airports
I would like a default airport capacity that can be overridden as appropriate

As an air traffic controller
To ensure safety
I want to prevent landing when the airport is full

As an air traffic controller
So I can get passengers on the way to their destination
I want to instruct the airport to let a plane take off and confirm that it is no longer in the airport

As an air traffic controller
To avoid confusion
I want to prevent asking the airport to let planes take-off which are not at the airport, or land a plane that's already landed

As an air traffic controller
To ensure safety
I want to prevent takeoff when weather is stormy

As an air traffic controller
To ensure safety
I want to prevent landing when weather is stormy

As an air traffic controller
To count planes easily
Planes that have landed must be at an airport
```

## Domain Models

### User Story 1

```
As an air traffic controller
So I can get passengers to a destination
I want to instruct the airport to land a plane
```

#### Domain Model

| Objects | Properties                  | Messages     | Output |
| ------- | --------------------------- | ------------ | ------ |
| Airport | airportPlanes@Array[@plane] | land(@plane) | @void  |
| Plane   | planeID@Plane               | land()       | @void  |

#### Tests
1. Test if a plane is landed at the airport when land is called with plane

---

## User Story 2

```
As the system designer
So that the software can be used for many different airports
I would like a default airport capacity that can be overridden as appropriate
```

#### Domain Model

| Objects | Properties                  | Messages             | Output |
| ------- | --------------------------- | -------------------- | ------ |
| Airport | airportPlanes@Array[@plane] | setCapacity(@number) | @void  |

#### Tests
1. Test if a default airport capacity can be overridden as appropriate

---

## User Story 3

```
As an air traffic controller
To ensure safety
I want to prevent landing when the airport is full
```

#### Domain Model

| Objects | Properties                  | Messages | Output   |
| ------- | --------------------------- | -------- | -------- |
| Airport | airportPlanes@Array[@plane] | isFull() | @Boolean |
| Plane   | planeID@Plane               | isFull() | @Boolean |

#### Tests
1. Test if the plane landing is prevented when the airport is full

---

## User Story 4

```
As an air traffic controller
So I can get passengers on the way to their destination
I want to instruct the airport to let a plane take off and confirm that it is no longer in the airport
```

#### Domain Model

| Objects | Properties                  | Messages               | Output   |
| ------- | --------------------------- | ---------------------- | -------- |
| Airport | airportPlanes@Array[@plane] | send(@plane)           | @void    |
|         |                             | takeoffConfirm(@plane) | @Boolean |
| Plane   | planeID@Plane               | send()                 | @void    |
|         |                             | takeoffConfirm()       | @Boolean |

#### Tests
1. Test if the plane is taken off from the airport when send is called
2. Test the confirmation is given when the plane has been taken off

---

## User Story 5

```
As an air traffic controller
To avoid confusion
I want to prevent asking the airport to let planes take-off which are not at the airport, or land a plane that's already landed
```

#### Domain Model

| Objects | Properties                  | Messages           | Output   |
| ------- | --------------------------- | ------------------ | -------- |
| Airport | airportPlanes@Array[@plane] | planeHasTakenOff() | @Boolean |
|         |                             | planeHasLanded()   | @Boolean |
|         |                             |                    |          |
| Plane   | planeID@Plane               | planeHasTakenOff() | @Boolean |
|         |                             | planeHasLanded()   | @Boolean |

#### Tests
1. Test if prevent letting a plane take off when they are not at the airport
2. Test if prevent landing a plane when that's already landed

---

## User Story 6

```
As an air traffic controller
To ensure safety
I want to prevent takeoff when weather is stormy
```

#### Domain Model

| Objects | Properties                  | Messages           | Output   |
| ------- | --------------------------- | ------------------ | -------- |
| Airport | airportPlanes@Array[@plane] | stormyTakeOff()    | @Boolean |
| Plane   | planeID@Plane               | stormyTakeOff()    | @Boolean |
| Weather | Weather@stormy              | weathergenerator() | @Boolean |
|         |                             | stormyTakeOff()    | @Boolean |

#### Tests
1. Test if prevent takeoff when weather is stormy

---

## User Story 7

```
As an air traffic controller
To ensure safety
I want to prevent landing when weather is stormy
```

#### Domain Model

| Objects | Properties                  | Messages           | Output   |
| ------- | --------------------------- | ------------------ | -------- |
| Airport | airportPlanes@Array[@plane] | stormyLand()       | @Boolean |
| Plane   | planeID@Plane               | stormyLand()       | @Boolean |
| Weather | Weather@stormy              | weathergenerator() | @Boolean |
|         |                             | stormyLand()       | @Boolean |

#### Tests
1. Test if prevent landing when weather is stormy

---

## User Story 8

```
As an air traffic controller
To count planes easily
Planes that have landed must be at an airport
```

#### Domain Model

| Objects | Properties                  | Messages         | Output   |
| ------- | --------------------------- | ---------------- | -------- |
| Airport | airportPlanes@Array[@plane] | countAirplanes() | @Boolean |
| Plane   | planeID@Plane               | countAirplanes() | @number  |

#### Tests
1. Test if planes that have landed at an airport

## Project Review and Roadmap

### What were your main takeaways from this project?

* I have learned to create user stories and build domain models for each user story. This helps me know what the client's requirements for the application are and what I need to develop and test for each requirement(user story)
* I also have learned TDD development
* I obtained the testing-framework.js

### What would you do differently if you were to approach this again?

* I would think about decoupling and encapsulation
* I would think about creating each class for each object which could make the story more readable

### Where could this project go next?

* I would consider more weather condition
* I would set the airport capacity at the start, e.g. if the airport capacity is zero, then no need for the next steps
* I would create an object for the air traffic controller

## Acknowledgements

* Digital Futures Academy
  
