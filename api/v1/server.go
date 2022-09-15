package api

import (
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
	db "github.com/oddinnovate/bank_of_enugu/db/sqlc"
)

type Server struct {
	store  db.Store
	router *gin.Engine
}

func NewServer(store db.Store) *Server {
	server := &Server{store: store}
	router := gin.Default()

	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("currency", validCurrency)
	}

	// Create User Route
	router.POST("/api/v1/users", server.createUser)

	// Accounts Route
	router.POST("api/v1/accounts", server.createAccount)
	router.GET("api/v1/accounts/:id", server.getAccount)
	router.GET("api/v1/accounts", server.listAccounts)

	// Transfers Route
	router.POST("api/v1/transfers", server.createTransfer)

	server.router = router
	return server
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}
