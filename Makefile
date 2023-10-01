all:
	docker-compose up --build --no-deps --remove-orphans -d

test: all
	docker-compose run test-client

clean:
	docker-compose down --remove-orphans -v

dapr:
	dapr run -f .
	dapr invoke --verb POST --app-id nodeapp --method neworder --data "{\"data\": { \"orderId\": \"$$(echo $$RANDOM)\" } }"

-include include.mk
