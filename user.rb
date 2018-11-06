require_relative 'required'

class User
  attr_accessor :fname, :lname
  attr_reader :id
  
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
  
  def authored_questions
    Question.find_by_author_id(self.id)
  end
  
  def authored_replies
    Reply.find_by_user_id(self.id)
  end
  
  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        1.0 * COUNT(question_likes.id) / COUNT(DISTINCT questions.id) AS avg_karma
      FROM
        users
      LEFT JOIN 
        questions
      ON users.id = questions.author_id
      LEFT JOIN 
        question_likes
      ON questions.id = question_likes.question_id
      WHERE
        users.id = ?
    SQL
    return nil unless data.length > 0
    
    data.first.values.first
  end
end