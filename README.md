# nT Read Service

[ ![Codeship Status for yzhan1/nt-read-service](https://app.codeship.com/projects/d7948740-2be1-0136-e263-56d0818919a1/status?branch=master)](https://app.codeship.com/projects/287893) [![Maintainability](https://api.codeclimate.com/v1/badges/f4b29796ab489f75ce35/maintainability)](https://codeclimate.com/github/yzhan1/nt-read-service/maintainability)

This is the repo for nT read service. Currently there are two read services deployed to Heroku.

### Microservice Functionality
This microservice only serves `GET` request by checking if the required page has been cached in Redis. If cache has been found, return the cache. Otherwise, it redirects the request to the same path of the write service. Then write service will generate the page cache by doing database query and `erb` call, and saves the cache into Redis. The next time when the same page has been required, read service can pull from cache directly.

Reader 1: https://nt-r1.herokuapp.com/

Reader 2: https://nt-r2.herokuapp.com/

### Getting Started
Before running anything, do `bundle`

To run the service:
+ First run `brew services start redis` or any equivalent command to start redis
+ Then run `bundle exec puma`. Notice that you might need to start the load balancer app and write service too

To run tests:
+ `bundle exec rake test`