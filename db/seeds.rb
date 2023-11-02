Async do |task|
  LINES.each { |line| Line.create(name: line, booked: false) }
  3.times do |i|
    task.async do
      user = User.create!(name: Faker::Name.first_name, email: "operator#{i+1}@jenfi.com", role: "operator", password: "password", jti: SecureRandom.uuid)
      Train.create!(operator: user, name: Faker::Name.first_name, cost: (i + 1) * 100, weight: (i + 1) * 10, volume: (i + 1) * 10, lines: LINES.sample(2))
    end
  end
  3.times do |i|
    task.async do
      user = User.create!(name: Faker::Name.first_name, email: "owner#{i+1}@jenfi.com", role: "owner", password: "password", jti: SecureRandom.uuid)
      10.times do |j|
        task.async do
          Parcel.create!(owner: user, weight: i * ((j + 1) / 2), volume: i * ((j + 1) / 3))
        end
      end
    end
  end
  User.create!(name: Faker::Name.first_name, email: "postmaster@jenfi.com", role: "postmaster", password: "password", jti: SecureRandom.uuid)
end.wait
