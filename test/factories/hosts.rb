
Factory.sequence :host_name do |n|
  "%04d.example.com" % n
end
  
Factory.define :host do |f|
  f.name {  Factory.next :host_name }
end
