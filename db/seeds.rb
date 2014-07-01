puts 'Add users'
kristen = User.where(email: 'kristen.hanny@gmail.com').first_or_initialize
password = SecureRandom.hex
kristen.password = password
kristen.password_confirmation = password
puts "\temail: #{kristen.email}"
puts "\tpassword: #{password}"
kristen.save!
