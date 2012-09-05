require 'spec_helper'
describe ReleasesController do
  describe "post" do
    context "new-style" do
      before(:each) do
      end
      it "should work with the new-style" do
        post :create, :project_id => 'project_name',
                      :environment => {
                        :deployment_host => 'dev.example.com',
                        :destination     => '/dev/null'
                      },
                      :release => {
                         :version => '0.0.1'
                      }

        Project.find_by_name('project_name').releases.length.should == 1

      end
    end

    context "old-style" do
      it "should work with the old-style" do
        prod = Environment.find_by_name('production')

        post :create, :project_id => 'old_style_project',
                      :environment => 'production',
                      :release => {
                        :version => '0.0.2'
                      }

        Release.last.environment.should == prod
      end
    end
  end
end
