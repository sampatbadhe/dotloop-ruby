# Ruby library for Dotloop API v2

* [Homepage](https://www.dotloop.com)
* [API Documentation](https://dotloop.github.io/public-api)
* [Sign Up](https://www.dotloop.com/#/signup)


## Description

Provides a Ruby interface to [Dotloop](https://www.dotloop.com/). This library is designed to help ruby applications consume the DotLoop API v2.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dotloop-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotloop-ruby

## Usage


### Setup

Register for your OAuth2 credentials by creating a client at https://www.dotloop.com/my/account/#/clients.

NOTE: You'll need at least `Account Access: Read` to use this strategy.

### Authentication

Dotloop uses OAuth2 for authentication (https://dotloop.github.io/public-api/#authentication).

```ruby
  require 'dotloop-ruby'

  dotloop_auth = Dotloop::Authenticate.new(
    app_id: ENV['DOTLOOP_APP_ID'],
    app_secret: ENV['DOTLOOP_APP_SECRET'],
    application: 'dotloop'
  )

  dotloop_auth.url_for_authentication(callback_url, { redirect_on_deny: true })

  # callback_url = The url that Dotloop will redirect the user to when the account is authenticated.

  # It will return code on successfully authenticated.

  code = params[:code]

  access_and_refresh_token = dotloop_auth.acquire_access_and_refresh_token(code, { redirect_uri: callback_url })

    {
      "access_token": "0b043f2f-2abe-4c9d-844a-3eb008dcba67",
      "token_type": "Bearer",
      "refresh_token": "19bfda68-ca62-480c-9c62-2ba408458fc7",
      "expires_in": 43145,
      "scope": "profile:*, loop:*"
    }
```

### Usage

**Initialize**
```ruby
  require 'dotloop-ruby'

  dotloop_client = Dotloop::Client.new(access_token: access_token)
```

**Account Details**
```ruby
  #=> get account details
  account = dotloop_client.account
```

**Profiles**
```ruby
  #=> get list of profiles
  profiles = dotloop_client.Profile.all

  #=> get single profile
  profile = dotloop_client.Profile.find(profile_id: '1234')

  #=> get list of loops for profile
  loops = dotloop_client.Profile.find(profile_id: '1234').loops

  #=> create new loop in profile
  loops = dotloop_client.Profile.find(profile_id: '1234').create(data)
    data = {
      "name": "Atturo Garay, 3059 Main, Chicago, IL 60614",
      "status": "PRE_LISTING",
      "transactionType": "LISTING_FOR_SALE"
    }

  #=> create new loop in profile using `loop-it`
  loops = dotloop_client.Profile.find(profile_id: '1234').loop_it(data)
    data = {
      "name": "Brian Erwin",
      "transactionType": "PURCHASE_OFFER",
      "status": "PRE_OFFER",
      "streetName": "Waterview Dr",
      "streetNumber": "2100",
      "unit": "12",
      "city": "San Francisco",
      "zipCode": "94114",
      "state": "CA",
      "country": "US",
      "participants": [
        {
          "fullName": "Brian Erwin",
          "email": "brianerwin@newkyhome.com",
          "role": "BUYER"
        },
        {
          "fullName": "Allen Agent",
          "email": "allen.agent@gmail.com",
          "role": "LISTING_AGENT"
        },
        {
          "fullName": "Sean Seller",
          "email": "sean.seller@yahoo.com",
          "role": "SELLER"
        }
      ],
      "templateId": 1424,
      "mlsPropertyId": "43FSB8",
      "mlsId": "789",
      "mlsAgentId": "123456789"
    }
```

**Profile Loops**
```ruby
  #=> get list of loops for profile
  loops = dotloop_client.Loop.all(options)
    options = {
      profile_id: '1234',
      *batch_number: 1,
      *batch_size: 50
    }

  #=> get single loop
  loop = dotloop_client.Loop.find(profile_id: 1234, loop_id: 34308)

  #=> create new loop
  loop = dotloop_client.Loop.create(profile_id: 1234, params: params)
    params = {
      "name": "Atturo Garay, 3059 Main, Chicago, IL 60614",
      "status": "PRE_LISTING",
      "transactionType": "LISTING_FOR_SALE"
    }

  #=> update loop
  loop = dotloop_client.Loop.update(profile_id: 1234, loop_id: 34308, params: data)
  OR
  loop = dotloop_client.Loop.find(profile_id: 1234, loop_id: 34308).update(data: data)
    data = {
      "status": "SOLD"
    }
```

**Loop Details**
```ruby
  #=> get single loop details
  loop_details = dotloop_client.Loop.detail(profile_id: 1234, loop_id: 34308)
  OR
  loop_details = dotloop_client.Loop.find(profile_id: 1234, loop_id: 34308).detail

  #=> update single loop details
  loop_details = dotloop_client.Loop.update_details(profile_id: 1234, loop_id: 34308, data: data)
  OR
  loop_details = dotloop_client.Loop.find(profile_id: 1234, loop_id: 34308).update_details(params: data)
    data = {
      # https://dotloop.github.io/public-api/#parameters-12
    }
```

**Loop Folders**
```ruby
  #=> get list of folders for loop
  folders = dotloop_client.Folder.all(options)
    options = {
      profile_id: '1234',
      loop_id: '34308'
    }

  #=> get single folder
  folder = dotloop_client.Folder.find(profile_id: 1234, loop_id: 34308, folder_id: 423424)

  #=> create new folder
  folder = dotloop_client.Folder.create(profile_id: 1234 loop_id: 34308, params: params)
    params = {
      "name": "Disclosures"
    }

  #=> update folder
  folder = dotloop_client.Folder.update(profile_id: 1234, loop_id: 34308, folder_id: 423424, params: data)
    data = {
      "name": "Disclosures (renamed)"
    }
```

**Loop Documents**
```ruby
  #=> get list of documents for folder
  documents = dotloop_client.Document.all(options)
    options = {
      profile_id: '1234',
      loop_id: '34308',
      folder_id: '423424'
    }

  #=> get single document
  document = dotloop_client.Document.find(
    profile_id: '1234',
    loop_id: '34308',
    folder_id: '423424',
    document_id: '561621'
  )

  #=> upload new document
  document = dotloop_api.Document.upload(
    profile_id: '1234',
    loop_id: '34308',
    folder_id: '423424',
    params: { "file_url" => file_url, "file_name" => file_name }
  )

  #=> dowload a document - Retrieve an individual document (binary)
  document = dotloop_api.Document.get(
    profile_id: '1234',
    loop_id: '34308',
    folder_id: '423424',
    document_id: '561621'
  )
```

**Loop Participants**
```ruby
  #=> get list of participants for loop
  participants = dotloop_client.Participant.all(options)
    options = {
      profile_id: '1234',
      loop_id: '34308'
    }

  #=> get single participant
  participant = dotloop_client.Participant.find(
    profile_id: '1234',
    loop_id: '34308',
    participant_id: '24743'
  )

  #=> create participant for loop
  participant = dotloop_client.Participant.create(
    profile_id: '1234',
    loop_id: '34308',
    params: params
  )
    params = {
      "fullName": "Brian Erwin",
      "email": "brian@gmail.com",
      "role": "BUYER"
    }

  #=> update participant
  participant = dotloop_client.Participant.update(
    profile_id: '1234',
    loop_id: '34308',
    participant_id: '24743',
    params: params
  )
    params = {
      "email": "brian@gmail.com"
    }

  #=> delete participant
  participant = dotloop_client.Participant.delete(
    profile_id: '1234',
    loop_id: '34308',
    participant_id: '24743'
  )
```

**Loop Templates**
```ruby
  #=> get list of loop templates for profile
  loop_templates = dotloop_client.Loop.all(profile_id: '1234')

  #=> get single loop template
  loop = dotloop_client.Loop.find(profile_id: '1234', loop_template_id: '423')
```

**Loop Tasks**
```ruby
  #=> get list of tasklists for loop
  tasklists = dotloop_client.Tasklist.all(profile_id: '1234', loop_id: '34308')

  #=> get single tasklist
  tasklist = dotloop_client.Tasklist.find(
    profile_id: '1234',
    loop_id: '34308',
    task_list_id: '12345'
  )

  #=> get list of task for loop
  tasklists = dotloop_client.Task.all(
    profile_id: '1234',
    loop_id: '34308',
    task_list_id: '12345'
  )

  #=> get single task
  tasklist = dotloop_client.Task.find(
    profile_id: '1234',
    loop_id: '34308',
    task_list_id: '12345'
    task_id: '125736485'
  )

```

**Contacts**
```ruby
  #=> get list of contacts
  contacts = dotloop_client.Contact.all(options)
    options = {
      *batch_number: 1,
      *batch_size: 50
    }

  #=> get single contact
  contact = dotloop_client.Contact.find(contact_id: '3603862')

  #=> create new contact
  contact = dotloop_client.Contact.create(params: params)
    params = {
      "firstName": "Brian",
      "lastName": "Erwin",
      "email": "brianerwin@newkyhome.com",
      "home": "(415) 8936 332",
      "office": "(415) 1213 656",
      "fax": "(415) 8655 686",
      "address": "2100 Waterview Dr",
      "city": "San Francisco",
      "zipCode": "94114",
      "state": "CA",
      "country": "US"
    }

  #=> update contact
  contact = dotloop_client.Contact.update(
    contact_id: '3603862',
    params: params
  )
    params = {
      "home": "(415) 888 8888"
    }

  #=> delete contact
  dotloop_client.Contact.delete(contact_id: '3603862')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sampatbadhe/dotloop-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

