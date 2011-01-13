class StageConfiguration < ConfigurationParameter
  belongs_to :stage
  
  validates :stage,
    :presence => true
  validates :name,
    :uniqueness => { :scope => :stage_id }
end
