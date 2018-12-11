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
      @id = SqlRunner.run("INSERT INTO physios (physio_name) VALUES ($1) RETURNING id;", [@physio_name])[0]['id'].to_i()
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

  def add_condition(patient, type)
    condition = Condition.new('patient_id' => patient.id, 'physio_id' => self.id, 'type' => type)
    return condition
  end

  def self.find(id)
    result = (SqlRunner.run("SELECT * FROM physios WHERE id = $1;", [id]).first())
    return Physio.new(result) if (result != nil)
  end

  def patients()
    return SqlRunner.run("SELECT patients.* FROM conditions INNER JOIN patients ON conditions.patient_id = patients.id WHERE conditions.physio_id = $1;", [@id]).uniq().map() { |patient| Patient.new(patient) }
  end

  def patient_ids()
    return SqlRunner.run("SELECT patients.id FROM conditions INNER JOIN patients ON conditions.patient_id = patients.id WHERE conditions.physio_id = $1;", [@id]).uniq().map() { |patient| patient["id"].to_i() }
  end

  def conditions()
    return SqlRunner.run("SELECT * FROM conditions WHERE conditions.physio_id = $1;", [@id]).map() { |condition| Condition.new(condition) }
  end

  def condition_ids()
    return SqlRunner.run("SELECT id FROM conditions WHERE conditions.physio_id = $1;", [@id]).map() { |condition| condition['id'].to_i() }
  end

  def current_conditions()
    return SqlRunner.run("SELECT * FROM conditions WHERE (conditions.physio_id, conditions.resolved) = ($1, $2);", [@id, false]).map() { |condition| Condition.new(condition) }
  end

  def current_condition_ids()
    return SqlRunner.run("SELECT id FROM conditions WHERE (conditions.physio_id, conditions.resolved) = ($1, $2);", [@id, false]).map() { |condition| condition['id'].to_i() }
  end

  def resolved_conditions()
    return SqlRunner.run("SELECT * FROM conditions WHERE (conditions.physio_id, conditions.resolved) = ($1, $2);", [@id, true]).map() { |condition| Condition.new(condition) }
  end

  def resolved_condition_ids()
    return SqlRunner.run("SELECT id FROM conditions WHERE (conditions.physio_id, conditions.resolved) = ($1, $2);", [@id, true]).map() { |condition| condition['id'].to_i() }
  end

  def conditions_by_patient(patient)
    return SqlRunner.run("SELECT * FROM conditions WHERE (conditions.physio_id, conditions.patient_id) = ($1, $2);", [@id, patient.id]).map() { |condition| Condition.new(condition) }
  end

  def current_conditions_by_patient(patient)
    return SqlRunner.run("SELECT * FROM conditions WHERE (conditions.physio_id, conditions.patient_id, conditions.resolved) = ($1, $2, $3);", [@id, patient.id, false]).map() { |condition| Condition.new(condition) }
  end

  def resolved_conditions_by_physio(physio)
    return SqlRunner.run("SELECT * FROM conditions WHERE (conditions.physio_id, conditions.patient_id, conditions.resolved) = ($1, $2, $3);", [@id, patient.id, false]).map() { |condition| Condition.new(condition) }
  end

end
