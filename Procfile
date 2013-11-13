web: bin/proximo bundle exec rails server thin -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq -q high,5 -q default