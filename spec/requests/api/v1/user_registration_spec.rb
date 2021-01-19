require 'rails_helper' 

RSpec.describe 'User Registration' do
  # See rails helper for defined_headers, parse_json, and define_body(*)
  
  describe 'with valid and unique credentials' do 
    it 'responds with the created user\'s email and unique api_key' do 
      email = 'whatever@example.com'
      password = 'password'
      
      body = define_body(email, password, password)

      post '/api/v1/users', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 201 

      response_body = parse_json
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

  describe 'error handling with invalid credentials' do 
    it 'returns error if email is taken' do 
      user = create(:user)

      # With the same email 
      body = define_body(user.email, user.password, user.password)

      post '/api/v1/users', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('Email has already been taken')

      # With alternate case email 
      body = define_body(user.email.upcase, user.password, user.password)

      post '/api/v1/users', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('Email has already been taken')
    end

    it 'returns an error if password fields do not match' do 
      email = 'whatever@example.com'
      password = 'password'
      password2 = 'password2'
      
      body = define_body(email, password, password2)

      post '/api/v1/users', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('Password confirmation doesn\'t match Password')
    end

    it 'returns an error if there is a missing field' do 
      email = ''
      password = 'password'
      
      body = define_body(email, password, password)

      post '/api/v1/users', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('Email can\'t be blank')
    end

    it 'returns an error if the request body is missing' do 
      email = 'whatever@example.com'
      password = 'password'

      # Missing body 
      post '/api/v1/users', headers: defined_headers
      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Email, Password, Password Confirmation in request body')
      
      # Missing email in body 
      body = define_body(nil, password, password)

      post '/api/v1/users', headers: defined_headers, params: body.to_json 
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Email in request body')

      # Missing password in body 
      body = define_body(email, nil, password)

      post '/api/v1/users', headers: defined_headers, params: body.to_json 
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Password in request body')

      # Missing password confirmation in body 
      body = define_body(email, password, nil)

      post '/api/v1/users', headers: defined_headers, params: body.to_json 
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Password Confirmation in request body')
    end
  end
end
