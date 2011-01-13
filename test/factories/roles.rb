
Factory.sequence :role_name do |n|
  "Role %04d" % n
end
  
Factory.define :role do |f|
  f.name        {  Factory.next :role_name }
  f.stage       { |a| a.association(:stage) }
  f.host        { |a| a.association(:host) }
  f.primary     0
  f.no_release  0
  f.no_symlink  0
end
