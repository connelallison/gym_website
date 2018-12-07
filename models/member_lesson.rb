require_relative("../db/sql_runner")
require_relative("./member.rb")
require_relative("./lesson.rb")

class MemberLesson

  attr_reader :id
  attr_accessor :member_id, :lesson_id,

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @member_id = options['member_id'].to_i()
    @lesson_id = options['lesson_id'].to_i()
  end

  def save()
    @id = SqlRunner.run("INSERT INTO members_lessons (member_id, lesson_id) VALUES ($1, $2) RETURNING id;", [@member_id, @lesson_id])[0]['id'].to_i()
  end

  def self.all()
    return SqlRunner.run("SELECT * FROM members_lessons;").map() { |member_lesson| MemberLesson.new( member_lesson ) }
  end

  def self.all_ascending_id()
    return SqlRunner.run("SELECT * FROM members_lessons ORDER BY id ASC;").map() { |member_lesson| MemberLesson.new( member_lesson ) }
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM members_lessons;")
  end

  def update()
    SqlRunner.run("UPDATE members_lessons SET (member_id, lesson_id) = ($1, $2) WHERE id = $3;", [@member_id, @lesson_id, @id])
  end

  def delete()
    SqlRunner.run("DELETE FROM members_lessons where id = $1;", [@id])
  end

  def self.find(id)
    result = (SqlRunner.run("SELECT * FROM members_lessons WHERE id = $1;", [id]).first())
    return MemberLesson.new(result) if (result != nil)
  end

  def lesson()
    return Lesson.new(SqlRunner.run("SELECT * FROM lessons WHERE id = $1;", [@lesson_id])[0])
  end

  def member()
    return Member.new(SqlRunner.run("SELECT * FROM members WHERE id = $1;", [@member_id])[0])
  end

  def member_and_lesson()
    lesson = SqlRunner.run("SELECT * FROM lessons WHERE id = $1;", [@lesson_id])[0]
    member = SqlRunner.run("SELECT * FROM members WHERE id = $1;", [@member_id])[0]
    return [lesson, member]
  end

end
