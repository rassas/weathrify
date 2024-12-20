# Weathrify


## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed

## Setup & Running the Project

1. **Build the Web Image**  
  ```bash
    docker-compose build web
  ```
2. **Create .env file** under the project root path and add `RAILS_MASTER_KEY=xxxx` to it.   
1. **Setup the Database**  
  ```bash
    docker-compose run web bin/rails db:prepare
  ```

1. **RUN the Server**
  ```bash
    docker-compse up
  ```
  The Rails server will start on http://localhost:3000

## API Documentation

All API responses are returned in JSON format.

### Sign Up

**Endpoint:**  
`POST /api/v1/users`

**Request Body:**  
```json
  {
    "username": "YOUR_USERNAME",
    "password": "YOUR_PASSWORD",
    "password_confirmation": "YOUR_PASSWORD"
  }
```

**Successful Response (Status: 200):**
```json
  {
    "user": {
      "id": 1,
      "username": "YOUR_USERNAME"
    },
    "token": "YOUR_AUTH_TOKEN"
  }
```

**Error Response (Status: 422, for example):**
```json
{
  "errors": ["Error message 1", "Error message 2"]
}
```

---

### Sign In

**Endpoint:**  
`POST /api/v1/users/sign_in`

**Request Body:**  
```json
  {
    "username": "YOUR_USERNAME",
    "password": "YOUR_PASSWORD"
  }
```

**Successful Response (Status: 200):**
```json
  {
    "user": {
      "id": 1,
      "username": "YOUR_USERNAME"
    },
    "token": "YOUR_AUTH_TOKEN"
  }
```

**Error Response (Status: 422, for example):**
```json
{
  "errors": ["Error message 1", "Error message 2"]
}
```

---

### Sign Out

**Endpoint:**  
`DELETE /api/v1/users`

**Headers:**  
`Authorization: YOUR_AUTH_TOKEN`


**Successful Response (Status: 200):**
```json
  {
    "message": "Successfully logged out"
  }
```

**Error Response (Status: 422, for example):**
```json
  {
    "errors": ["Error message 1", "Error message 2"]
  }
```

---

### Get Average Temperature for Cities

**Endpoint:**  
`GET /api/v1/temperatures?cities=London,Paris,Tokyo`

**Headers:**  
`Authorization: YOUR_AUTH_TOKEN`


**Successful Response (Status: 200):**
```json
  {
    "average_temperature": 15.3,
    "cities": ["London", "Paris", "Tokyo"]
  }
```

**Error Response (Status: 422, for example):**
```json
  {
    "errors": ["Error message 1", "Error message 2"]
  }
```
