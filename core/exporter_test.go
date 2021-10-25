package core

import (
	"fmt"
	"os"
	"testing"
	"time"
)

func TestExporter_ParseCSV(t *testing.T) {
	e, err := NewExporter("unix:/", time.Second, nil, nil)
	if err != nil {
		t.Fatalf("cannot create exporter: %v", err)
	}
	f, err := os.Open("./test/data/stats.csv")
	if err != nil {
		t.Fatal("unable to open test input data")
	}
	defer f.Close()
	success := e.ParseCSV(f)

	if !success {
		t.Fatal("parseCSV return success=false")
	}

	if e.prometheusBuffer.Len() == 0 {
		t.Fatal("prometheusBuffer is empty")
	}
	fmt.Printf("%s\n", string(e.prometheusBuffer.Bytes()))
}
