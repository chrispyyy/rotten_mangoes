class Movie < ActiveRecord::Base

  mount_uploader :image, ImageUploader 

  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :poster_image_url,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  def review_average
    if reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      return 0
    end
  end

# multiple searches calling one method passing 1 param
# class << self
#   
#   def search(search)
#      title = search[:title]
#      director = search[:director]
#      return search_title(title).search_director(director) 
#    end

#    def search_title(title)
#      if title.present?
#        where("title LIKE ?", "%#{title}%")
#      else
#        where('') #all
#      end
#    end

#    def search_director(director)
#      if director.present?
#        where("director LIKE ?", "%#{director}%")
#      else
#        where('')
#      end
#    end
# end



#for single search with either title or director
  def self.search_movie(search_input)
    self.where("title LIKE ? OR director LIKE ?", "%#{search_input}%", "%#{search_input}%") 
    # q = "%#{params[:query]}%"
    # User.where("name like ? or description like ?", q, q).to_sql
  end

# #for multiple searches with multiple text areas
#   def self.search(title,director)
#     if title && director.blank?
#       result = self.where("title LIKE ?", "%#{title}#%")
#     elsif title.blank? && director
#       result = self.where("director LIKE ?", "%#{director}#%")
#     elsif title && director
#       result = self.where("title LIKE ? OR title LIKE ?", "%#{title}#%", "%#{director}#%")
#     else
#       self.all
#     end
#   end

 #for run time search 
  def self.search_runtime(runtime)
    case runtime 
    when "under90" then self.runtime_under(90)
    when "between90_120" then self.runtime_over(90).runtime_under(120)
    when "over120" then self.runtime_over(120) 
    else
      self.all 
    end
  end

  def self.runtime_under(value)
    self.where('runtime_in_minutes < ?', value)
  end

  def self.runtime_over(value)
    self.where('runtime_in_minutes > ?', value)
  end

  def self.search(search_input, runtime)
    self.search_movie(search_input).search_runtime(runtime)
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the past, these are released movies") if release_date > Date.today
    end
  end

end
