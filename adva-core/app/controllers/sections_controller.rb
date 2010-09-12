class SectionsController < BaseController
  abstract_actions :except => :index
end