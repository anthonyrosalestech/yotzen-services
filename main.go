package main

import (
	"embed"
	"encoding/json"
	"fmt"
	"io/fs"
	"net/http"
)

// Le decimos a Go que empaquete tu build de React dentro del ejecutable
//go:embed dist
var frontendFiles embed.FS

type RespuestaDemo struct {
	Status  string `json:"status"`
	Mensaje string `json:"mensaje"`
}

func main() {
	// Extraemos la estructura de archivos de React
	publicFS, err := fs.Sub(frontendFiles, "dist")
	if err != nil {
		fmt.Println("Error al cargar los archivos estáticos de React:", err)
		return
	}
	frontendHandler := http.FileServer(http.FS(publicFS))

	// --- TUS RUTAS BACKEND VAN AQUÍ ---
	http.HandleFunc("/api/salud", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(RespuestaDemo{
			Status:  "OK",
			Mensaje: "Backend en Go respondiendo correctamente en Dokploy",
		})
	})

	// --- SERVIR EL FRONTEND ---
	http.Handle("/", frontendHandler)

	// Puerto en el que escuchará el contenedor
	puerto := ":8080"
	fmt.Println("Servidor integrado ejecutándose en el puerto", puerto)
	http.ListenAndServe(puerto, nil)
}
