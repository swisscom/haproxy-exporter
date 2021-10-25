package main

import (
	log "github.com/sirupsen/logrus"
)

func main() {
	if err := RootCmd.Execute(); err != nil {
		log.Errorf("%v", err)
	}
}
