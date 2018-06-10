# Humilamorton

Keeps track of how often your friends like their own messages in GroupMe.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Installing

First, clone this repository with `git clone https://github.com/lnestor/humilamotron.git`

## Running the tests

Run the specs with `bundle exec rspec`.

## Adding your access token

GroupMe provides developers with an access token that must be added to your project. Your personal access token can be found at https://dev.groupme.com/ and pressing the Access Token button in the navbar. The token is currently stored as an environment variable using the [Figaro](https://github.com/laserlemon/figaro) gem for development. To set this token in development, run `bundle exec figaro install` and place the following in `config/application.yml`.

```
access_token: <your access token>
```

## Deployment

If deploying to Heroku, run the following steps:

```
heroku create
git push heroku master
heroku run rake db:migrate
heroku config:set access_token=<your access token>
heroku run
```

## Whitelisting groups

Currently there is not way to whitelist groups from the application. Instead, you must go to the command line. In development, this can be done with the following:

```
bundle exec rails console
Group.create!(name: "My Name", groupme_id: <your group's ID from GroupMe>)
```

In production with Heroku, this can be done with the following:

```
heroku run rails console
Group.create!(name: "My Name", groupme_id: <your group's ID from GroupMe>)
```

## Built With

* [Rails](https://rubyonrails.org/) - The web framework used
* [GroupMe](https://groupme.com/en-US/) - The API used
* [Bootstrap](https://getbootstrap.com/) - For styling
