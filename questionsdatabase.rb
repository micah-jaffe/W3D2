require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  attr_accessor :title, :body, :author_id
  
  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
    SQL
    return nil unless data.length > 0
    
    data.map { |d| Question.new(d) }
  end
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless data.length > 0
    
    Question.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
end

class User
  attr_accessor :fname, :lname
  
  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
    SQL
    return nil unless data.length > 0
    
    data.map { |d| User.new(d) }
  end
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless data.length > 0
    
    User.new(data.first)
  end
  
  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil unless data.length > 0
    
    User.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
end

class QuestionFollow
  attr_accessor :user_id, :question_id
  
  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_id = ?
    SQL
    return nil unless data.length > 0
    
    QuestionFollow.new(data.first)
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        user_id = ?
    SQL
    return nil unless data.length > 0
    
    QuestionFollow.new(data.first)
  end
  
  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end

class Reply
  attr_accessor :question_id, :parent_id, :user_id, :body
  
  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
    SQL
    return nil unless data.length > 0
    
    data.map { |d| Question.new(d) }
  end
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless data.length > 0
    
    QuestionFollow.new(data.first)
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil unless data.length > 0
    
    QuestionFollow.new(data.first)
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    return nil unless data.length > 0
    
    QuestionFollow.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end
  
end

class QuestionLike
  attr_accessor :user_id, :question_id
  
  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        question_likes
    SQL
    return nil unless data.length > 0
    
    data.map { |d| Question.new(d) }
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL
    return nil unless data.length > 0
    
    QuestionFollow.new(data.first)
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    return nil unless data.length > 0
    
    QuestionFollow.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end