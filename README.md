# User create, general flow :

- `UserController` init the sidekik worker UserWorker
- `UserWorker` handle the User creation and mirroring process in a background process
- `Mirroring` lib in `lib/mirroring` act as master pupetter to create User :
  - will delegate User creation in needed external services
  - will create User in our DB
- External lib in `lib/external` is our interface to interact with external services
  - will create User in Hubspot

**Test :**  
Without surprise in `/spec` folder by Rspec :)   
Acceptance test are in `/request/`.

**Hubspot Integration**
Lib `External::Hubspot` interact with Hubspot API.
To setup your Hubspot account, add an environement variable or edit default value in `config/application.rb` to reference your Hubspot HAPIKEY.
Default one is mine, surely not a good idea but it wont go in production. Will it ? ^^

~~~ruby
#config/application.rb
config.external_api = {
  hubspot: {
    hapikey:  ENV.fetch("HUBSPOT_HAPIKEY") { "95b31970-d630-49c1-acf4-1dcf0e868320" }
  }
}
~~~
