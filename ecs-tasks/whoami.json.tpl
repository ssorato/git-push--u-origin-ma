[
  {
    "name": "whoami",
    "image": "containous/whoami:v1.5.0",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${loggroup}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "whoami"
      }
    }
  }
]