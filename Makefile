postgres:
	docker run --name Bank_of_Enugu -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -p 5434:5432 -d postgres:13-
	
createdb:
	docker exec -it Bank_of_Enugu createdb --username=root --owner=root bank_of_enugu
	
initdb:
	migrate create -ext sql -dir ./db/migration -seq init_schema

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
	mockgen -package mockdb -destination db/mock/store.go github.com/oddinnovate/Bank_of_Enugu/db/sqlc Store

.PHONY: postgres createdb dropdb initdb migrateup migratedown test server mock