# Xchangerator AppServer

## Redis
### Install
MacOS
```
brew install redis
```

Linux

https://www.hugeserver.com/kb/install-redis-debian-ubuntu/
```
sudo add-apt-repository ppa:chris-lea/redis-server
sudo apt-get update
sudo apt-get install redis-server
```

### Launch Redis server
```
redis-server
```


## Development:
Create `.env` file with key-value pairs for environment variables used by the server

Sample `.env`
```
NODE_ENV=development
API_KEY=xxx
PORT=3000
SERVICE_ACCOUNT_KEY_PATH=xchangerator-firebase-adminsdk-q2sf5-0e1d050c6a.json
```

launch
```
npm run dev
```

## Production

Sample `.env`
```
NODE_ENV=production
API_KEY=xxx
SERVICE_ACCOUNT_KEY_PATH=xchangerator-firebase-adminsdk-q2sf5-0e1d050c6a.json
```

launch
```
npm start
```

reload
```
npm run reload
```
