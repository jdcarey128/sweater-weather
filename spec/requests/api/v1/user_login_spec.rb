require 'rails_helper' 

RSpec.describe 'User Login' do 
  # See rails helper for defined_headers, parse_json, and define_body(*)

  describe 'with valid credentials' do 
    it 'user can log in' do 
      user = create(:user)
      body = define_body(user.email, user.password)

      post '/api/v1/sessions', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 200
      
      response_body = parse_json
      
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

      body = define_body(user_2.email, user_2.password)
      
      post '/api/v1/sessions', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = parse_json

      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('The email password combination is invalid')
    end

    it 'a user\'s password does not match db' do 
      body = define_body(@user.email, 'password2')
      
      post '/api/v1/sessions', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = parse_json

      expect(response_body[:error]).to eq 400
      expect(response_body[:message]).to eq('The email password combination is invalid')
    end

    it 'there is one or more missing fields' do 
      body = define_body('', @user.password)
      
      # Missing email
      post '/api/v1/sessions', headers: defined_headers, params: body.to_json

      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Email can\'t be blank')

      # Missing password
      body = define_body(@user.email, '')

      post '/api/v1/sessions', headers: defined_headers, params: body.to_json

      expect(response_body[:error]).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Password can\'t be blank')

      # Missing email and password 
      body = define_body('', '')

      post '/api/v1/sessions', headers: defined_headers, params: body.to_json

      expect(response_body[:error]).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Email and Password can\'t be blank')
    end

    it 'does not send a body in request' do 
      # Missing body 
      post '/api/v1/sessions', headers: defined_headers

      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Email and Password in request body')

      # Missing password in body 
      body = define_body(@user.email, nil)

      post '/api/v1/sessions', headers: defined_headers, params: body.to_json 
      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Password in request body')

      # Missing email in body 
      body = define_body(nil, @user.password)
      
      post '/api/v1/sessions', headers: defined_headers, params: body.to_json
      expect(response.status).to eq 400
      response_body = parse_json
      expect(response_body[:message]).to eq('Missing Email in request body')
    end
  end
end
