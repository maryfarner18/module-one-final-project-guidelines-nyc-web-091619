# **dog.go**
_Connecting Dog Owners and Walkers to Create a Cohesive Community of Dog Lovers_

## Data Models

* Dogs `belong_to` and Owner, and an Owner `has_many` dogs.
* A Dog `has_many` Walkers `through` Walks
* A Walker `has_many` Dogs `through` Walks
* A User is either an Owner or a Walker (`has_one`) and the Owner/Walker `belongs_to` the User



## Users
Sign up as either a walker or owner in order to request, view, and complete walks. 

#### Owners Can:
* See their Dogs and add more Dogs to their profile
* Request a walk
* See Upcoming, Past, and Current Walks
* Rate a past Walk
* Cancel an Upcoming Walk

#### Walkers Can:
* See Upcoming, Past, and Current Walks
* Start and End a Walk
* Cancel an Upcoming Walk
 
##### Walker Requirements
* A Walker can only start a walk if it is scheduled within the next 24 hours
* A Walker can only have one Walk "In Progress" at a time
* If a Walker's rating drops below 3.0, they are fired



## Installation

Fork and clone to your machine

```ruby
git clone https://github.com/maryfarner18/module-one-final-project-guidelines-nyc-web-091619
```

And then execute:

    $ bundle



## Usage

From the main project directory, execute

    $ ./bin/run.rb

**For best results, make your terminal full screen.**



## Contributing
Fork it ( https://github.com/maryfarner18/module-one-final-project-guidelines-nyc-web-091619/fork  )
Create your feature branch (git checkout -b my-new-feature)
Commit your changes (git commit -am 'Add some feature')
Push to the branch (git push origin my-new-feature)
Create a new Pull Request
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.

## Copyright

See LICENSE.md for further details.