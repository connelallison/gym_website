require('pg')

class SqlRunner

  def self.run( sql, values = [] )
    begin
      db = PG.connect({
        dbname: 'devfrng213vir8',
        host: 'ec2-107-21-99-237.compute-1.amazonaws.com',
        port: 5432,
        user:'qkyakemblfpaow',
        password: '1318284a10d680c924cea5db20bba921963c319797a5f25ecbb415f7813e9467'
      })
      db.prepare("query", sql)
      result = db.exec_prepared( "query", values )
    ensure
      db.close() if (db != nil)
    end
    return result
  end

end
