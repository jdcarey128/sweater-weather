# Sweater Weather 

## Summary 

This is a summary of the project (edit at the end).

### Contents
- [Installation](#installation)
- [Endpoints](#endpoints)

## Installation 
1. Clone repo into a local directory `git clone git@github.com:jdcarey128/sweater-weather.git`
1. From the command line, run the following commands:  
  i. `rails db:{create,migrate}`  
 ii. `bundle install`  
iii. `bundle exec figaro install`
1. Register for an api key at each of the API clients (keys may require a couple hours until access is allowed)  
  i. [MapQuest](https://developer.mapquest.com/plan_purchase/steps/business_edition/business_edition_free/register)  
  ii. [OpenWeather](https://home.openweathermap.org/users/sign_up)  
  iii. [Unsplash](https://unsplash.com/join)
1. In the application's `config/application.yml` file, add your client api key for each of the following environment variables:  
  i. `MAPQUEST_KEY: <YOUR_MAPQUEST_API_KEY>`  
  ii. `OPEN_WEATHER_KEY: <YOUR_OPEN_WEATHER_API_KEY>`  
  iii. `UNSPLASH_KEY: <YOUR_UNSPLASH_API_KEY>`

## Endpoints 
