package acceptance_test

import (
	"fmt"
	"io"
	"os"
	"os/exec"

	"github.com/cloudfoundry-incubator/cf-test-helpers/cf"
	"github.com/cloudfoundry-incubator/cf-test-helpers/generator"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/onsi/gomega/gbytes"
	. "github.com/onsi/gomega/gexec"
)

const (
	BYTE     = int64(1)
	KILOBYTE = 1024 * BYTE
	MEGABYTE = 1024 * KILOBYTE
	GIGABYTE = 1024 * MEGABYTE
	TERABYTE = 1024 * GIGABYTE
)

var _ = Describe("CF SSH", func() {
	It("should be enabled", func() {
		appName := generator.PrefixedRandomName("CATS-APP-")
		Expect(cf.Cf(
			"push", appName,
			"-b", config.StaticFileBuildpackName,
			"-p", "../../example-apps/static-app",
			"-d", config.AppsDomain,
			"-i", "1",
			"-m", "64M",
		).Wait(CF_PUSH_TIMEOUT)).To(Exit(0))
		cfSSH := cf.Cf("ssh", appName, "-c", "uptime").Wait(DEFAULT_TIMEOUT)
		Expect(cfSSH).To(Exit(0))
		Expect(cfSSH).To(Say("load average:"))
	})

	It("allows uploading a large payload via standard ssh client", func() {
		// FIXME: Increase to 10GB once the following issue is solved:
		// https://github.com/cloudfoundry/cli/issues/1098
		const payloadSize = 1*GIGABYTE + 900*MEGABYTE
		timeout := 600
		appName := generator.PrefixedRandomName("CATS-APP-")
		Expect(cf.Cf(
			"push", appName,
			"-b", config.StaticFileBuildpackName,
			"-p", "../../example-apps/static-app",
			"-d", config.AppsDomain,
			"-i", "1",
			"-m", "64M",
		).Wait(CF_PUSH_TIMEOUT)).To(Exit(0))

		cfSSHCommand := exec.Command("/usr/bin/cf", "ssh", appName, "-c", "cat > /dev/null")
		sshStdin, err := cfSSHCommand.StdinPipe()
		Expect(err).NotTo(HaveOccurred())

		file, err := os.Open("/dev/zero")
		Expect(err).NotTo(HaveOccurred())
		defer file.Close()

		session, err := Start(cfSSHCommand, GinkgoWriter, GinkgoWriter)
		Expect(err).NotTo(HaveOccurred())

		copied, err := io.CopyN(sshStdin, file, payloadSize)
		Expect(err).NotTo(HaveOccurred())
		fmt.Fprintf(GinkgoWriter, "Successfully copied %d bytes", copied)
		sshStdin.Close()

		Expect(copied).To(Equal(payloadSize))
		session.Wait(timeout)
		Expect(session).To(Exit(0))
	})
})
