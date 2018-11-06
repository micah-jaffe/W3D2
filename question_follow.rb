require_relative 'required'

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