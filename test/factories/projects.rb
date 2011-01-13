
Factory.sequence :project_name do |n|
  "Project %04d" % n
end
  
Factory.define :project do |f|
  f.name        {  Factory.next :project_name }
  f.description "A description for this project"
  f.template    'rails'
end
