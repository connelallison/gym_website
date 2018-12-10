require_relative("../db/sql_runner.rb")
require_relative("./patient.rb")
require_relative("./condition.rb")

class Condition

  attr_reader :id
  attr_accessor :patient_id, :physio_id, :type, :diagnosed, :resolved

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @patient_id = options['patient_id'].to_i()
    @physio_id = options['physio_id'].to_i()
    @type = options['type']
    @diagnosed = options['diagnosed']
    @resolved = options['resolved']
    @resolved = true if (options['resolved'] == "t" || options['resolved'] == "true" )
    @resolved = false if (options['resolved'] == "f" || options['resolved'] == "false" )
  end

  def save()
      @id = SqlRunner.run("INSERT INTO conditions (patient_id, physio_id, type, diagnosed, resolved) VALUES ($1, $2, $3, $4, $5) RETURNING id;", [@patient_id, @physio_id, @type, @diagnosed, @resolved])[0]['id'].to_i()
  end

  def self.all()
    return SqlRunner.run("SELECT * FROM conditions;").map() { |condition| Condition.new(condition) }
  end

  def self.all_ascending_id()
    return SqlRunner.run("SELECT * FROM conditions ORDER BY id ASC;").map() { |conditions| Condition.new(conditions) }
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM conditions;")
  end

  def update()
      SqlRunner.run("UPDATE conditions SET (patient_id, physio_id, type, diagnosed, resolved) = ($1, $2, $3, $4, $5) WHERE id = $6;", [@patient_id, @physio_d, @type, @diagnosed, @resolved, @id])
  end

  def delete()
    SqlRunner.run("DELETE FROM conditions where id = $1;", [@id])
  end

  # def add_lesson(lesson)
  #   if (lesson.capacity > lesson.physios.count)
  #     unless ((lesson.peak == true) && (self.premium == false))
  #       member_lesson = ConditionLesson.new('member_id' => self.id, 'lesson_id' => lesson.id)
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
    return Condition.new(result) if (result != nil)
  end

  # def lessons()
  #   return SqlRunner.run("SELECT lessons.* FROM physios_lessons INNER JOIN lessons ON physios_lessons.lesson_id = lessons.id WHERE physios_lessons.member_id = $1;", [@id]).uniq().map() { |lesson| Lesson.new(lesson) }
  # end
  #
  # def lesson_ids()
  #   return SqlRunner.run("SELECT lessons.id FROM physios_lessons INNER JOIN lessons ON physios_lessons.lesson_id = lessons.id WHERE physios_lessons.member_id = $1;", [@id]).uniq().map() { |lesson| lesson["id"].to_i() }
  # end

end
