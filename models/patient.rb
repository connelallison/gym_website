require_relative("../db/sql_runner.rb")
require_relative("./physio.rb")
require_relative("./condition.rb")

class Patient

  attr_reader :id
  attr_accessor :patient_name, :member_id

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @patient_name = options['patient_name']
    @member_id = options['member_id'].to_i() if options['member_id']
    @membership = true if options['member_id']
    @membership = false unless options['member_id']
  end

  def save()
    if (@member_id)
      @id = SqlRunner.run("INSERT INTO patients (patient_name, member_id) VALUES ($1, $2) RETURNING id;", [@patient_name, @member_id])[0]['id'].to_i()
    else
      @id = SqlRunner.run("INSERT INTO patients (patient_name) VALUES ($1) RETURNING id;", [@patient_name])[0]['id'].to_i()
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

  def add_condition(physio, type)
    condition = Condition.new('patient_id' => self.id, 'physio_id' => physio.id, 'type' => type)
    return condition
  end

  def self.find(id)
    result = (SqlRunner.run("SELECT * FROM patients WHERE id = $1;", [id]).first())
    return Patient.new(result) if (result != nil)
  end

  def physios()
    return SqlRunner.run("SELECT physios.* FROM conditions INNER JOIN physios ON conditions.physio_id = physios.id WHERE conditions.patient_id = $1;", [@id]).uniq().map() { |physio| Physio.new(physio) }
  end

  def physio_ids()
    return SqlRunner.run("SELECT physios.id FROM conditions INNER JOIN physios ON conditions.physio_id = physios.id WHERE conditions.patient_id = $1;", [@id]).uniq().map() { |physio| physio["id"].to_i() }
  end

  def conditions()
    return SqlRunner.run("SELECT * FROM conditions WHERE conditions.patient_id = $1;", [@id]).map() { |condition| Condition.new(condition) }
  end

  def condition_ids()
    return SqlRunner.run("SELECT id FROM conditions WHERE conditions.patient_id = $1;", [@id]).map() { |condition| condition['id'].to_i() }
  end

  def conditions_by_physio(physio)
    return SqlRunner.run("SELECT * FROM conditions WHERE (conditions.patient_id, conditions.physio_id) = ($1, $2);", [@id, physio.id]).map() { |condition| Condition.new(condition) }
  end

end
