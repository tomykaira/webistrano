
Factory.sequence :recipe_name do |n|
  "Recipe %04d" % n
end
  
Factory.define :recipe do |f|
  f.name        {  Factory.next :recipe_name }
  f.description "A description for this recipe"
  f.body        '# a recipe'
end
