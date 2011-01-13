
Factory.sequence :project_configuration_name do |n|
  "Project Configuration %04d" % n
end

Factory.sequence :project_configuration_value do |n|
  "Value %04d" % n
end
  
Factory.define :project_configuration do |f|
  f.project { |a| a.association(:project) }
  f.name    { Factory.next :project_configuration_name  }
  f.value   { Factory.next :project_configuration_value }
  f.prompt_on_deploy 0
end
