require_relative("../db/sql_runner.rb")
require_relative("./patient.rb")
require_relative("./condition.rb")

class Condition

  attr_reader :id
  attr_accessor :patient_id, :physio_id, :type, :diagnosed, :resolved, :resolved_date, :notes

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @patient_id = options['patient_id'].to_i()
    @physio_id = options['physio_id'].to_i()
    @type = options['type']
    if (options['diagnosed']); @diagnosed = options['diagnosed']; else; @diagnosed = Date.today; end
    if (options['resolved']); @resolved = options['resolved']; else; @resolved = false; end
    @resolved = true if (options['resolved'] == "t" || options['resolved'] == "true" )
    @resolved = false if (options['resolved'] == "f" || options['resolved'] == "false" )
    @resolved_date = options['resolved_date'] if options['resolved_date']
    @notes = options['notes'] if options['notes']
  end

  def save()
      @id = SqlRunner.run("INSERT INTO conditions (patient_id, physio_id, type, diagnosed, resolved, resolved_date, notes) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id;", [@patient_id, @physio_id, @type, @diagnosed, @resolved, @resolved_date, @notes])[0]['id'].to_i()
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
    SqlRunner.run("UPDATE conditions SET (patient_id, physio_id, type, diagnosed, resolved, resolved_date, notes) = ($1, $2, $3, $4, $5, $6, $7) WHERE id = $8;", [@patient_id, @physio_d, @type, @diagnosed, @resolved, @resolved_date, @notes, @id])
  end

  def delete()
    SqlRunner.run("DELETE FROM conditions where id = $1;", [@id])
  end

  def resolve()
    SqlRunner.run("UPDATE conditions SET (resolved, resolved_date) = (true, $1) WHERE id = $2;", [Date.today, @id]) unless @resolved
  end

  def self.find(id)
    result = (SqlRunner.run("SELECT * FROM conditions WHERE id = $1;", [id]).first())
    return Condition.new(result) if (result != nil)
  end


  def patient()
    return Patient.new(SqlRunner.run("SELECT * FROM patients WHERE id = $1;", [@patient_id])[0])
  end

  def physio()
    return Physio.new(SqlRunner.run("SELECT * FROM physios WHERE id = $1;", [@physio_id])[0])
  end

end
