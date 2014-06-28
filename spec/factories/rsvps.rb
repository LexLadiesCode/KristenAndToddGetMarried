FactoryGirl.define do
  factory :rsvp do
    first_name 'Jane'
    last_name 'Doe'
    email 'jane.doe@example.com'

    trait :attending do
      guest_count 3
      attending true
      song_suggestion 'Boogie Woogie Wu by the Insane Clown Posse'
    end

    trait :not_attending do
      guest_count 0
      attending false
    end
  end
end
