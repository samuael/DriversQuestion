package main

import (
	"io"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", func(res http.ResponseWriter, req *http.Request) {
		file, er := os.Open("/home/samuael/eclipse-workspace/LinkedStack/src/main/Main.java")
		defer file.Close()
		if er != nil {
			return
		}
		io.Copy(res, file)
	})
	http.ListenAndServe(":8080", nil)
}
