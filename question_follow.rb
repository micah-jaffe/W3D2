require_relative 'required'

class QuestionFollow < ModelBase
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
  
  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        questions
      JOIN 
        question_follows
      ON questions.id = question_follows.question_id
      JOIN 
        users
      ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL
    return nil unless data.length > 0
    
    data.map { |d| User.new(d) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN 
        question_follows
      ON questions.id = question_follows.question_id
      JOIN 
        users
      ON users.id = question_follows.user_id
      WHERE
        user_id = ?
    SQL
    return nil unless data.length > 0
    
    data.map { |d| Question.new(d) }
  end
  
  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN 
        question_follows
      ON questions.id = question_follows.question_id
      JOIN 
        users
      ON users.id = question_follows.user_id
      GROUP BY 
        questions.id
      ORDER BY
        COUNT(users.id) DESC
      LIMIT ?
    SQL
    return nil unless data.length > 0
    
    data.map { |d| Question.new(d) }
  end
  
  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end