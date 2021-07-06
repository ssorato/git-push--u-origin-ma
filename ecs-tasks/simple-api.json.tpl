[
  {
    "name": "simpleapi",
    "image": "emondek/simple-api:v1.0.0",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${loggroup}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "sampleapi"
      }
    }
  }
]