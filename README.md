# Sweater Weather 

## Summary 

Sweater Weather is a rails backend API that consumes the MapQuest, OpenWeather, Unsplash, and Yelp APIs to provide visitors with the ability to query current, hourly, and daily weather forecasts for a provided location. Additionally, visitors can find a restaurant of interest in a roadtrip destination city, and registered users are able to see the projected weather forecast of a roadtrip destination city. All queries are returned in a JSON payload. See below on how to query endpoints. 

### Contents
1. [Installation](#installation)
1. [Endpoints](#endpoints)  
  i. [Forecast](#forecast)  
  ii. [Background Image for City](#background-image-for-city)  
  iii. [User Registration](#user-registration)  
  iv. [User Login](#user-login)  
  v. [Road Trip Destination Forecast](#road-trip-destination-forecast)  

## Installation 
1. Clone repo into a local directory `git clone git@github.com:jdcarey128/sweater-weather.git`
1. From the command line, run the following commands:  
  i. `rails db:{create,migrate,seed}`  
 ii. `bundle install`  
iii. `bundle exec figaro install`
1. Register for an api key at each of the API clients (keys may require a couple hours until requests are allowed)  
  i. [MapQuest](https://developer.mapquest.com/plan_purchase/steps/business_edition/business_edition_free/register)  
  ii. [OpenWeather](https://home.openweathermap.org/users/sign_up)  
  iii. [Unsplash](https://unsplash.com/join)  
  iv. [Yelp](https://www.yelp.com/signup?return_url=https://www.yelp.com/seeyousoon)
1. In the application's `config/application.yml` file, add your client api key for each of the following environment variables:  
  i. `MAPQUEST_KEY: <YOUR_MAPQUEST_API_KEY>`  
  ii. `OPEN_WEATHER_KEY: <YOUR_OPEN_WEATHER_API_KEY>`  
  iii. `UNSPLASH_KEY: <YOUR_UNSPLASH_API_KEY>`  
  iv. `YELP_KEY: <YOUR_YELP_API_KEY>`  

# Endpoints 
Using [Postman](https://www.postman.com/), you can query the following endpoints by running your local server (run `rails s` from the command line).

## Forecast 
`GET localhost:3000/api/v1/forecast`  

Params:  
| Key | Value |
| ----- | ----- |  
| location | < input >  


Acceptable format examples for < input > :   
1. `Denver` 
1. `Denver, CO` 
1. `123 street address, Denver Co`

Errors: 
1. `Illegal argument from request: Insufficient info for location`
    - Missing location param 

## Background Image for City 
`GET localhost:3000/api/v1/backgrounds`

Params:  
| Key | Value |
| ----- | ----- |  
| location | < input >  


Acceptable format examples for < input > :   
1. `city of Denver` 
1. `Denver, CO downtown` 

Errors: 
1. `"No results found for '< input >'"`
    - Try revising your input search word(s) 
1. `"No results found for ''"` 
    - Missing location param 

## User Registration 
`POST localhost:3000/api/v1/users`

Request body: 
```
{
  "email": "< email >",
  "password": "< password >",
  "password_confirmation": "< password >"
} 
```
Successful registration returns: 
1. id 
1. email attribute 
1. api_key attribute (use this key for road trip destination forecast requests)

Errors: 
1. `Missing Email, Password, Password Confirmation in request body` 
    - Make sure you are inputing values in the body of the request like the example above
1. `Email has already been taken`
    - You must input a unique email 
1. `Password confimation doesn't match Password` 


## User Login
`POST localhost:3000/api/v1/sessions`

Request body (the below example data can be used to demo request): 
```
{
  "email": "email@example.com",
  "password": "password"
} 
```
Successful login returns: 
1. id 
1. email attribute 
1. api_key attribute (use this key for road trip destination forecast requests)

Errors: 
1. `The email password combination is invalid`
    - Try a different combination, either the email, password, or both or incorrect 
1. `Missing Email and Password in request body`

## Road Trip Destination Forecast 
`POST localhost:3000/api/v1/road_trip`

Request body:
```
{
  "origin": "< start location >",
  "destination": "< end location > ",
  "api_key": "< your_api_key >"
}
```
Acceptable format examples for < location > inputs:   
1. `Denver` 
1. `Denver, Colorado` 
1. `1234 address st. Denver, CO 80111` 


Errors: 
1. `Missing Origin, Destination, Api Key in request body`
1. `Invalid api key`
1. An `Impossible route` (eg. 'Denver, CO' to 'London, England') will return a formatted response, but the `travel_time` attribute will read `Impossible route` 
