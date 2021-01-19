require 'rails_helper' 

RSpec.describe 'User Registration' do
  
  describe 'with valid and unique credentials' do 
    before :each do 
      
    end

    it 'responds with the created user\'s email and unique api_key' do 
      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }

      email = 'whatever@example.com'
      password = 'password'
      
      body = {
        "email": email,
        "password": password,
        "password_confirmation": password
      }

      post '/api/v1/users', headers: headers, params: body.to_json

      expect(response.status).to eq 201 

      response_body = JSON.parse(response.body, symbolize_names: true)
      result = response_body[:data]
      attributes = result[:attributes]

      expect(response_body).to have_key(:data)
      expect(result[:type]).to eq('users')
      expect(result[:id]).to be_a(String)
      expect(result[:attributes]).to be_a(Hash)
      expect(attributes).to have_key(:email)
      expect(attributes[:email]).to eq(email)
      expect(attributes).to have_key(:api_key)
    end
  end

  describe 'error handling' do 
    it 'returns error if email is taken' do 
      user = create(:user)
      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
      # With the same email 
      body = {
        "email": user.email,
        "password": user.password,
        "password_confirmation": user.password
      }

      post '/api/v1/users', headers: headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('Email has already been taken')

      # With alternate case email 
      body = {
        "email": user.email.upcase,
        "password": user.password,
        "password_confirmation": user.password
      }

      post '/api/v1/users', headers: headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('Email has already been taken')
    end

    it 'returns an error if password fields do not match' do 
      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
      email = 'whatever@example.com'
      password = 'password'
      password2 = 'password2'
      
      body = {
        "email": email,
        "password": password,
        "password_confirmation": password2
      }

      post '/api/v1/users', headers: headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('Password confirmation doesn\'t match Password')
    end

    it 'returns an error if there is a missing field' do 
      headers = { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
      email = ''
      password = 'password'
      password2 = 'password2'
      
      body = {
        "email": email,
        "password": password,
        "password_confirmation": password
      }

      post '/api/v1/users', headers: headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('Email can\'t be blank')
    end
  end
end
