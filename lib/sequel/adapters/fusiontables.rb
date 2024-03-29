require "sequel"
require "ft"

module Sequel
  module FusionTables
    class Database < ::Sequel::Database
      set_adapter_scheme :fusiontables

      def dataset(opts = nil)
        FusionTables::Dataset.new(self, opts)
      end

      def execute(sql, opts = {}, &block)
        _execute(:select, sql, opts, &block)
      end

      def execute_insert(sql, opts = {})
        _execute(:insert, sql, opts)
      end

      def execute_dui(sql, opts = {})
        _execute(:update, sql, opts)
      end

      def self.uri_to_options(uri)
        {:email => uri.user, :password => uri.password}
      end

      def connect(server)
        connection = ::FusionTables::Connection.new

        if opts[:email]
          connection.authenticate(opts[:email], opts[:password])
        end

        connection
      end

      def identifier_input_method_default
        nil
      end

    protected

      def _execute(type, sql, opts, &block)
        begin
          synchronize do |conn|
            log_args = opts[:arguments]
            args = opts.fetch(:arguments, [])
            case type
            when :select
              log_yield(sql, log_args) { yield(conn.query(sql)) }
            when :insert
              result = log_yield(sql, log_args) { conn.query(sql) }
              result[1][0]
            when :update
              result = log_yield(sql, log_args) { conn.query(sql) }
            end
          end
        rescue ::FusionTables::Error => e
          raise_error(e)
        end
      end
    end

    class Dataset < ::Sequel::Dataset
      def complex_expression_sql(op, args)
        case op
        when *TWO_ARITY_OPERATORS
          "#{literal(args.at(0))} #{op} #{literal(args.at(1))}"
        when *N_ARITY_OPERATORS
          "#{args.collect{|a| literal(a)}.join(" #{op} ")}"
        else
          super
        end
      end

      def quoted_identifier(name)
        ::FusionTables::Connection.quote(name)
      end

      def literal_string(string)
        ::FusionTables::Connection.quote(string)
      end

      def fetch_rows(sql)
        execute(sql) do |result|
          @columns = result.shift

          result.each do |values|
            row = {}

            @columns.each_with_index do |col, i|
              row[col] = values[i]
            end

            yield(row)
          end
        end
      end
    end
  end
end
