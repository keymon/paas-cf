
RSpec.describe "vm_types" do
  let(:vm_types) { cloud_config_with_defaults.fetch("vm_types") }

  describe "the router pool" do
    let(:pool) { vm_types.find { |p| p["name"] == "router" } }

    it "should use the correct elb instance" do
      expect(pool["cloud_properties"]["elbs"]).to match_array([
        terraform_fixture(:cf_router_elb_name),
      ])
    end
  end

  describe "the cell pool" do
    let(:pool) { vm_types.find { |p| p["name"] == "cell" } }

    it "should have a gp2 ephemeral disk of at least 100G" do
      ephemeral_disk = pool['cloud_properties']['ephemeral_disk']
      expect(ephemeral_disk).to be_a_kind_of(Hash)
      expect(ephemeral_disk).to include('size', 'type')
      expect(ephemeral_disk['size'].to_i).to be >= 102400
      expect(ephemeral_disk['type']).to eq('gp2')
    end
  end

  describe "ephemeral disk" do
    it "all VM type should have a ephemeral disk of at least 10GB" do
      vm_types.each do |pool|
        ephemeral_disk = pool['cloud_properties']['ephemeral_disk']
        expect(ephemeral_disk).to be_a_kind_of(Hash), "expected #{pool['name']} to have a ephemeral_disk definition"
        expect(ephemeral_disk).to include('size', 'type')
        expect(ephemeral_disk['size'].to_i).to be >= 10240
        expect(ephemeral_disk['type']).to eq('gp2')
      end
    end
  end
end
