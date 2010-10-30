module Adva
  module View
    class Menu
      class Items < Array
        def insert(text, url, options, block)
          item = [text, url, options, block]
          if ix = index(options.delete(:before))
            super(ix, item)
          elsif ix = index(options.delete(:after))
            super(ix + 1, item)
          elsif ix = index(options.delete(:replace))
            self[ix] = item
          else
            push(item)
          end
        end

        def index(text)
          each_with_index { |item, ix| return ix if item[0] == text } and nil
        end
      end
    end
  end
end
