require 'spec_helper'

describe "the project page" do

  before(:all) do
    project_a = Project.new :name => 'project_a'
    env_dev = Environment.new :deployment_host => 'dev.example.com'
    env_test = Environment.new :deployment_host => 'test.example.com'
    env_prod = Environment.new :deployment_host => 'example.com'
    release_001 = Release.new :version => '0.0.1'
    release_001.environment = env_dev
    release_001.project = project_a
    release_001.save

    release_002 = Release.new :version => '0.0.2'
    release_002.environment = env_dev
    release_002.project = project_a
    release_002.save

    release_010 = Release.new :version => '0.1.0'
    release_010.environment = env_dev
    release_010.project = project_a
    release_010.save

    release_100 = Release.new :version => '1.0.0'
    release_100.environment = env_dev
    release_100.project = project_a
    release_100.save

    release_001 = Release.new :version => '0.0.1'
    release_001.environment = env_test
    release_001.project = project_a
    release_001.save

    release_002 = Release.new :version => '0.0.2'
    release_002.environment = env_test
    release_002.project = project_a
    release_002.save

    release_010 = Release.new :version => '0.1.0'
    release_010.environment = env_test
    release_010.project = project_a
    release_010.save

    release_001 = Release.new :version => '0.0.1'
    release_001.environment = env_prod
    release_001.project = project_a
    release_001.save
  end

  it "should" do
    @project = ProjectDecorator.find_by_name('project_a')
  end

  it "should have projects" do
    visit '/'
    page.should have_selector '.project'
    page.should have_content 'project_a'
  end

  it "should have a project display" do
    visit '/projects/project_a'
    page.should have_content "project_a 1.0.0"
    page.should have_content "dev.example.com"
    page.should have_content "test.example.com"
    page.should have_content "example.com"
  end

  it "should have a release display" do
    visit "/projects/project_a/releases/0.0.1"
    page.should have_content "released to dev.example.com"
    page.should have_content "released to test.example.com"
    page.should have_content "released to example.com"
  end
end
