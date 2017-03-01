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