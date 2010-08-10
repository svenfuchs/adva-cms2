class Admin::Articles::Edit < Minimal::Template
  def to_html
    link_to "Settings", resources.unshift(:edit)[0..-2] # TODO
    h2 :'.title'
    render 'form'
  end
end