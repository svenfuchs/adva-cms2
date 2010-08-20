module Adva
  module Importers
    class Directory
      class Section < Path
        include Loadable
        
        class << self
          def section_types
            [Blog, Page]
          end
          
          def build(path)
            paths = path.all.reject { |path| File.basename(path) == 'site.yml' }
            sections = section_types.map { |type| type.build(paths) }.flatten
            root = sections.detect { |section| section.root? }
            
            sections.sort! { |a, b| a.to_s.length <=> b.to_s.length }
            # sections.each { |s| puts s.to_s }
            
            # children = sections.dup
            # sections.each do |section|
            #   children.each do |child|
            #     puts "? #{dirname(child.local_path.to_s).inspect} < #{section.local_path.to_s.inspect}"
            #     if dirname(child.local_path.to_s) == section.local_path.to_s
            #       puts "! #{section.local_path.inspect} < #{child.local_path.inspect}"
            #       child.section.parent = section.section
            #       children.delete(child)
            #     end
            #   end
            # end
            
            
            # FIXME should really build up the sectin tree
            # sections.each { |section| section.section.parent = root.section }
            # sections.delete(root)
            # sections.unshift(root)
            sections.compact
          end
        
          def dirname(path)
            File.dirname(path).tap { |dirname| dirname.replace('') if dirname == '.' }
          end
        end
          
        def loadable
          root? ? Path.new("#{self}/index.yml") : self
        end
        
        def title
          @title ||= root? ? 'Home' : local_path.to_s.titleize
        end
      end
    end
  end
end