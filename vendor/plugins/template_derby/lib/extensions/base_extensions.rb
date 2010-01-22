class Array
  
  def count(&cond) 
    inject(0){|acc, itm| cond.call(itm) ? (acc + 1) : acc }
  end  

  #TODO Recode using custom enumerator
  def indexes_for(&cond)
    inject([]){|acc,itm| (@i||='0').next!;  cond.call(itm) ? (acc + [@i.to_i-1]) : acc }
  end

  def first_index
    each_with_index{|e,i| return i if !e.blank?}
    nil
  end
  
  def group_by_field(field) 
    result = {} 
    each do |r| 
      result[r.send(field).to_s] ||= [] 
      result[r.send(field).to_s] << r 
    end
    result.values 
  end
  
  def avg
    sum/size
  end
  
  def index_if(&cond)
    each_with_index{|e,i| return i if cond.call(e)}
    nil
  end
end

class Object
  
  def numeric?
    true if Float(self) rescue false
  end
  
  # Often nice to ask e.g. some_object.is_a?(Symbol, String)
  alias_method :is_a_without_multiple_args?, :is_a?
  def is_a?(*args)
    args.any? {|a| is_a_without_multiple_args?(a) }
  end
end

class Float
  alias_method :orig_to_s, :to_s
  def to_s(arg = nil)
    if arg.nil?
      orig_to_s
    else
      sprintf("%.#{arg}f", self)
    end
  end
end