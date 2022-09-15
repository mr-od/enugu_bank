package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/oddinnovate/bank_of_enugu/api/v1"
	db "github.com/oddinnovate/bank_of_enugu/db/sqlc"
	"github.com/oddinnovate/bank_of_enugu/util"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("Loading config file failed:", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("Cannot connect to DB:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("Cannot start server:", err)
	}
}
