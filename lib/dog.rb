class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end

    self
  end

  def self.create(dog_hash)
    name = dog_hash[:name]
    breed = dog_hash[:breed]

    dog = Dog.new(name: name, breed: breed)

    dog.save
  end

  def self.find_by_id(search_id)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE id = ?
    SQL

    dog_arr = DB[:conn].execute(sql, search_id)
    dog_arr.flatten!
    id = dog_arr[0]
    name = dog_arr[1]
    breed = dog_arr[2]

    dog = Dog.new(id: id, name: name, breed: breed)
    dog
  end

  def self.find_or_create_by(search_id)
    if self.id
      self.find_by_id(search_id)
    else
      
    end
  end

  def self.new_from_db
  end

  def self.find_by_name()
  end

  def update
    sql = <<-SQL
      UPDATE dogs
      SET name = ?, breed = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

end
