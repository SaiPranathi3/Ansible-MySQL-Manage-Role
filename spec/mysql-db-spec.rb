require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision('playbooks/mysql-manage.yml', {
      db_name:         "test_db",
      new_mysql_user:  "test_db_owner",
      new_mysql_pass:  "db_password"
    })
  end
end

describe command("mysql -utest_db_owner -pdb_password test_db -e \"SHOW CREATE DATABASE test_db\"") do
  its(:stdout) { should match /CREATE DATABASE `|"test_db`|"/ }

  its(:exit_status) { should eq 0 }
end

describe command("mysql -utest_db_owner -pdb_password mysql") do
  its(:stderr) { should match /Access denied for user 'test_db_owner'@'localhost' to database 'mysql'/ }

  its(:exit_status) { should_not eq 0 }
end
