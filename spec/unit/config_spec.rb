require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade do

  let( :rcau ){ described_class.new }
  let( :config ){ rcau.send :config }


  context "configuration of a newly created instance" do 

    context "default values" do 
      it "for treshold" do
        expect( config.treshhold ).to be_nil
      end
      it "for callback" do
        expect( config.on_upgrade ).to be_nil
      end
    end # context "default values"
    
    context "not all needed values provided" do 
      before do
        rcau.configure do |c|
          c.heroku_api_key = "a88a8aa8-a8a8-4b57-a8aa-8888aa8888aa"
          c.redis_cloud_id = "4ceaf719-8a4b-4b8b-8dcf-7852fa79ec44"
        end
      end

      it "will raise an error when potential_upgrade! is invoked" do
        expect{ rcau.potential_upgrade! }.to raise_error( RedisCloudAutoUpgrade.IllegalConfiguration, /use conf\.treshhold =/ )
      end
    end # context "not all needed values provided"
  end # context "configuration of a newly created instance"
end

