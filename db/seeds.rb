# frozen_string_literal: true

user1 = User.create!(
  username: 'madihakreeti',
  email: 'madiha.mallick@kreeti.com',
  password: '12345'
)

user2 = User.create!(
  username: 'madihamallick',
  email: 'mallickmadiha9031@gmail.com',
  password: '12345'
)

usernames = %w[
  john123 sarah89 alexander emily22 lucas007
  olivia2000 davidm sophie21 michael23 emma_rose
]
emails = [
  'john123@example.com', 'sarah89@example.com', 'alexander@example.com',
  'emily22@example.com', 'lucas007@example.com', 'olivia2000@example.com',
  'davidm@example.com', 'sophie21@example.com', 'michael23@example.com',
  'emma_rose@example.com'
]

users = []
10.times do |i|
  user = User.create!(
    username: usernames[i],
    email: emails[i],
    password: '12345'
  )
  users << user
end

project_names = [
  'Plag Checker',
  'Task Manager',
  'Hospital Manager',
  'Medibuddy',
  'Trading Guide'
]

projects = []
project_names.each do |name|
  project = Project.create!(
    name:,
    user_id: user1.id
  )
  projects << project
end

detail_names = [
  'Create Landing Page',
  'Add Login Page',
  'Add values to dropdown',
  'Format the code',
  'Fix Bugs',
  'Detail About Page',
  'Add Contact Page',
  'Remove Comments',
  'Make Page responsive',
  'Add Modal in Edit'
]

detail_descriptions = [
  'Create a visually appealing landing page for the website.',
  'Implement a login page with proper authentication and user validation.',
  'Populate the dropdown menu with the required values from the database.',
  'Apply proper formatting to the codebase for readability and maintainability.',
  'Identify and fix any bugs or errors in the code.',
  'Design and develop a detailed About page with relevant information.',
  'Integrate a contact page to allow users to get in touch.',
  'Remove unnecessary comments from the codebase.',
  'Ensure that the web page displays correctly on different devices and screen sizes.',
  'Implement a modal window for editing data in a user-friendly manner.'
]

# rubocop:disable Metrics/BlockLength
projects.each do |project|
  file_names = [
    'file1.jpg',
    'file2.jpeg',
    'file3.jpeg',
    'file4.png',
    'file5.doc',
    'file6.docx',
    'file7.xls',
    'file8.pdf',
    'file9.xlsx',
    'file10.pdf'
  ]

  file_names.each_with_index do |file_name, i|
    file_path = Rails.root.join('app', 'assets', 'files', file_name)

    status = rand(0..2)
    flag_type = rand(0..2)

    detail = Detail.create!(
      project_id: project.id,
      title: detail_names[i],
      description: detail_descriptions[i],
      status:,
      flagType: flag_type,
      uuid: SecureRandom.uuid
    )
    detail.file.attach(io: File.open(file_path), filename: file_name)
    project.details << detail
  end
  project.users << user1

  random_users = users.sample(2)
  project.users << user2
  project.users << random_users

  project.details.each do |detail|
    project_users = project.users
    detail_users_to_add = project_users.first
    detail.users << detail_users_to_add

    5.times do |index|
      status = rand(0..1)
      task = Task.create!(
        name: "Task #{index + 1} for (#{detail.title})",
        status:,
        detail_id: detail.id
      )
      detail.tasks << task
    end
  end
end
# rubocop:enable Metrics/BlockLength
