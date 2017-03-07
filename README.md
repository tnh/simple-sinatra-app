Infrastructure Operations Pre-interview test
=============


Provision a new application server and deploy the following application
-------
A development team wants you to deploy this simple web app. 
- come up with a way to deploy this app and write configuration-as-code to deploy it
- ensure that the instance is locked down and secure 
- suggest ways to do ongoing deployments on this application


Expected output
-------------
- A method of being able to do repeatable deployments of the simple web application
- Within a readme or similar, articulate the reasons for the decisions you made 
- Share this output with the hiring manager - via a link to a git project, text file, or artifact  

 


To get this application working locally
=============

    git clone git://github.com/tnh/simple-sinatra-app.git
    shell $ bundle install
    shell $ bundle exec rackup

Mod passenger:
http://www.modrails.com/documentation/Users%20guide%20Apache.html

Unicorn nginx:
http://sirupsen.com/setting-up-unicorn-with-nginx/

