# Humilamotron

Keeps track of how often your friends like their own messages in GroupMe.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Installing

First, clone this repository with `git clone https://github.com/lnestor/humilamotron.git`.

## Deployment

If deploying to Heroku, run the following steps:

```
heroku login
heroku create
git push heroku master
heroku run rake db:migrate
heroku run
```

If you already have a Heroku app set up, use these commands.

```
heroku login
heroku git:remote -a <YOUR APP NAME>
git push heroku master
heroku run rake db:migrate
heroku run
```

## Adding your access token

GroupMe provides developers with an access token that must be added to your project. Your personal access token can be found at https://dev.groupme.com/ and pressing the Access Token button in the navbar. The token is currently stored as an environment variable using the [Figaro](https://github.com/laserlemon/figaro) gem for development. To set this token in development, run `bundle exec figaro install` and place the following in `config/application.yml`.

```
GROUPME_ACCESS_TOKEN: <your access token>
```

In production, add your access token through Heroku:

```
heroku config:set GROUPME_ACCESS_TOKEN=<YOUR ACCESS TOKEN>
```

## Adding an Admin

In order to be able to whitelist groups, an admin must be created. Currently the only way to do this is from the command line. In development, this can be done with the following:

```
bundle exec rails console
Admin.create!(email: 'test@example.com', password: '123456', password_confirmation: '123456')
```

In production, you must access the Rails console through Heroku.

```
heroku run rails console
Admin.create!(email: <YOUR EMAIL>, password: <YOUR PASSWORD>, password_confirmation: <YOUR PASSWORD>)
```

## Built With

* [Rails](https://rubyonrails.org/) - The web framework used
* [GroupMe](https://groupme.com/en-US/) - The API used
* [Bootstrap](https://getbootstrap.com/) - For styling
