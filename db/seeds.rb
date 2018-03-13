admin = User.create! do |user|
         user.name             = 'admin'
         user.email            = 'admin@example.com'
         user.password         = 'adminadmin'
         user.confirmed_at     = Time.now
         user.role             = 'admin'
         user.bypass_humanizer = true
       end

editor = User.create! do |user|
          user.name             = 'editor'
          user.email            = 'editor@example.com'
          user.password         = 'editoreditor'
          user.confirmed_at     = Time.now
          user.bypass_humanizer = true
        end

user = User.create! do |user|
         user.name             = 'user'
         user.email            = 'user@example.com'
         user.password         = 'useruser'
         user.confirmed_at     = Time.now
         user.bypass_humanizer = true
       end

location = Location.create! do |location|
            location.title = 'Zürich'
           end

campus = Campus.create! do |campus|
           campus.title = 'Zentrum',
           campus.location = location
         end

building = Building.create! do |building|
            building.title = 'Toniareal',
            building.address = 'Pfingstweidstrasse 96, 8005 Zürich',
            building.campus = campus
end

floor = Floor.create! do |floor|
          floor.title = '10',
          floor.building = building
end
