
Factory.sequence :stage_configuration_name do |n|
  "Stage Configuration %04d" % n
end

Factory.sequence :stage_configuration_value do |n|
  "Value %04d" % n
end
  
Factory.define :stage_configuration do |f|
  f.stage { |a| a.association(:stage) }
  f.name  { Factory.next :stage_configuration_name  }
  f.value { Factory.next :stage_configuration_value }
  f.prompt_on_deploy 0
end
