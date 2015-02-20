# encoding: UTF-8
require 'unicode_utils'

class String
  def downcase
    UnicodeUtils.downcase self
  end
  def downcase!
    self.replace downcase
  end
  def upcase
    UnicodeUtils.upcase self
  end
  def upcase!
    self.replace upcase
  end
  def capitalize
    UnicodeUtils.titlecase self
  end
  def capitalize!
    self.replace capitalize
  end
  def ucfirst
    self.gsub(/^([а-яa-z])/) {|c| c.upcase}
  end
  def ucfirst!
    self.replace ucfirst
  end
end