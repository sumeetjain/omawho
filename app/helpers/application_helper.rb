module ApplicationHelper
  def form_errors(form_model, model_name="form")
    render :partial => "layouts/form_errors", :locals => {:form_model => form_model, :model_name => model_name}
  end
  
  def page_title
    if @page_title.present?
      raw "Omawho - #{@page_title}"
    else
      "Omawho"
    end
  end
  
  def page_description
    if @page_description.present?
      raw @page_description
    else
      raw "The faces of Omaha's creative community. Add your own face to the gallery for free."
    end
  end
  
  def blurb
    if @blurb.present?
      @blurb
    else
      "The faces of Omaha's creative community."
    end
  end
end
