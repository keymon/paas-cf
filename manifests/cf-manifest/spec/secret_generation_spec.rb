require 'tempfile'

RSpec.describe "secret generation" do
  describe "generate-cf-secrets" do
    let(:script) {
      File.expand_path("../../scripts/generate-cf-secrets.sh", __FILE__)
    }

    specify "it should produce lint-free YAML" do
      skip "No mkpasswd(1) on Mac OS X" if Gem::Platform.local.os == 'darwin'

      yaml, error, status = Open3.capture3(script)
      expect(status).to be_success, "script exited #{status.exitstatus}, stderr:\n#{error}"
      expect(yaml).to_not be_empty

      tempfile = Tempfile.new('yamllint')
      begin
        tempfile.write(yaml)
        tempfile.close

        output, status = Open3.capture2e(
          [
            'yamllint',
            '-c', File.expand_path("../../../../yamllint.yml", __FILE__),
            tempfile.path,
          ].join(' ')
        )
      ensure
        tempfile.unlink
      end

      expect(status).to be_success, "yamllint exited #{status.exitstatus}, output:\n#{output}"
      expect(output).to be_empty
    end
  end
end