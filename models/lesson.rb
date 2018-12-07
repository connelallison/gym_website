require_relative('./member.rb')
require_relative('./member_lesson.rb')
require_relative('../db/sql_runner.rb')

class Lesson

attr_reader :id
attr_accessor :name, :capacity, :peak

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @name = options['name']
    @capacity = options['capacity'].to_i()
    @peak = options['peak']
    @peak = true if (options['peak'] == "t")
    @peak = false if (options['peak'] == "f")
  end

  def save()
    @id = SqlRunner.run("INSERT INTO lessons (name, capacity, peak) VALUES ($1, $2, $3) RETURNING id;", [@name, @capacity, @peak])[0]['id'].to_i()
  end

  def update()
    SqlRunner.run("UPDATE lessons SET (name, capacity, peak) = ($1, $2, $3) WHERE id = $4;", [@capacity, @peak, @name, @id])
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM lessons")
  end

  def delete()
    SqlRunner.run("DELETE FROM lessons WHERE id = $1", [@id])
  end

  def self.all()
    return SqlRunner.run("SELECT * FROM lessons;").map() { |lesson| Lesson.new( lesson ) }
  end

  def self.find(id)
    result = (SqlRunner.run("SELECT * FROM lessons WHERE id = $1;", [id]).first())
    return Lesson.new(result) if (result != nil)
  end

  def members()
    return SqlRunner.run("SELECT * FROM members WHERE lesson = $1;", [@name]).map() { |member| Member.new(member) }
  end

  def members()
    return SqlRunner.run("SELECT members.* FROM members_lessons INNER JOIN members ON members_lessons.member_id = members.id WHERE members_lessons.lesson_id = $1;", [@id]).uniq().map() { |member| Member.new(member) }
  end

end
