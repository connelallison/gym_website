require_relative("../db/sql_runner.rb")
require_relative("./physio.rb")
require_relative("./condition.rb")

class Patient

  attr_reader :id
  attr_accessor :patient_name, :member_id

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @patient_name = options['patient_name']
    @member_id = option['member_id'].to_i() if options['member_id']
  end

  def save()
    if (@member_id)
      @id = SqlRunner.run("INSERT INTO patient (patient_name, member_id) VALUES ($1, $2) RETURNING id;", [@patient_name, @member_id])[0]['id'].to_i()
    else
      @id = SqlRunner.run("INSERT INTO patient (patient_name) VALUES ($1) RETURNING id;", [@patient_name])[0]['id'].to_i()
    end
  end

  def self.all()
    return SqlRunner.run("SELECT * FROM patients;").map() { |patient| Patient.new(patient) }
  end

  def self.all_ascending_id()
    return SqlRunner.run("SELECT * FROM patients ORDER BY id ASC;").map() { |patient| Patient.new( patient) }
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM patients;")
  end

  def update()
    if (@member_id)
      SqlRunner.run("UPDATE patients SET (patient_name, member_id) = ($1, $2) WHERE id = $3;", [@patient_name, @member_id, @id])
    else
      SqlRunner.run("UPDATE patients SET (patient_name) = ($1) WHERE id = $2;", [@patient_name, @id])
    end
  end

  def delete()
    SqlRunner.run("DELETE FROM patients where id = $1;", [@id])
  end

  # def add_lesson(lesson)
  #   if (lesson.capacity > lesson.patients.count)
  #     unless ((lesson.peak == true) && (self.premium == false))
  #       member_lesson = PatientLesson.new('member_id' => self.id, 'lesson_id' => lesson.id)
  #       return member_lesson
  #     else
  #       return "This member cannot attend Peak hours lessons without Premium patientship."
  #     end
  #   else
  #     return "This lesson is already full to capacity."
  #   end
  # end

  def self.find(id)
    result = (SqlRunner.run("SELECT * FROM patients WHERE id = $1;", [id]).first())
    return Patient.new(result) if (result != nil)
  end

  # def lessons()
  #   return SqlRunner.run("SELECT lessons.* FROM patients_lessons INNER JOIN lessons ON patients_lessons.lesson_id = lessons.id WHERE patients_lessons.member_id = $1;", [@id]).uniq().map() { |lesson| Lesson.new(lesson) }
  # end
  #
  # def lesson_ids()
  #   return SqlRunner.run("SELECT lessons.id FROM patients_lessons INNER JOIN lessons ON patients_lessons.lesson_id = lessons.id WHERE patients_lessons.member_id = $1;", [@id]).uniq().map() { |lesson| lesson["id"].to_i() }
  # end

end
