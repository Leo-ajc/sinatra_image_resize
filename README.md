
Build Docker container
```docker-compose up --build```

Run with Pry enabled
```docker-compose run --service-ports web```

Run the tests
```docker-compose run web bundle exec rspec```

```curl http://localhost:3333/info\?url\=https://i.imgur.com/fIokC3D.jpg```

```curl http://localhost:3333/thumbnail\?url\=https://i.imgur.com/fIokC3D.jpg```

