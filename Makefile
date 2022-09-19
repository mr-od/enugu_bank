DB_URL=postgresql://root:secret@localhost:5434/bank_of_enugu?sslmode=disable

network:
	docker network create boe_network

postgres:
	docker run --name postgres13 --network boe_network -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -p 5434:5432 -d postgres:13-alpine

createdb:
	docker exec -it postgres13 createdb --username=root --owner=root bank_of_enugu
	
initdb:
	migrate create -ext sql -dir ./db/migration -seq initdb

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

initsqlc:
	sqlc init

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

db_docs:
	dbdocs build db/doc/db.dbml

db_schema:
	dbml2sql --postgres -o db/doc/schema.sql db/doc/db.dbml

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/oddinnovate/bank_of_enugu/db/sqlc Store

.PHONY: postgres createdb dropdb initdb migrateup migratedown test server mock db_docs db_schema network