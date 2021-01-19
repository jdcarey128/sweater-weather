require 'rails_helper' 

RSpec.describe 'User Login' do 
  describe 'with valid credentials' do 
    it 'user can log in' do 
      user = create(:user)
      
      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }

      body = {
        "email": user.email,
        "password": user.password
      }
      post '/api/v1/sessions', headers: headers, params: body.to_json

      expect(response.status).to eq 200
      
      response_body = JSON.parse(response.body, symbolize_names: true)
      
      result = response_body[:data]
      attributes = result[:attributes]

      expect(response_body).to have_key(:data)
      expect(result[:type]).to eq('users')
      expect(result[:id]).to be_a(String)
      expect(result[:attributes]).to be_a(Hash)
      expect(attributes).to have_key(:email)
      expect(attributes[:email]).to eq(user.email)
      expect(attributes).to have_key(:api_key)
    end
  end

  describe 'error handling with invalid credentials' do 
    before :all do 
      @user = create(:user)
    end

    it 'a user does not exist in db' do 
      user_2 = build(:user)

      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }

      body = {
        "email": user_2.email,
        "password": user_2.password
      }
      
      post '/api/v1/sessions', headers: headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('The email password combination is invalid')
    end

    it 'a user\'s password does not match db' do 
      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }

      body = {
        "email": @user.email,
        "password": 'password2'
      }
      
      post '/api/v1/sessions', headers: headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('The email password combination is invalid')
    end

    it 'there is one or more missing fields' do 
      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }

      body = {
        "email": '',
        "password": @user.password
      }
      
      # Missing email
      post '/api/v1/sessions', headers: headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq('Email can\'t be blank')

      # Missing password
      body = {
        "email": @user.email,
        "password": ''
      }
      post '/api/v1/sessions', headers: headers, params: body.to_json

      expect(response_body[:error]).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq('Password can\'t be blank')

      # Missing email and password 
      body = {
        "email": '',
        "password": ''
      }
      post '/api/v1/sessions', headers: headers, params: body.to_json

      expect(response_body[:error]).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq('Email and Password can\'t be blank')
    end

    it 'does not send a body in request' do 
      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }

      # Missing body 
      post '/api/v1/sessions', headers: headers

      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq('Missing Email and Password in request body')

      # Missing password in body 
      body = {
        "email": @user.email
      }
      post '/api/v1/sessions', headers: headers, params: body.to_json 
      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq('Missing Password in request body')

      # Missing email in body 
      body = {
        "password": @user.password
      }
      post '/api/v1/sessions', headers: headers, params: body.to_json
      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq('Missing Email in request body')
    end
  end
end
