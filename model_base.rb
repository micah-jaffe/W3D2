require_relative 'required'

class ModelBase
  
  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{ActiveSupport::Inflector.tableize(self.name)}
    SQL
    return nil unless data.length > 0
    
    data.map { |d| self.new(d) }
  end
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{ActiveSupport::Inflector.tableize(self.name)}
      WHERE
        id = ?
    SQL
    return nil unless data.length > 0
    
    self.new(data.first)
  end
  
  def self.find_by(options)
    where_clause = ""
    options.each do |key, val|
      where_clause << " AND #{key} = '#{val}'"
    end
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{ActiveSupport::Inflector.tableize(self.name)}
      WHERE 
        1 = 1 #{where_clause}
    SQL
    return nil unless data.length > 0
    
    data.map { |d| self.new(d) }
  end
  
  def self.where(where_clause)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{ActiveSupport::Inflector.tableize(self.name)}
      WHERE 
        #{where_clause}
    SQL
    return nil unless data.length > 0
    
    data.map { |d| self.new(d) }
  end
  
  def initialize
  end
  
end