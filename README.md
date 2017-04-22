## Project Features

1. CRUD Operations
2. Filters
3. Full-Text Search
4. Autocomplete functionality


## Trying out the project

I have hosted the latest code on an Vultr instance. You can import the Postman collection (by clicking the button below) into the Postman app to try out the API's without any installation.


[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/18bec1f50acb14a5b4f8)


## Installation

These instructions will help setup the project locally.

1. Clone the repository

`git clone https://github.com/neha9t/task-management-app`

2. Follow the instructions [here](https://rvm.io/rvm/install) to install RVM. Make sure to source rvm as mentioned at the end of the installation instructions.

3. Install Ruby-2.4.0 using `rvm install ruby-2.4.0`

4. Install MySQL by doing

For ubuntu

You would be prompted to set a root password during the installation.

```
sudo apt-get update

sudo apt-get install mysql-server

sudo apt-get install libmysqlclient-dev

sudo mysql_secure_installation

```

For Mac

// TODO - Verify instructions on Mac.
`brew install mysql`

5. Install a Javascript runtime `sudo apt-get install nodejs`.

6. Install bundler using `gem install bundler`.

7. `cd` into the project directory and run `bundle install`.

8. Setup the database and run migrations.

* Go to config/database.yml and change your `username` and `password` to your MySQL credentials so that the app can access the database.

* Run `rake db:create`.

* Run `rake db:migrate`.

For production run `RAILS_ENV=production rake db:create db:migrate`

9. Finally run `rails s` and go to [http://localhost:3000](http://localhost:3000).

## Running the tests

10.Run : `rake spec` to run model and controller tests

11.Run : `bundle exec rspec` to run controller tests

12. For specific tests, run : `bundle exec rspec ./spec/controllers/task_controller_spec.rb:<line-number>`

