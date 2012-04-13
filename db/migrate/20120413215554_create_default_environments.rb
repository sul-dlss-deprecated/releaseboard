class CreateDefaultEnvironments < ActiveRecord::Migration
  def up
    say_with_time "Creating default environments" do
      say 'development'
      dev  = Environment.find_or_create_by_name('development')
      say 'test'
      test = Environment.find_or_create_by_name('test')        { |e| e.update_attribute :previous, dev  }
      say 'production'
      prod = Environment.find_or_create_by_name('production')  { |e| e.update_attribute :previous, test }
    end
  end
end
