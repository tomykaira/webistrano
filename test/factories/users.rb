
Factory.sequence :login_name do |n|
  "user_%04d" % n
end

Factory.sequence :user_email do |n|
  "user_%04d@example.com" % n
end
  
Factory.define :user do |f|
  f.login       {  Factory.next :login_name }
  f.email       {  Factory.next :user_email }
  f.admin       false
  f.password    'hello!'
  f.password_confirmation { |a| a.password }
end
