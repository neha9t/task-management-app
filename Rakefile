# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

if defined?(RSpec)
  desc 'Run Model specs.'
  RSpec::Core::RakeTask.new(:task_spec) do |t|
    t.pattern = './spec/models/task_spec.rb'
  end
end

task spec: :task_spec
#task spec: :tasks_controller_spec
