Puntospoint
===========

Website


Installation
------------

Go to project folder:

    $ cd /DIR/TO/PROYECT/LOCATION


To get the latest project version:

    $ git pull origin master


#### To start the project:

Install gems executing:

    $ bundle install --no-deployment

Run migrations executing:

    $ bundle exec rake db:migrate RAILS_ENV=production

Precompile assests for production environment execute:

    $ bundle exec rake assets:precompile RAILS_ENV=production

Start thin server executing:

    $ sudo bundle exec thin -C /DIR/TO/THIN/CONFIGURATION.yml start

***Note:*** Normally

    $ sudo bundle exec thin -C /etc/thin/showtime.yml start

Or to deploy new features or bug fixes:

    $ sudo bundle exec thin -C /DIR/TO/THIN/CONFIGURATION.yml restart


#### Workers

The application is using workers to change the status of events and experiences at the end of their respective deadlines. Hence you to ensure that redis-serve is running executing:

    $ redis-cli ping
        =====>>  PONG

***Note:*** More information on [redis webpage](http://redis.io/topics/quickstart)

And start sidekiq executing:

    $ nohup bundle exec sidekiq -C config/sidekiq_config.yml -e production &

***Note:*** More information on [sidekiq webpage](http://mperham.github.io/sidekiq/)


Application structure
---------------------

The application is divided in 4 namespaces:

```text
Namespaces              Description

eco                     For ECO users can manage their data.
efi                     For EFI users can manage their data.
puntospoint             For Administrators users can manage all data.
corporative             For Web users can buy experiences with their points.
```

Each namespace allows entry to different application environments.

Moreover, the corporative namespace, allows the routes for allows routes for EFI's mini-page, being created the following routes:

```
http://www.puntospoint.cl/empresa/:efi_id
```

or

```
http://www.puntospoint.cl/empresa/:efi_search_name
```


Testing
---------------------
The application is using rspec and factory_girl for testing suite.

To run all rspec files execute:

    $ rspec

Or run a all files in folder executing:

    $ rspec spec/routing

Or run a single file executing:

    $ rspec spec/routing/eco/experiences_routing_spec.rb


Contributing
------------

1. Create your feature branch (`git checkout -b my_new_feature`)
2. Commit your changes (`git commit -am 'Add some feature'`)
3. Push to the branch (`git push origin my_new_feature`)
4. Create new Merge Request
