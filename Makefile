postgres:
	docker run --name Bank_of_Enugu --network boe_network -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -p 5434:5432 -d postgres:13-alpine
	
postgresD:
	docker run --name bankofenugu --network boe_network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@boeDB:5432/bank_of_enugu?sslmode=disable" bankofenugu:latest

createdb:
	docker exec -it Bank_of_Enugu createdb --username=root --owner=root bank_of_enugu
	
initdb:
	migrate create -ext sql -dir ./db/migration -seq initdb

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5434/bank_of_enugu?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5434/bank_of_enugu?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5434/bank_of_enugu?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5434/bank_of_enugu?sslmode=disable" -verbose down 1

initsqlc:
	sqlc init

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/oddinnovate/bank_of_enugu/db/sqlc Store

.PHONY: postgres createdb dropdb initdb migrateup migratedown test server mock