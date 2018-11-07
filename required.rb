require_relative 'question'
require_relative 'user'
require_relative 'reply'
require_relative 'question_like'
require_relative 'question_follow'
require_relative 'model_base'
require 'active_support/inflector'
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
