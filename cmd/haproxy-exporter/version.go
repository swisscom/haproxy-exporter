package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

var (
	gitVersion = "unknown"
	gitHash    = "HEAD"
)

func init() {
	RootCmd.AddCommand(versionCmd)
}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print the version number",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("haproxy-exporter %s (%s)\n", gitVersion, gitHash)
	},
}
