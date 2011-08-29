require "cutest"
require "sequel"

$LOAD_PATH.unshift(File.expand_path("../../../lib", File.dirname(__FILE__)))

require "ft"

class FusionTables::Connection
  def authenticate(email, password)
    $credentials = {:email => email, :password => password}
  end

  def query(sql)
    $queries << sql
    [["rowid"], [$queries.size]]
  end
end

setup do
  $queries = []

  [Sequel.connect("fusiontables:///")[1310767], $queries]
end

test "INSERT" do |db, queries|
  assert_equal queries.size, 0

  id = db.insert(foo: "bar")

  assert_equal queries.last, "INSERT INTO 1310767 ('foo') VALUES ('bar')"
  assert_equal id, 1

  id = db.insert("Foo" => "bar's")

  assert_equal queries.last, "INSERT INTO 1310767 ('Foo') VALUES ('bar\\'s')"
  assert_equal id, 2
end

test "UPDATE" do |db, queries|
  db.filter(rowid: "1").update(foo: "bar")

  assert_equal queries.last, "UPDATE 1310767 SET 'foo' = 'bar' WHERE 'rowid' = '1'"
end

test "DELETE" do |db, queries|
  db.filter(rowid: "1").delete

  assert_equal queries.last, "DELETE FROM 1310767 WHERE 'rowid' = '1'"
end

test "authentication" do
  Sequel.connect("fusiontables://foo%40bar.com:p4wned@fusiontables")[1310767].all

  assert_equal $credentials[:email], "foo@bar.com"
  assert_equal $credentials[:password], "p4wned"
end

test "CREATE TABLE" do |db, queries|
  conn = Sequel.connect("fusiontables:///")

  conn << "CREATE TABLE foo"

  assert queries.include?("CREATE TABLE foo")
end
