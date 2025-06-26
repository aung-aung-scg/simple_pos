module ApplicationHelper
  def devise_error_messages!
    return "" unless devise_controller? && resource.errors.any?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      <h4 class="alert-heading">#{pluralize(resource.errors.count, "error")} prohibited this action:</h4>
      <ul class="mb-0">#{messages}</ul>
    </div>
    HTML
    html.html_safe
  end
end
