module Merb
  module GlobalHelpers
    # Append "... read more" link to the end of the string. If the string is
    # longer than `size', truncate it.
    #
    # ==== Parameters
    # string<String>:: A string to append the link to
    # object<Object>:: 
    #   An object that you wish to link to. resource(*object) will be called
    #   on the object, so you can pass in a single element, such as @article,
    #   and resource(@article) will be called, or you can pass in an Array,
    #   such as [:admin, @article], and resource(:admin, @article) will be called
    # size<Integer>:: The maximum size of the string before truncation
    def read_more(string, object, size = 30)
      return if string.nil?
      link = link_to("... read more", resource(*object))
      "#{string.truncate(size, '')}#{link}"
    end
    
    def submit_text
      action_name == "new" ? "Create" : "Update"
    end
  end
end
