require_relative("../db/sql_runner.rb")
require_relative("./patient.rb")
require_relative("./condition.rb")

class Physio

  attr_reader :id
  attr_accessor :physio_name, :member_id

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @physio_name = options['physio_name']
  end

  def save()
      @id = SqlRunner.run("INSERT INTO physio (physio_name) VALUES ($1) RETURNING id;", [@physio_name])[0]['id'].to_i()
    end
  end

  def self.all()
    return SqlRunner.run("SELECT * FROM physios;").map() { |physio| Physio.new(physio) }
  end

  def self.all_ascending_id()
    return SqlRunner.run("SELECT * FROM physios ORDER BY id ASC;").map() { |physio| Physio.new( physio) }
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM physios;")
  end

  def update()
      SqlRunner.run("UPDATE physios SET (physio_name) = ($1) WHERE id = $2;", [@physio_name, @id])
  end

  def delete()
    SqlRunner.run("DELETE FROM physios where id = $1;", [@id])
  end

  # def add_lesson(lesson)
  #   if (lesson.capacity > lesson.physios.count)
  #     unless ((lesson.peak == true) && (self.premium == false))
  #       member_lesson = PhysioLesson.new('member_id' => self.id, 'lesson_id' => lesson.id)
  #       return member_lesson
  #     else
  #       return "This member cannot attend Peak hours lessons without Premium physioship."
  #     end
  #   else
  #     return "This lesson is already full to capacity."
  #   end
  # end

  def self.find(id)
    result = (SqlRunner.run("SELECT * FROM physios WHERE id = $1;", [id]).first())
    return Physio.new(result) if (result != nil)
  end

  # def lessons()
  #   return SqlRunner.run("SELECT lessons.* FROM physios_lessons INNER JOIN lessons ON physios_lessons.lesson_id = lessons.id WHERE physios_lessons.member_id = $1;", [@id]).uniq().map() { |lesson| Lesson.new(lesson) }
  # end
  #
  # def lesson_ids()
  #   return SqlRunner.run("SELECT lessons.id FROM physios_lessons INNER JOIN lessons ON physios_lessons.lesson_id = lessons.id WHERE physios_lessons.member_id = $1;", [@id]).uniq().map() { |lesson| lesson["id"].to_i() }
  # end

end
