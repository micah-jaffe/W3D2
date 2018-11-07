require_relative 'required'

class User < ModelBase
  attr_accessor :fname, :lname
  attr_reader :id
  
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
  
  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO
          users (fname, lname)
        VALUES
          (?, ?)
      SQL
      @id = SQLite3::Database.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
      @id
    end
  end
end