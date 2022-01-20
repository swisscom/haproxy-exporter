package main

import (
	"fmt"
	"github.com/alexflint/go-arg"
	"github.com/sirupsen/logrus"
	"github.com/swisscom/haproxy-exporter/core"
	"net/url"
	"time"
)

var args struct {
	Url string `arg:"-u,--url"`
}

func main() {
	logger := logrus.New()
	arg.MustParse(&args)

	mUrl, err := url.Parse(args.Url)
	if err != nil {
		logger.Fatalf("unable to parse url: %v", err)
	}
	str, err := core.UnixToString(mUrl, 10*time.Second)
	if err != nil {
		logger.Fatalf("unable to get unix sock data")
	}

	fmt.Printf("%s\n", str)
}
