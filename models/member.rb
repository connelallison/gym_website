require_relative("../db/sql_runner.rb")
require_relative("./lesson.rb")
require_relative("./member_lesson.rb")

class Member

  attr_reader :id
  attr_accessor :name, :premium

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @name = options['name']
    @premium = options['premium']
    @premium = true if (options['premium'] == "t")
    @premium = false if (options['premium'] == "f")
  end

  def save()
    @id = SqlRunner.run("INSERT INTO members (name, premium) VALUES ($1, $2) RETURNING id;", [@name, @premium])[0]['id'].to_i()
  end

  def self.all()
    return SqlRunner.run("SELECT * FROM members;").map() { |member| Member.new(member) }
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM members;")
  end

  def update()
    SqlRunner.run("UPDATE members SET (name, premium) = ($1, $2) WHERE id = $3;", [@name, @premium, @id])
  end

  def delete()
    SqlRunner.run("DELETE FROM members where id = $1;", [@id])
  end

  def self.find(id)
    result = (SqlRunner.run("SELECT * FROM members WHERE id = $1;", [id]).first())
    return Member.new(result) if (result != nil)
  end

  def lessons()
    return SqlRunner.run("SELECT lessons.* FROM members_lessons INNER JOIN lessons ON members_lessons.lesson_id = lessons.id WHERE members_lessons.member_id = $1;", [@id]).uniq().map() { |lesson| Lesson.new(lesson) }
  end

end
