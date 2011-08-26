require "cutest"
require "sequel"

$LOAD_PATH.unshift(File.expand_path("../../../lib", File.dirname(__FILE__)))

setup do
  Sequel.connect("fusiontables:///")[1310767]
end

test "simple SELECT" do |db|
  ds = db.select("Name", "Order").all

  assert_equal ds[0]["Name"], "rake"
  assert_equal ds[0]["Order"], "1"

  assert_equal ds[1]["Name"], "rack"
  assert_equal ds[1]["Order"], "2"
end

test "simple WHERE" do |db|
  sql = db.select("Name", "Order").where("Name" => "rake").sql

  assert_equal sql, "SELECT 'Name', 'Order' FROM 1310767 WHERE 'Name' = 'rake'"
end

test "complex WHERE" do |db|
  sql = db.select("Name", "Order").where("Name" => "rake", "Order" => "1").sql

  assert_equal sql, "SELECT 'Name', 'Order' FROM 1310767 WHERE 'Name' = 'rake' AND 'Order' = '1'"
end

test "Fusion Tables errors" do |db|
  assert_raise(Sequel::DatabaseError) do
    db.select("Foo").all
  end
end

test "non-SELECT raises errors" do |db|
  assert_raise(Sequel::DatabaseError) do
    db.insert(foo: "bar")
  end
end
