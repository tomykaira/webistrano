
Factory.sequence :task_name do |n|
  "task-%04d" % n
end

Factory.sequence :revision do |n|
  "rev-%04d" % n
end
  
Factory.define :deployment do |f|
  f.stage    { |a| a.association(:stage) }
  f.user     { |a| a.association(:user)  }
  f.task     { Factory.next :task_name }
  f.revision { Factory.next :revision  }
  f.status   'running'
  f.prompt_config({})
  f.roles([])
  f.excluded_host_ids([])
  f.override_locking false
  f.description "A deployment description"
end
