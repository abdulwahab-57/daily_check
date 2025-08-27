module ProjectsHelper
  def status_badge(project)
    colors = {
      "draft" => "bg-gray-100 text-gray-800 ring-1 ring-gray-300",
      "active" => "bg-indigo-100 text-indigo-800 ring-1 ring-indigo-300",
      "archived" => "bg-amber-100 text-amber-800 ring-1 ring-amber-300",
      "completed" => "bg-emerald-100 text-emerald-800 ring-1 ring-emerald-300"
    }

    content_tag(:span, project.status.humanize,
      class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{colors[project.status]}")
  end
end
