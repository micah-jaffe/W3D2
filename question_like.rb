require_relative 'required'

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
    
    data.map { |d| QuestionLike.new(d) }
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
    
    QuestionLike.new(data.first)
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
    
    QuestionLike.new(data.first)
  end
  
  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        questions
      JOIN 
        question_likes
      ON questions.id = question_likes.question_id
      JOIN 
        users
      ON users.id = question_likes.user_id
      WHERE
        questions.id = ?
    SQL
    return nil unless data.length > 0
    
    data.map { |d| User.new(d) }
  end
  
  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(question_likes.id)
      FROM
        questions
      JOIN 
        question_likes
      ON questions.id = question_likes.question_id
      JOIN 
        users
      ON users.id = question_likes.user_id
      WHERE
        questions.id = ?
    SQL
    return nil unless data.length > 0
    
    data.first.values.first
  end
  
  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN 
        question_likes
      ON questions.id = question_likes.question_id
      JOIN 
        users
      ON users.id = question_likes.user_id
      WHERE
        users.id = ?
    SQL
    return nil unless data.length > 0
    
    data.map { |d| Question.new(d) }
  end
  
  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      LEFT JOIN 
        question_likes
      ON questions.id = question_likes.question_id
      LEFT JOIN 
        users
      ON users.id = question_likes.user_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.id) DESC
      LIMIT ?
    SQL
    return nil unless data.length > 0
    
    data.map { |d| Question.new(d) }
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end