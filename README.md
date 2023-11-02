# The Mail Service

# Technologies used

- [**Ruby on Rails**](https://rubyonrails.org/)
> REST API architecture used.
- [**Falcon**](https://github.com/socketry/falcon)
> Ruby fiber based asynchronous rack server
- [**Devise JWT**](https://github.com/waiting-for-dev/devise-jwt)
> For JWT Token based authentication
- [**Access Granted**](https://github.com/chaps-io/access-granted)
> For authorization of routes/resources based on user role
- [**Sidekiq**](https://github.com/mperham/sidekiq)
> For background processing of compute heavy jobs
- [**Rspec Rails**](https://github.com/rspec/rspec-rails)
> As an alternative testing framework with more ease
- [**postgresql**](https://www.postgresql.org/)
> Database used to store the data in relational format
- [**Docker**](https://www.docker.com/)
> Used for local development setup.
# Implementation Checklist
- Generic API exception handling
- Flexible role based authorization
# Areas for Improvements
- Current optimization technique only takes into account train's cost per kg and makes sure bigger packages gets delivered at lowest cost. It can be further optimized through an extension of knapsack problem with multiple weight dimensions(Weight and Volume in our case), while also using cost matrix to identify which parcels were picked(Knapsack only returns maximum weight that can be achieved)
- We can also take into account loss per train (by weight / by volume) for calculating optimal cost
- Testing can be extended to models/helpers etc
- More robust scheduling to ensure lines/trains safety(Dead jobs etc).


# Database structure
![DB_ERD](vendor/DB_ERD.jpeg)

# Local setup and running

Install docker on your system

- **MacOS**

> Install homebrew package manager
>
> ```sh
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
> ```

Install docker desktop and git with brew cask

> ```sh
> brew install git
> brew install --cask docker
> ```

- **Windows**

> Install/Update windows package manager winget (Update app installer package from windows store)

Install docker desktop and gitusing winget

> ```sh
> winget install -e --id Git.Git
> winget install -e --id Docker.DockerDesktop
> ```

- **Ubuntu**

Install docker and git using apt package manager

> ```sh
> sudo apt purge -y docker docker-engine docker.io containerd runc
> sudo apt install -y \
> apt-transport-https \
> ca-certificates \
> curl \
> gnupg-agent \
> software-properties-common
> curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
> echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
> sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io git
> sudo systemctl restart docker
> sudo systemctl enable docker
> sudo curl -L "https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
> sudo chmod +x /usr/local/bin/docker-compose
> sudo groupadd docker
> sudo usermod -aG docker $USER
> newgrp docker
> ```

unzip the code in any directory

```sh
unzip exam-long-mail-service.zip
```

Move to project directory

```sh
cd exam-long-mail-service.zip
```

Run project

```sh
docker-compose up
docker-compose exec app bundle exec rails db:seed
```

To run the test suite
```sh
docker-compose run app bundle exec rspec
```

Application can be accessed from url localhost:3000
Database GUI can be accessed from url localhost:1234
> PGAmin4 password : admin

> Database password : password

**Check API response through curl (or postman)**
Sign In Request:

```sh
curl -X POST \
  'localhost:3000/users/sign_in' \
  --include \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "user": {
        "email": "operator1@jenfi.com",
        "password": "password"
    }
}'
```

**Response:**

```
HTTP/1.1 200 OK
x-frame-options: SAMEORIGIN
x-xss-protection: 0
x-content-type-options: nosniff
x-download-options: noopen
x-permitted-cross-domain-policies: none
referrer-policy: strict-origin-when-cross-origin
content-type: application/json; charset=utf-8
vary: Accept, Origin
authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwZTg4OGJiYi03MzliLTRlYTctYWQwZi1jM2EwZTZkMWU5ZmYiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjU4OTU4ODE2LCJleHAiOjE2NTg5NTk3MTZ9.BX5vcBoL7Msm5GUCIVqAaqOv7n8rLavZPAbRF6acBBU
etag: W/"cc2ed46d02b642d6ee7cb2003f6f3509"
cache-control: max-age=0, private, must-revalidate
x-request-id: 66904441-778d-4032-a9b0-32a2ecf2b4fa
x-runtime: 0.186750
server-timing: start_processing.action_controller;dur=0.050048828125, sql.active_record;dur=0.890380859375, instantiation.active_record;dur=0.03515625, process_action.action_controller;dur=184.153564453125
vary: accept-encoding
transfer-encoding: chunked

{"status":{"code":200,"message":"Logged in successfully."},"data":{"name":"Jamar","email":"operator1@jenfi.com","role":"operator","created_at":"2022-07-27T21:51:35.211Z"}}
```
Copy Bearer token in authorization header to be used in subsequent API calls

List Trains by an operator

```sh
curl -X GET \
  'localhost:3000/trains' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwZTg4OGJiYi03MzliLTRlYTctYWQwZi1jM2EwZTZkMWU5ZmYiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjU4OTU4ODE2LCJleHAiOjE2NTg5NTk3MTZ9.BX5vcBoL7Msm5GUCIVqAaqOv7n8rLavZPAbRF6acBBU'
'
```
**Response:**
```json
{
  "data": [
    {
      "id": "1",
      "type": "train",
      "attributes": {
        "id": 1,
        "name": "Aracelis",
        "cost": 100,
        "weight": 10.0,
        "volume": 10.0,
        "status": "waiting",
        "created_at": "2022-07-27T21:51:35.234Z"
      }
    }
  ]
}
```

Book Trains by postmaster

```sh
curl -X POST \
  'http://localhost:3000/bookings' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI2YTI2NWQ0MC03ZmFmLTRjMDItYTU3YS00YThkMGM3M2I5MDQiLCJzdWIiOiI3Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjU4ODk5NzQxLCJleHAiOjE2NTg5MDA2NDF9.-yadFW9PwZayi6pKWSVeV2GvGUfg4e804A9ep8B6Gug' \
  --data-raw '{
 "train_id": 1
}'
```
**Response:**
```json
{
  "message": "Train booking is scheduled"
}
```


List Trains by sorted by lowest cost per kg

```sh
curl -X GET \
  'http://localhost:3000/bookings' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI5YTM4NTk5YS04MzA3LTRjZTktYmE5NS0zNDgzOTdlZDUyZjQiLCJzdWIiOiI2Iiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjU4OTU5MjY3LCJleHAiOjE2NTg5NjAxNjd9.5-LawzQFpS5am3czP6W52gwa8ZI5Gm_oHDGPp4oHbbs'
```
**Response:**
```json
[
  {
    "id": 3,
    "name": "Porfirio",
    "cost": 300,
    "weight": 30.0,
    "volume": 30.0,
    "lines": [
      "C",
      "B"
    ],
    "cost_per_kg": 10.0,
    "operator_name": "Harold"
  },
  {
    "id": 2,
    "name": "Gabriele",
    "cost": 200,
    "weight": 20.0,
    "volume": 20.0,
    "lines": [
      "B",
      "C"
    ],
    "cost_per_kg": 10.0,
    "operator_name": "Laronda"
  },
  {
    "id": 1,
    "name": "Aracelis",
    "cost": 100,
    "weight": 10.0,
    "volume": 10.0,
    "lines": [
      "D",
      "B"
    ],
    "cost_per_kg": 10.0,
    "operator_name": "Jamar"
  }
]
```
