
Factory.sequence :stage_name do |n|
  "Stage %04d" % n
end
  
Factory.define :stage do |f|
  f.name    {  Factory.next :stage_name }
  f.project { |a| a.association(:project) }
end
