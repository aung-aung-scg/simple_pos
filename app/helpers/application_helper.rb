module ApplicationHelper
  # Devise Error Messages
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

  # Flash Message Class Helper
  def bootstrap_alert_class(flash_type)
    case flash_type.to_sym
    when :notice, :success then "success"
    when :alert, :error, :danger then "danger"
    when :warning then "warning"
    when :info then "info"
    else flash_type.to_s
    end
  end

  # Sorting Helper
  def sortable(column, title = nil, options = {})
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    default_options = {
      class: "text-decoration-none d-flex align-items-center gap-1",
      data: { turbo_action: "replace" }
    }
    options = default_options.merge(options)

    link_to({ sort: column, direction: direction }, options) do
      safe_join([
        title,
        content_tag(:span, class: "sort-indicators ms-1") do
          if column == sort_column
            content_tag(:i, "", class: "fas fa-sort-#{sort_direction == 'asc' ? 'up' : 'down'} text-primary")
          else
            content_tag(:i, "", class: "fas fa-sort text-muted")
          end
        end
      ])
    end
  end

  # Current Sort Column
  def sort_column
    params[:sort] || default_sort_column
  end

  # Current Sort Direction
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default_sort_direction
  end

  private

  # Default sort column (override in controllers)
  def default_sort_column
    "created_at"
  end

  # Default sort direction (override in controllers)
  def default_sort_direction
    "desc"
  end
end
