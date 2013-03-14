# Omawho

Omawho is a self-hosted gallery of your community's creative faces. It's an
easy way to gather and browse the people you're likely to run into at
events around your town.

![Omawho for Omaha](http://omawho.com/assets/omawho-share-c2aeb14a3f36ce0ad996bb2c24cf1f72.png)

## Background

We originally built Omawho for our town - Omaha, Nebraska - to help us remember
the names of people we would occasionally bump into, and also because we
thought it'd be a fun community project.

Similar websites exist for other communities: [Des Moines](http://desmob.com/),
[Portland, Maine](http://www.creativeportland.com/people/all),
[Portland, Oregon](http://prtlnd.com/).

## Features

It's very simple: New people can add their faces. It's free.

Visitors can filter faces by industry (Web/Software, Graphic Design, Music, etc).
Click a face to view an expanded profile.

You can also mark yourself as an attendee at events. That way, you and other
visitors can filter the faces to only show people who will be (or who were) at
a certain event.

Anyone can submit new events for the list. As the "Admin" user, you have to
approve submitted events before they show up to the public.

## Setup

Want to roll your own Omawho for your community? Here's how:

### Disclaimer

This isn't installable software in the way that iTunes or Excel are installable.
We're going to explain the setup as clearly as we can, but you will need some
technical know-how to get this going. If that's alright with you, read on...

### Installation Instructions

#### 1. Download Omawho to your computer.

You can either `git clone git@github.com:bigwheelbrigade/omawho.git` in a terminal,
or [download a ZIP](https://github.com/bigwheelbrigade/omawho/archive/master.zip).

---

#### 2. Get Omawho running on your computer.

Omawho is a [Ruby on Rails](http://rubyonrails.org/) application. Hopefully it's
not your [first](http://cdn.memegenerator.net/instances/400x/36168434.jpg)
Rails application.

Assuming you have Rails running, run `bundle install` from the **/omawho**
directory to install the dependencies.

You'll also need [Postgres SQL](http://postgresapp.com/) for the database.

##### Configure your Omawho installation.

If you haven't already, [sign up for Amazon S3](http://s3.amazon.com). That's 
where you'll be storing people's face photos.

###### Environment Settings

Open the **.env_example** file in a text-editor. It should look something like 
this:

```
RACK_ENV=development
RAILS_ENV=development
PORT=5000
DEVELOPER_EMAIL=official@yoursite.com
DATABASE_URL=postgres://pg_username@pg_host/pg_database_name
AWS_ID=foo_bar
AWS_SECRET=amazon_secret
AWS_FOLDER=bucket_name_on_amazon
```

This file contains various configuration setting. You need to change the
following ones:

- DEVELOPER_EMAIL - Set this to your personal email address. When you're
testing Omawho locally, any emails sent out by the application (like for
forgotten passwords) will be intercepted and sent to you instead. Obviously
this doesn't do anything in Production.
- DATABASE_URL - Change pg_username to your Postgres username (It's probably
"postgres"); change pg_host to your Postgres host (It's probably "localhost");
change pg_database_name to your desired database name for this application (e.g.
"omawho_development").
- AWS_ID - Set this to your Amazon S3 Access Key ID.
- AWS_SECRET - Set this to your Amazon S3 Secret Access Key.
- AWS_FOLDER - Set this to the name of your S3 bucket.

When you're finished, **rename the file to .env** (So remove the **_example**
part).

###### Other Settings

Open **/config/database.yml** in a text-editor. Find the following block of
code:

```
development:
  adapter: postgresql
  database: omawho_development
  host: localhost
```

Change the values of 'database' and 'host' to the 'pg_database_name' and
'pg_host' values from above.

Open **/app/controllers/application_controller** in a text-editor. Find the 
`application_configuration` section. You can customize your site's title, 
location, etc. there.

Open **app/mailers/user_mailer.rb** in a text-editor. Change the email address 
and display name (These are what's shown to users that the application emails -
as in the case of a forgotten password email).

Open **app/models/user.rb** in a text-editor. Change the value of `CATEGORIES`
to the categories you want your site to use. Each category is a key/value pair,
like `"graphic_design" => "Graphic Design"` - the first part is what's used in
URLs; the second part is what's displayed. Separate the pairs with commas.

###### Initialize Database

From the Omawho directory in a terminal, run the following commands:

1. `bundle exec rake db:create` to create the database
2. `bundle exec rake db:migrate` to generate the tables
3. `bundle exec rake db:seed` to generate your admin account.

##### Run Omawho!

From the Omawho directory in a terminal, run `foreman start` to spin up the
Omawho web server. Go to http://localhost:5000 in your web browser to see it in
action.

You can log in with admin@example.com (password: jijijiji).

If everything is working, you're ready to share it with your community...

---

#### 3. Share It

If you don't already have an account, [sign up for Heroku](http://heroku.com).
Heroku is the web host we're going to use. You'll also need to install the
[Heroku Toolbelt](https://toolbelt.heroku.com/). When you finish...

##### Create a Heroku App

From the Omawho directory in a terminal, run the following commands:

1. `git init` - This makes your application a Git repository (if it wasn't already).
2. `heroku create your-app-name` (replacing "your-app-name" with something of 
your own, of course)

This will create an empty application server at http://your-app-name.herokuapp.com.
You're going to host your customized Omawho there. Later, you'll be able to set
up a custom domain for it (So it'd be http://your-app-name.com).

##### Prepare for Deployment

Next, run the following commands to prepare your application for deployment to
Heroku:

1. `git add .`
2. `git commit -m "Deploying my own Omawho for the first time."`

##### Configure Heroku Server

Then run the following commands to configure the Heroku server:

1. `heroku config:set MAIL_HOST_URL=your-app-name.herokuapp.com` - Again, change
"your-app-name" to reflect your actual application URL.
2. `heroku config:set AWS_ID=123foobar AWS_SECRET=loremipsum_567 
AWS_FOLDER=your_folder` - Change the values to the ones you used when you
configured the **.env** file.
3. `heroku addons:add heroku-postgresql:dev` - This creates your database on Heroku.
4. `heroku addons:add sendgrid:starter` - This lets your application send emails.

##### Deploy!

Almost done. Now run `git push heroku master` to push the application up to the
Heroku server. This one will take several minutes to complete. When it finishes,
run the following commands to wrap things up:

1. `heroku run rake db:migrate`
2. `heroku run rake db:seed`

When those finish, go to http://your-app-name.herokuapp.com. You can log in with 
admin@example.com (password: jijijiji).

Hopefully this worked. If it didn't, feel free to [ask questions](http://github.com/bigwheelbrigade/omawho/issues).

##### Custom Domain

Read this article on Heroku to use a [custom domain with your application](http://your-app-name.herokuapp.com).

## Contributing

We built this very quickly over a weekend. The code is stable, but it could be
better. If you feel like hacking on it a bit, fork away - we welcome all Pull 
Requests.