Fusion Tables adapter for Sequel
================================

Experimental adapter to use [Fusion Tables](http://www.google.com/fusiontables/public/tour/index.html)
in [Sequel](http://sequel.rubyforge.org).

Usage
-----

    require "sequel"

    db = Sequel.connect("fusiontables:///")

    # In Fusion, table IDs are numbers.
    table = db[579353]

    puts table.select("Country", "Name").where("Active Reactors" => 0).all

    # {"Country"=>"BELGIUM", "Name"=>"BR"}
    # {"Country"=>"CANADA", "Name"=>"DOUGLAS POINT"}
    # {"Country"=>"CANADA", "Name"=>"NPD"}
    # {"Country"=>"CHINA", "Name"=>"LINGAO"}
    # ...

Installation
------------

    $ gem install sequel-fusiontables

Known issues
------------

I just started experimenting with this so there are a few features missing:

* `CREATE TABLE`, `INSERT`, `UPDATE`, `DELETE` aren't implemented yet. Soon though.
* Typecasting.
