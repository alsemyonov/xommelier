module Xommelier
  # This version of the Atom schema is based on version 1.0 of the format specifications,
  # found here http://www.atomenabled.org/developers/syndication/atom-format-spec.php.
  xmlns :"http://www.w3.org/2005/Atom", as: nil do
  
    import :"http://www.w3.org/XML/1998/namespace"
    # An Atom document may have two root elements, feed and entry, as defined in section 2.
    element :feed, type: :feedType
    element :entry, type: :entryType
    complex :textType do
    
      sequence  do
        any ns: nil  
      end
      attribute :type do
        simple  do
          restricts on: nil, in: ["text", "html", "xhtml"]  
        end  
      end
      attributes :commonAttributes  
    end
    complex :personType do
    
      choice min: 1, max: nil do
        element :name, type: nil
        element :uri, type: :uriType
        element :email, type: :emailType
        any ns: nil  
      end
      attributes :commonAttributes  
    end
    simple :emailType do
    
      restricts on: nil, pattern: nil  
    end
    complex :feedType do
    
      choice min: 3, max: nil do
        element :author, type: :personType
        element :category, type: :categoryType
        element :contributor, type: :personType
        element :generator, type: :generatorType
        element :icon, type: :iconType
        element :id, type: :idType
        element :link, type: :linkType
        element :logo, type: :logoType
        element :rights, type: :textType
        element :subtitle, type: :textType
        element :title, type: :textType
        element :updated, type: :dateTimeType
        element :entry, type: :entryType
        any ns: nil  
      end
      attributes :commonAttributes  
    end
    complex :entryType do
    
      choice max: nil do
        element :author, type: :personType
        element :category, type: :categoryType
        element :content, type: :contentType
        element :contributor, type: :personType
        element :id, type: :idType
        element :link, type: :linkType
        element :published, type: :dateTimeType
        element :rights, type: :textType
        element :source, type: :textType
        element :summary, type: :textType
        element :title, type: :textType
        element :updated, type: :dateTimeType
        any ns: nil  
      end
      attributes :commonAttributes  
    end
    complex :contentType do
    
      sequence  do
        any ns: nil  
      end
      attribute :type, type: nil
      attribute :src, type: nil
      attributes :commonAttributes  
    end
    complex :categoryType do
    
      attribute :term, type: nil
      attribute :scheme, type: nil
      attribute :label, type: nil
      attributes :commonAttributes  
    end
    complex :generatorType do
    
      simple_content  do
        extends :"xs:string" do
          attribute :uri, type: nil
          attribute :version, type: nil
          attributes :commonAttributes  
        end  
      end  
    end
    complex :iconType do
    
      simple_content  do
        extends :"xs:anyURI" do
          attributes :commonAttributes  
        end  
      end  
    end
    complex :idType do
    
      simple_content  do
        extends :"xs:anyURI" do
          attributes :commonAttributes  
        end  
      end  
    end
    complex :linkType do
    
      attribute :href, type: nil
      attribute :rel, type: nil
      attribute :type, type: nil
      attribute :hreflang, type: nil
      attribute :title, type: nil
      attribute :length, type: nil
      attributes :commonAttributes  
    end
    complex :logoType do
    
      simple_content  do
        extends :"xs:anyURI" do
          attributes :commonAttributes  
        end  
      end  
    end
    complex :sourceType do
    
      choice max: nil do
        element :author, type: :personType
        element :category, type: :categoryType
        element :contributor, type: :personType
        element :generator, type: :generatorType
        element :icon, type: :iconType
        element :id, type: :idType
        element :link, type: :linkType
        element :logo, type: :logoType
        element :rights, type: :textType
        element :subtitle, type: :textType
        element :title, type: :textType
        element :updated, type: :dateTimeType
        any ns: nil  
      end
      attributes :commonAttributes  
    end
    complex :uriType do
      simple_content  do
        extends :"xs:anyURI" do
          attributes :commonAttributes  
        end  
      end  
    end
    complex :dateTimeType do
      simple_content  do
        extends :"xs:dateTime" do
          attributes :commonAttributes  
        end  
      end  
    end
    attributes  do
      any_attributes ns: nil  
    end  
  end
end
